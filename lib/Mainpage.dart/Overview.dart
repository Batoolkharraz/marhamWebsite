import 'dart:convert';

import 'package:dash/Drawer.dart';
import 'package:dash/Mainpage.dart/Category/mainCategory.dart';
import 'package:dash/Mainpage.dart/Doctors/add_doctor.dart';
import 'package:dash/Mainpage.dart/Doctors/doctor.dart';
import 'package:dash/Mainpage.dart/Doctors/search/findDoctorList.dart';
import 'package:dash/user/unit/load.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class OverView extends StatefulWidget {
  const OverView({super.key});

  @override
  State<OverView> createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {
  final List _doctors = [];
  List _foundedDoctors = [];
  List categories = [];

  List<String> searchCat = [];
  List<String> searchAddress = [];
  bool display = false;
  final storage = const FlutterSecureStorage();
  String numDoc = '';
  String numUser = '';
  String numApp = '';
  Future<void> getCategories() async {
    var url = "https://marham-backend.onrender.com/category/";

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var responceBody = response.body.toString();
        responceBody = responceBody.trim();
        responceBody = responceBody.substring(14, responceBody.length - 1);
        var cat = jsonDecode(responceBody);
        setState(() {
          categories.addAll(cat);
        });
      } else {
        // Handle the error when the HTTP request fails
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other types of errors, such as network errors
      print('Error: $error');
    }
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

  // void _showSearchOptionsBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Container(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //           children: [
  //             const Text(
  //               'Filters',
  //               style: TextStyle(
  //                 fontSize: 30.0,
  //                 fontWeight: FontWeight.bold,
  //                 fontFamily: 'salsa',
  //               ),
  //             ),
  //             const Padding(
  //               padding: EdgeInsets.only(top: 15, left: 30),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     'Select Category',
  //                     style: TextStyle(
  //                       fontSize: 25.0,
  //                       fontWeight: FontWeight.bold,
  //                       fontFamily: 'salsa',
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             const SizedBox(height: 10),
  //             Expanded(
  //               child: GridView.builder(
  //                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //                   crossAxisCount: 3,
  //                   childAspectRatio: 2.0,
  //                 ),
  //                 itemCount: categories.length,
  //                 itemBuilder: (context, index) {
  //                   var category = categories[index];
  //                   return GestureDetector(
  //                     onTap: () {
  //                       setState(() {
  //                         _foundedDoctors = _doctors
  //                             .where((doctor) => doctor['categoryId']
  //                                 .toLowerCase()
  //                                 .contains(category['_id']))
  //                             .toList();
  //                       });
  //                       display = true;
  //                       searchCat.add(category['_id']);
  //                       print(searchCat);
  //                       Navigator.pop(context);
  //                     },
  //                     child: Card(
  //                       child: Center(
  //                         child: Text(
  //                           category['name'],
  //                           style: const TextStyle(
  //                             fontSize: 20.0,
  //                             fontWeight: FontWeight.bold,
  //                             fontFamily: 'salsa',
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   );
  //                 },
  //               ),
  //             ),
  //             const Divider(
  //               thickness: 2,
  //               color: Colors.grey,
  //             ),
  //             const Padding(
  //               padding: EdgeInsets.only(top: 15, left: 30),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     'Select Address',
  //                     style: TextStyle(
  //                       fontSize: 25.0,
  //                       fontWeight: FontWeight.bold,
  //                       fontFamily: 'salsa',
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             const SizedBox(height: 10),
  //             Expanded(
  //               child: GridView.builder(
  //                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //                   crossAxisCount: 4,
  //                   childAspectRatio: 2.0,
  //                 ),
  //                 itemCount:
  //                     addresses.length, // Assuming you have a list of addresses
  //                 itemBuilder: (context, index) {
  //                   var address = addresses[index];
  //                   return GestureDetector(
  //                     onTap: () {
  //                       setState(() {
  //                         _foundedDoctors = _doctors
  //                             .where((doctor) =>
  //                                 doctor['address'].contains(address))
  //                             .toList();
  //                       });
  //                       display = true;
  //                       searchAddress.add(address);
  //                       print(searchAddress);
  //                       Navigator.pop(context);
  //                     },
  //                     child: Card(
  //                       child: Center(
  //                         child: Text(
  //                           address,
  //                           style: const TextStyle(
  //                             fontSize: 20.0,
  //                             fontWeight: FontWeight.bold,
  //                             fontFamily: 'salsa',
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   );
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  onSearch(String search) {
    setState(() {
      _foundedDoctors = _doctors
          .where((doctor) => doctor['name'].toLowerCase().contains(search))
          .toList();
    });
  }

  Future<void> getNumD() async {
    var url = "https://marham-backend.onrender.com/doctor/getNumDoctor/123";

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var responseBody = response.body.toString();
        responseBody = responseBody.trim();
        var num = jsonDecode(responseBody);
        setState(() {
          var numP = num;
          numDoc = numP.toString();
        });
      } else {
        // Handle the error when the HTTP request fails
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other types of errors, such as network errors
      print('Error: $error');
    }
  }

  Future<void> getNumU() async {
    var url = "https://marham-backend.onrender.com/doctor/getNumUser/123";
    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var responseBody = response.body.toString();
        responseBody = responseBody.trim();
        var num = jsonDecode(responseBody);
        setState(() {
          var numP = num;
          numUser = numP.toString();
        });
      } else {
        // Handle the error when the HTTP request fails
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other types of errors, such as network errors
      print('Error: $error');
    }
  }

  Future<void> getNumA() async {
    var url = "https://marham-backend.onrender.com/schedule/getNumAppAll/123";
    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var responseBody = response.body.toString();
        responseBody = responseBody.trim();
        var num = jsonDecode(responseBody);
        setState(() {
          var numP = num;
          numApp = numP.toString();
        });
      } else {
        // Handle the error when the HTTP request fails
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other types of errors, such as network errors
      print('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    getCategories();
    getDoctors();
    getNumU();
    getNumD();
    getNumA();
    setState(() {
      _foundedDoctors = _doctors;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                        display = true;
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
      drawer: DrawerWidget(context),
      body: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                        height: 250,
                        width: 500,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(
                              29), // Set the border radius here
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Welcom back Admin,\n",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Salsa',
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Image.asset(
                              "images/copy.png",
                            ),
                          ],
                        )),
                    SizedBox(
                      width: 80,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        load(num: numUser),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Text(
                            'Users',
                            style: TextStyle(
                              fontFamily: 'Salsa',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Column(
                      children: [
                        load(num: numDoc),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Text(
                            'Doctors',
                            style: TextStyle(
                              fontFamily: 'Salsa',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Column(
                      children: [
                        load(num: numApp),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Text(
                            'Appoitments',
                            style: TextStyle(
                              fontFamily: 'Salsa',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

                    Padding(
                      padding: const EdgeInsets.only(top:30.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => mainCategory(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              width: 300,
                              height: 100,
                              child: Center(
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 25.0),
                                      child: FaIcon(
                                        FontAwesomeIcons.plus,
                                        color: Colors.white,
                                        size: 30.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                        child: Center(
                                      child: Text(
                                        'Category',
                                        style: TextStyle(
                                            fontFamily: 'Salsa',
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => add_doctor(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              width: 300,
                              height: 100,
                              child: Center(
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 25.0),
                                      child: FaIcon(
                                        FontAwesomeIcons.plus,
                                        color: Colors.white,
                                        size: 30.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                        child: Center(
                                      child: Text(
                                        'Doctor',
                                        style: TextStyle(
                                            fontFamily: 'Salsa',
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ),

],
                      ),
                    ),
          SizedBox(width: 80),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    'doctors List',
                    style: TextStyle(
                      fontFamily: 'salsa',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 500, // Set a specific height for the ListView
                  child: ListView(
                    shrinkWrap: true,
                    children: _foundedDoctors.map((doctor) {
                      return Slidable(
                        actionPane: const SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        child: findDoctorList(
                          doctorPic: '${doctor['image']['secure_url']}',
                          doctorName: '${doctor['name']}',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Doctor(
                                  doc: doctor,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
