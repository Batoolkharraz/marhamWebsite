import 'dart:convert';
import 'package:dash/Mainpage.dart/Doctors/search/findDoctorList.dart';
import 'package:dash/user/doctorappointment/doctorapp.dart';
import 'package:dash/user/unit/doctor.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:dash/user/homePage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class searchDoctor extends StatefulWidget {
  const searchDoctor({super.key});

  @override
  State<searchDoctor> createState() => _searchDoctorState();
}

class _searchDoctorState extends State<searchDoctor> {
  List categories = [];
  List doctors = [];
  final List _doctors = [];
  List _foundedDoctors = [];

  bool display = false;

  onSearch(String search) {
    setState(() {
      _foundedDoctors = _doctors
          .where((doctor) => doctor['name'].toLowerCase().contains(search))
          .toList();
    });
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

  @override
  void initState() {
    super.initState();
    getDoctors();
    setState(() {
      _foundedDoctors = _doctors;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: Container(
        child: Column(
          children: <Widget>[
           Expanded(
              child: _foundedDoctors.isEmpty || display == false
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 150),
                        child: Column(
                          children: [
                            Container(
                              child: Image.asset('images/doctor_category.png'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 5.0,
                        childAspectRatio: 1.3,
                      ),
                      itemCount: _foundedDoctors.length,
                      itemBuilder: (context, index) {
                        return FutureBuilder(
                          future:
                              getCategory('${_foundedDoctors[index]['categoryId']}'),
                          builder: (context, categorySnapshot) {
                            if (categorySnapshot.hasError) {
                              return Text('Error: ${categorySnapshot.error}');
                            } else {
                              return Container(
                                height: 240, // Adjust the height as needed
                                child: doctor(
                                    doctorPic:
                                        '${_foundedDoctors[index]['image']['secure_url']}',
                                    doctorRate: '${_foundedDoctors[index]['rate']}',
                                    doctorName: '${_foundedDoctors[index]['name']}',
                                    doctorCat: categorySnapshot.data.toString(),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => appointment(
                                              doctor: _foundedDoctors[index]),
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
