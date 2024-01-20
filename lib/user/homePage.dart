import 'dart:async';
import 'dart:convert';
import 'package:dash/Drawer.dart';
import 'package:dash/Mainpage.dart/Category/mainCategory.dart';
import 'package:dash/Mainpage.dart/Doctors/doctor.dart';
import 'package:dash/Mainpage.dart/Doctors/search/findDoctorList.dart';
import 'package:dash/user/unit/category.dart';
import 'package:dash/user/unit/doctor.dart';
import 'package:dash/user/doctorsfF.dart';
import 'package:dash/user/searchDoctor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'doctorappointment/doctorapp.dart';
import 'medicine/medicineSchedule.dart';
import 'unit/medicineList.dart';

late User signedinuser;

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  
  List prescriptions = [];
  Map<String, dynamic> User = {};
  final storage = const FlutterSecureStorage();
  String userId = '';
  String point = '';
  int p = 0;


  Future<String> getTokenFromStorage() async {
    final token = await storage.read(key: 'jwt');
    if (token != null) {
      final String userId = getUserIdFromToken(token);
      await Future.delayed(const Duration(seconds: 2));
      return userId;
    } else {
      print('Token not found in local storage.');
      return '';
    }
  }

  String getUserIdFromToken(String token) {
    try {
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      final String userId = decodedToken['id'];
      return userId;
    } catch (e) {
      print('Error decoding token: $e');
      return '';
    }
  }

  Future<void> getPrescription() async {
    try {
      String id = await getTokenFromStorage();
      var url = "https://marham-backend.onrender.com/prescription/forUser/$id";
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var responseBody = response.body.toString();
        responseBody = responseBody.trim();
        responseBody = responseBody.substring(17, responseBody.length - 1);
        var pre = jsonDecode(responseBody);

        // Convert date strings to DateTime and sort by dateFrom in descending order
        pre.sort((a, b) {
          DateTime dateA = DateFormat('MM/dd/yyyy').parse(a['dateFrom']);
          DateTime dateB = DateFormat('MM/dd/yyyy').parse(b['dateFrom']);
          return dateB.compareTo(dateA);
        });

        // Format the sorted date as dd/mm/yyyy
        DateFormat fromFormat = DateFormat('dd/MM/yyyy');
        for (var prescription in pre) {
          prescription['dateFrom'] = fromFormat
              .format(DateFormat('MM/dd/yyyy').parse(prescription['dateFrom']));
          prescription['dateTo'] = fromFormat
              .format(DateFormat('MM/dd/yyyy').parse(prescription['dateTo']));
        }
        // Check if the widget is still mounted before calling setState
        if (mounted) {
          setState(() {
            prescriptions.clear();
            prescriptions.addAll(pre);
          });
        }
      }
    } catch (e) {
      // Handle the error, e.g., print or log it
      print('Error fetching prescriptions: $e');
    }
  }

  Future getUserInfo() async {
    String userid = await getTokenFromStorage();
    var url = "https://marham-backend.onrender.com/giveme/getUser/$userid";

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var responceBody = response.body.toString();
        responceBody = responceBody.trim();
        var user = jsonDecode(responceBody);

        // Check if the widget is still mounted before calling setState
        if (mounted) {
          setState(() {
            User.addAll(user);
          });
        }
      }
    } catch (e) {
      // Handle the error, e.g., print or log it
      print('Error fetching user info: $e');
    }
  }

  Future<String> getDoctor(String docId) async {
    var url = "https://marham-backend.onrender.com/doctor/$docId";
    var response = await http.get(Uri.parse(url));
    var responceBody = response.body.toString();
    responceBody = responceBody.trim();
    var doc = jsonDecode(responceBody);

    return doc['name'];
  }

  Future getAppointment() async {
    String id = await getTokenFromStorage();
    var url = "https://marham-backend.onrender.com/prescription/forUser/$id";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var responceBody = response.body.toString();
      responceBody = responceBody.trim();
      responceBody = responceBody.substring(17, responceBody.length - 1);
      var pre = jsonDecode(responceBody);

      // Convert date strings to DateTime and sort by dateFrom in descending order
      pre.sort((a, b) {
        DateTime dateA = DateFormat('MM/dd/yyyy').parse(a['dateFrom']);
        DateTime dateB = DateFormat('MM/dd/yyyy').parse(b['dateFrom']);
        return dateB.compareTo(dateA);
      });

      // Format the sorted date as dd/mm/yyyy
      DateFormat fromFormat = DateFormat('dd/MM/yyyy');
      for (var prescription in pre) {
        prescription['dateFrom'] = fromFormat
            .format(DateFormat('MM/dd/yyyy').parse(prescription['dateFrom']));
        prescription['dateTo'] = fromFormat
            .format(DateFormat('MM/dd/yyyy').parse(prescription['dateTo']));
      }
      if (mounted) {
        setState(() {
          prescriptions.clear();
          prescriptions.addAll(pre);
        });
      }
    }
  }

  Future getPrice() async {
    String id = await getTokenFromStorage();
    var url = "https://marham-backend.onrender.com/payment/points/$id/12";

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var responseBody = response.body.toString();
        responseBody = responseBody.trim();
        var app = jsonDecode(responseBody);

        print(response.body);
        print(app);
        if (app != null && app is Map<String, dynamic>) {
          if (mounted) {
            setState(() {
              p = app['point'];
              point = p.toString();
            });
          }
        } else {
          print('Unexpected response structure: $app');
        }
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during network request: $error');
    }
  }
  List categories = [];
  List doctors = [];
  final List _doctors = [];
  List _foundedDoctors = [];

  bool display = false;

  Future<void> getCategories() async {
    var url = "https://marham-backend.onrender.com/category/";

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var responceBody = response.body.toString();
        responceBody = responceBody.trim();
        responceBody = responceBody.substring(14, responceBody.length - 1);
        var cat = jsonDecode(responceBody);
        if (mounted) {
          setState(() {
            categories.addAll(cat);
          });
        }
      } else {
        // Handle the error when the HTTP request fails
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other types of errors, such as network errors
      print('Error: $error');
    }
  }

  Future<String> getCategory(String catId) async {
    var url = "https://marham-backend.onrender.com/category/$catId";
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var responseBody = response.body.toString();

      if (responseBody.length >= 12) {
        responseBody = responseBody.trim();
        responseBody = responseBody.substring(12, responseBody.length - 1);
        var cat = jsonDecode(responseBody);

        if (cat.containsKey('name')) {
          return cat['name'];
        } else {
          return "";
        }
      }
    }

    // Return a default value or an error message in case of issues
    return 'Category not found';
  }

  Future<List<dynamic>> getDoctors() async {
    var url = "https://marham-backend.onrender.com/doctor/";

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var responceBody = response.body.toString();
      responceBody = responceBody.trim();
      responceBody = responceBody.substring(11, responceBody.length - 1);
      var doc = jsonDecode(responceBody);
      setState(() {
        _doctors.addAll(doc);
      });
    }
    return []; // Return an empty list if there's an error
  }

  void navigateToNextPageWithCategory(String categoryId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DoctorsPage(categoryId: categoryId),
      ),
    );
  }

  Future<void> getcurrentUser() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (mounted) {
          setState(() {
            signedinuser = user;
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  onSearch(String search) {
    setState(() {
      _foundedDoctors = _doctors
          .where((doctor) => doctor['name'].toLowerCase().contains(search))
          .toList();
    });
  }

  @override
  void initState() {
    getCategories();
    super.initState();
    getDoctors();
    setState(() {
      _foundedDoctors = _doctors;
      doctors = _doctors;
    });
    getPrescription();
    getUserInfo();
    getPrice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title: Padding(
          padding: const EdgeInsets.only(left: 200.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.blue,
                width: 2.0,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            width: 600,
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, bottom: 10),
                    child: TextFormField(
                      onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => searchDoctor(),
                                  ),
                                );
                      },
                      onChanged: (value) => onSearch(value),
                      decoration: InputDecoration(
                        hintText: 'Search for a doctor',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.search,
                    size: 20.0,
                  ),
                  onPressed: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => searchDoctor(),
                    //   ),
                    // );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      //drawer: DrawerWidget(context),
      body: Row(
        children: [
          Container(
            width: 960,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Find Your',
                            style:
                                TextStyle(fontSize: 20.0, fontFamily: 'Salsa'),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Text(
                            ' Specialist',
                            style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Salsa'),
                          )
                        ],
                      ),
                    
                    ],
                  ),
                ),
                const SizedBox(height: 15.0),
                //category
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Categories',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 23,
                              fontFamily: 'Salsa')),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 100.0,
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return category(
                          icon: '${categories[index]['image']['secure_url']}',
                          categoryName: '${categories[index]['name']}',
                          onTap: () => navigateToNextPageWithCategory(
                              '${categories[index]['_id']}'),
                        );
                      }),
                ),
                const SizedBox(
                  height: 25,
                ),
                //doc
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Suggestion',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontFamily: 'Salsa')),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 240.0,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                        future: getCategory('${doctors[index]['categoryId']}'),
                        builder: (context, categorySnapshot) {
                          if (categorySnapshot.hasError) {
                            return Text('Error: ${categorySnapshot.error}');
                          } else {
                            return doctor(
                              doctorPic:
                                  '${doctors[index]['image']['secure_url']}',
                              doctorRate: '${doctors[index]['rate']}',
                              doctorName: '${doctors[index]['name']}',
                              doctorCat: categorySnapshot.data.toString(),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => appointment(doctor: doctors[index]),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 50,),
         
          SingleChildScrollView(
            child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top:20.0),
            child: Container(
              child: Column(children: [
                User.isEmpty
                    ? const SizedBox(
                        height: 250,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : SizedBox(
                        height: 255,
                        child: Column(
                          children: [
                            Container(
                              width:
                                  180, // Width and height to accommodate the border
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(
                                      0xFF0561DD), // Blue border color
                                  width: 3, // Adjust the border width as needed
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF0561DD)
                                        .withOpacity(0.3), // Shadow color
                                    offset: const Offset(0, 4), // Shadow position
                                    blurRadius: 15, // Shadow blur radius
                                  ),
                                ],
                              ),
                              child: User['image'] != null
                                  ? CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: NetworkImage(
                                          User['image']['secure_url']),
                                      radius: 40,
                                    )
                                  : const CircleAvatar(
                                      backgroundImage:
                                          AssetImage('images/5bbc3519d674c.jpg'),
                                      radius: 40,
                                    ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              User['username'] ?? 'userName',
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Salsa',
                              ),
                            ),
                            Text(
                              User['email'] ?? 'email not found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Salsa',
                              ),
                            ),
                          ],
                        ),
                      ),
          
                ///////////////////////////////////////////info
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    width: 285,
                    height: 285,
                    decoration: const BoxDecoration(
                    ),
                    child: Padding(
                      
                      padding: const EdgeInsets.only(top:00.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
          
                          const Text(
                            'Personal Information',
                            style: TextStyle(
                              color: Color(0xFF0561DD),
                              fontSize: 20,
                              fontFamily: 'salsa',
                            ),
                          ),
                          // Appointment
          
                          User.isEmpty
                              ? const SizedBox(
                                  height: 255,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : SizedBox(
                                  height:
                                      255, // Set a fixed height or use a different value based on your design
          
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: 1,
                                    itemBuilder: (context, index) {
                                      //  final appointment = appointmentList[index];
          
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Container(
                                          height: 150,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              width: 2,
                                              color: const Color(0xFF0561DD),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 25,
                                                  ),
                                                  const FaIcon(
                                                    FontAwesomeIcons.user,
                                                    color: Colors.blue,
                                                    size: 20.0,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    User['username'] ??
                                                        'not found',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontFamily: 'salsa',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 25,
                                                  ),
                                                  const FaIcon(
                                                    FontAwesomeIcons.locationDot,
                                                    color: Colors.blue,
                                                    size: 20.0,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    User['address'] ??
                                                        'not found',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontFamily: 'salsa',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 25,
                                                  ),
                                                  const FaIcon(
                                                    FontAwesomeIcons.mobileScreen,
                                                    color: Colors.blue,
                                                    size: 20.0,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    User['phone'] ?? 'not found',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontFamily: 'salsa',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,                                             ),
                                              Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 25,
                                                  ),
                                                  const FaIcon(
                                                    FontAwesomeIcons.coins,
                                                    color: Colors.blue,
                                                    size: 20.0,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    point.isEmpty ? '0' : point,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontFamily: 'salsa',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
                /////////////////////////////////////med
          
                // Container(
                //   color: Colors.white,
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       //title
          
                //       const Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text(
                //             'Your medicine',
                //             style: TextStyle(
                //               color: Color(0xFF0561DD),
                //               fontSize: 20,
                //               fontFamily: 'salsa',
                //             ),
                //           ),
                //           SizedBox(width: 120,),
                //           Text(
                //             'see all',
                //             style: TextStyle(
                //               color: Color(0xFF0561DD),
                //               fontSize: 10,
                //               fontFamily: 'salsa',
                //             ),
                //           ),
                //         ],
                //       ),
          
                //       prescriptions.isEmpty
                //           ? Center(
                //               child: Column(
                //                 children: [
                //                   Container(
                //                     height: 100,
                //                     child: Image.asset('images/medicine.png'),
                //                   ),
                //                   const SizedBox(
                //                     height: 10,
                //                   ),
                //                 ],
                //               ),
                //             )
                //           : SizedBox(
                //               height: 100,
                //               child: ListView.builder(
                //                 shrinkWrap: true,
                //                 itemCount: prescriptions.length,
                //                 itemBuilder: (context, index) {
                //                   return FutureBuilder(
                //                     future: getDoctor(
                //                         '${prescriptions[index]['writtenBy']}'),
                //                     builder: (context, categorySnapshot) {
                //                       if (categorySnapshot.hasError) {
                //                         return Text(
                //                             'Error: ${categorySnapshot.error}');
                //                       } else {
                //                         return Container(
                //                           child: medicineList(
                //                             diagnosis: prescriptions[index]
                //                                 ['diagnosis'],
                //                             from: prescriptions[index]
                //                                 ['dateFrom'],
                //                             to: prescriptions[index]['dateTo'],
                //                             writtenBy:
                //                                 categorySnapshot.data.toString(),
                //                             onTap: () {
                //                               Navigator.of(context).push(
                //                                 MaterialPageRoute(
                //                                   builder: (context) =>
                //                                       medicineSchedule(
                //                                     medicines:
                //                                         prescriptions[index]
                //                                             ['medicines'],
                //                                   ),
                //                                 ),
                //                               );
                //                             },
                //                           ),
                //                         );
                //                       }
                //                     },
                //                   );
                //                 },
                //                 physics: const BouncingScrollPhysics(),
                //               ),
                //             ),
                //     ],
                //   ),
                //   padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                // ),
          
                //////////////////////////////
              ]),
            ),
          ),
        )
          ),
    
        ],
      ),
    );
  }
}
