// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:jwt_decoder/jwt_decoder.dart';

// class searchDoctor extends StatefulWidget {
//   const searchDoctor({super.key});

//   @override
//   State<searchDoctor> createState() => _searchDoctorState();
// }

// class _searchDoctorState extends State<searchDoctor> {
//   final List _doctors = [];
//   List _foundedDoctors = [];
//   List categories = [];
//   List addresses = [
//     'Nablus',
//     'Ramallah',
//     'Betlahem',
//     'Jenin',
//   ];
//   List<String> searchCat = [];
//   List<String> searchAddress = [];
//   bool display = false;
//   final storage = const FlutterSecureStorage();

//   Future<String> getTokenFromStorage() async {
//     final token = await storage.read(key: 'jwt');
//     if (token != null) {
//       final String userId = getUserIdFromToken(token);
//       await Future.delayed(const Duration(seconds: 2));
//       return userId;
//     } else {
//       print('Token not found in local storage.');
//       return '';
//     }
//   }

//   String getUserIdFromToken(String token) {
//     try {
//       final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
//       final String userId = decodedToken['id'];
//       return userId;
//     } catch (e) {
//       print('Error decoding token: $e');
//       return '';
//     }
//   }

//   Future<void> getCategories() async {
//     var url = "https://marham-backend.onrender.com/category/";

//     try {
//       var response = await http.get(Uri.parse(url));

//       if (response.statusCode == 200) {
//         var responceBody = response.body.toString();
//         responceBody = responceBody.trim();
//         responceBody = responceBody.substring(14, responceBody.length - 1);
//         var cat = jsonDecode(responceBody);
//         setState(() {
//           categories.addAll(cat);
//         });
//       } else {
//         // Handle the error when the HTTP request fails
//         print('Error: ${response.statusCode}');
//       }
//     } catch (error) {
//       // Handle other types of errors, such as network errors
//       print('Error: $error');
//     }
//   }

//   Future<List<dynamic>> getDoctors() async {
//     var url = "https://marham-backend.onrender.com/doctor/";

//     var response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       var responceBody = response.body.toString();
//       responceBody = responceBody.trim();
//       responceBody = responceBody.substring(11, responceBody.length - 1);
//       var doc = jsonDecode(responceBody);
//       setState(() {
//         _doctors.addAll(doc);
//       });
//     }
//     return []; // Return an empty list if there's an error
//   }

//   void _showSearchOptionsBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               const Text(
//                 'Filters',
//                 style: TextStyle(
//                   fontSize: 30.0,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'salsa',
//                 ),
//               ),
//               const Padding(
//                 padding: EdgeInsets.only(top: 15, left: 30),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Select Category',
//                       style: TextStyle(
//                         fontSize: 25.0,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'salsa',
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Expanded(
//                 child: GridView.builder(
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3,
//                     childAspectRatio: 2.0,
//                   ),
//                   itemCount: categories.length,
//                   itemBuilder: (context, index) {
//                     var category = categories[index];
//                     return GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           _foundedDoctors = _doctors
//                               .where((doctor) => doctor['categoryId']
//                                   .toLowerCase()
//                                   .contains(category['_id']))
//                               .toList();
//                         });
//                         display = true;
//                         searchCat.add(category['_id']);
//                         print(searchCat);
//                         createSearchList();
//                         Navigator.pop(context);
//                       },
//                       child: Card(
//                         child: Center(
//                           child: Text(
//                             category['name'],
//                             style: const TextStyle(
//                               fontSize: 20.0,
//                               fontWeight: FontWeight.bold,
//                               fontFamily: 'salsa',
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               const Divider(
//                 thickness: 2,
//                 color: Colors.grey,
//               ),
//               const Padding(
//                 padding: EdgeInsets.only(top: 15, left: 30),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Select Address',
//                       style: TextStyle(
//                         fontSize: 25.0,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'salsa',
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Expanded(
//                 child: GridView.builder(
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 4,
//                     childAspectRatio: 2.0,
//                   ),
//                   itemCount:
//                       addresses.length, // Assuming you have a list of addresses
//                   itemBuilder: (context, index) {
//                     var address = addresses[index];
//                     return GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           _foundedDoctors = _doctors
//                               .where((doctor) =>
//                                   doctor['address'].contains(address))
//                               .toList();
//                         });
//                         display = true;
//                         searchAddress.add(address);
//                         print(searchAddress);
//                         createSearchList();
//                         Navigator.pop(context);
//                       },
//                       child: Card(
//                         child: Center(
//                           child: Text(
//                             address,
//                             style: const TextStyle(
//                               fontSize: 20.0,
//                               fontWeight: FontWeight.bold,
//                               fontFamily: 'salsa',
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   onSearch(String search) {
//     setState(() {
//       _foundedDoctors = _doctors
//           .where((doctor) => doctor['name'].toLowerCase().contains(search))
//           .toList();
//     });
//   }

//   void createSearchList() async {
//     String id = await getTokenFromStorage();

//     final search = {
//           "categoryList": searchCat,
//           "addressList": searchAddress,
//     };

//     final response = await http.post(
//       Uri.parse('https://marham-backend.onrender.com/search/$id'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(search),
//     );

//     if (response.statusCode == 201 || response.statusCode == 200) {
//       // Show a success message
//       print('Data sent successfully');
//     } else {
//       // Handle the error when the HTTP request fails
//       print('Error in sending data');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     getCategories();
//     getDoctors();
//     setState(() {
//       _foundedDoctors = _doctors;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         toolbarHeight: 90,
//         backgroundColor: const Color(0xFF0561DD),
//         automaticallyImplyLeading: false,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           'Find Your Doctor',
//           style: TextStyle(
//             fontFamily: 'salsas',
//             fontSize: 30.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 15.0),
//           child: IconButton(
//             icon: const Icon(
//               Icons.arrow_back,
//               color: Colors.white,
//               size: 25,
//             ),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ),
//       ),
//       body: Container(
//         child: Column(
//           children: <Widget>[
//             Row(
//               children: [
//                 Padding(
//                   padding:
//                       const EdgeInsets.only(left: 25, right: 15, bottom: 25, top: 25),
//                   child: SizedBox(
//                     height: 60,
//                     width: 450,
//                     child: TextField(
//                       onTap: () {
//                         display = true;
//                       },
//                       onChanged: (value) => onSearch(value),
//                       decoration: const InputDecoration(
//                         labelText: 'Search',
//                         labelStyle: TextStyle(
//                           fontSize: 25,
//                           fontFamily: 'salsa',
//                           fontWeight: FontWeight.bold,
//                         ),
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: Color(0xFF0561DD),
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: Color(0xFF0561DD),
//                           ),
//                         ),
//                         prefixIcon: Icon(Icons.search),
//                       ),
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontFamily: 'salsa',
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(
//                     width:
//                         10), // Adjust the spacing between TextField and IconButton
//                 InkWell(
//                   child: const FaIcon(
//                     FontAwesomeIcons.filter,
//                     size: 26.0,
//                     color: Colors.grey,
//                   ),
//                   onTap: () {
//                     _showSearchOptionsBottomSheet(context);
//                   },
//                 ),
//               ],
//             ),
//             Expanded(
//               child: _foundedDoctors.isEmpty ||
//                       display == false
//                   ? Center(
//                       child: Padding(
//                         padding: const EdgeInsets.only(top: 150),
//                         child: Column(
//                           children: [
//                             Container(
//                               child: Image.asset('assets/doctor_category.png'),
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                   : ListView.builder(
//                       itemCount: _foundedDoctors.length,
//                       itemBuilder: (context, index) {
//                         return Slidable(
//                           actionPane: const SlidableDrawerActionPane(),
//                           actionExtentRatio: 0.25,
//                           child: findDoctorList(
//                             doctorPic:
//                                 '${_foundedDoctors[index]['image']['secure_url']}',
//                             doctorName: '${_foundedDoctors[index]['name']}',
//                             doctorCat: '${_foundedDoctors[index]['rate']}',
//                             onTap: () {
//                               Navigator.of(context).push(
//                                 MaterialPageRoute(
//                                   builder: (context) => appointment(
//                                     doctor: _foundedDoctors[index],
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
