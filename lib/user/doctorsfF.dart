import 'dart:convert';
import 'package:dash/user/unit/category.dart';
import 'package:dash/user/homePage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Drawer.dart';
import 'unit/doctor.dart';
import 'doctorappointment/doctorapp.dart';

class DoctorsPage extends StatefulWidget {
  final String categoryId;

  const DoctorsPage({super.key, required this.categoryId});

  @override
  _DoctorsPageState createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  List categories = [];
  List doctors = [];

  Future getCategories() async {
    var url = "https://marham-backend.onrender.com/category/";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var responceBody = response.body.toString();
      responceBody = responceBody.trim();
      responceBody = responceBody.substring(14, responceBody.length - 1);
      var cat = jsonDecode(responceBody);

      setState(() {
        categories.addAll(cat);
      });
    }
  }

  Future<String> getCategory(String catId) async {
    var url = "https://marham-backend.onrender.com/category/$catId";
    var response = await http.get(Uri.parse(url));
    var responceBody = response.body.toString();
    responceBody = responceBody.trim();
    responceBody = responceBody.substring(12, responceBody.length - 1);
    var cat = jsonDecode(responceBody);

    return cat['name'];
  }

  Future<List<dynamic>> getDoctorsByCategory(String catId) async {
    var url =
        "https://marham-backend.onrender.com/doctor/doctorByCategory/$catId";
    if (catId == '') {
      url = "https://marham-backend.onrender.com/doctor/";
    }
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var responceBody = response.body.toString();
      responceBody = responceBody.trim();
      responceBody = responceBody.substring(11, responceBody.length - 1);
      return jsonDecode(responceBody);
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

  @override
  void initState() {
    super.initState();
    getCategories();
    getDoctorsByCategory(widget.categoryId).then((doctorList) {
      setState(() {
        doctors.addAll(doctorList);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8EEFA),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        // title: Padding(
        //   padding: const EdgeInsets.only(left: 200.0),
        //   child: Text('Doctor Details'), // Provide a title here
        // ),
        leading: Padding(
            padding: const EdgeInsets.only(left:14.0),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 25,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => home(),
                  ),
                );
              },
            ),
          ),
      ),
      // drawer: DrawerWidget(context),
      body: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Column(
          children: [
            // other category
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                height: 100.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return category(
                      icon: '${categories[index]['image']['secure_url']}',
                      categoryName: '${categories[index]['name']}',
                      onTap: () => navigateToNextPageWithCategory(
                        '${categories[index]['_id']}',
                      ),
                    );
                  },
                  physics: const BouncingScrollPhysics(),
                ),
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),

            //see all
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    navigateToNextPageWithCategory('');
                  },
                  child: const Text('see all',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                          fontFamily: 'Salsa')),
                ),
              ],
            ),

            const SizedBox(
              height: 5.0,
            ),
            doctors.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Column(
                        children: [
                          Container(
                            child: Image.asset('images/doctor_category.png'),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  )
                :
                // doctors
                Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 5.0,
                        childAspectRatio: 1.3,
                      ),
                      itemCount: doctors.length,
                      itemBuilder: (context, index) {
                        return FutureBuilder(
                          future:
                              getCategory('${doctors[index]['categoryId']}'),
                          builder: (context, categorySnapshot) {
                            if (categorySnapshot.hasError) {
                              return Text('Error: ${categorySnapshot.error}');
                            } else {
                              return Container(
                                height: 240, // Adjust the height as needed
                                child: doctor(
                                    doctorPic:
                                        '${doctors[index]['image']['secure_url']}',
                                    doctorRate: '${doctors[index]['rate']}',
                                    doctorName: '${doctors[index]['name']}',
                                    doctorCat: categorySnapshot.data.toString(),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => appointment(
                                              doctor: doctors[index]),
                                        ),
                                      );
                                    }),
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
    );
  }
}
