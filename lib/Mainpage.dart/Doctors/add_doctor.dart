import 'package:dash/Drawer.dart';
import 'package:dash/Mainpage.dart/Category/addcat.dart';
import 'package:dash/Mainpage.dart/Overview.dart';
import 'package:flutter/material.dart';

class add_doctor extends StatefulWidget {
  const add_doctor({super.key});

  @override
  State<add_doctor> createState() => _add_doctorState();
}

class _add_doctorState extends State<add_doctor> {
  List<String> list = <String>[
    'Nablus',
    'Ramallah',
    'Tulkarm',
    'Jenin',
    'Betlahem',
    'Hebron',
    'Jericho'
  ];
    List<String> cat = <String>[
    'N',
    'Ramallah',
    'Tulkarm',
    'Jenin',
    'Betlahem',
    'Hebron',
    'Jericho'
  ];
  late String dropdownValue = 'Nablus';
  late String address;
 late String catfirst = 'N';
  late String catresult;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Colors.blue, 
      ),
      drawer:DrawerWidget(context),
      body: Row(
        children: [
          // Left side (Image)
          Expanded(
            flex: 1,
            child: Container(
              height: double.infinity,
              color: Colors.white,
              child: Image.asset(
                "images/Filing system-rafiki.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Right side (Login Form)
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(20.0),
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.only(left: 10,right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 120.0),
                  child: Column(
                    children: [
                      // Doctor Name and Email
                       Padding(
                         padding: const EdgeInsets.only(bottom:30.0),
                         child: Container(
                                     width: 700,
                                     child: Text(
                                             'Register Doctors ',
                                             style: TextStyle(
                                               fontSize: 28,
                                               fontWeight: FontWeight.bold,
                                               color: Colors.grey,
                                                fontFamily: 'salsa',
                                             
                                             ),
                                     ),
                                   ),
                       ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: 200,
                              height: 50,
                              padding: EdgeInsets.only(bottom: 10),
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
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Doctor name',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 40),
                          Expanded(
                            child: Container(
                              width: 200,
                              height: 50,
                              padding: EdgeInsets.only(bottom: 10),
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
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Email',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Phone Number and Dropdown
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: 200,
                              height: 50,
                              padding: EdgeInsets.only(bottom: 10),
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
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Phone Number',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 40),
                          Expanded(
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
                              
                              
                              // Set the width as needed
                              child: Padding(
                                padding: const EdgeInsets.only(left:8.0),
                                child: DropdownButton<String>(
                                  
                                  value: dropdownValue,
                                  elevation: 16,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
                                  ),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.white
                                  ),
                                  
                                  onChanged: (String? value) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      address = value!;
                                      dropdownValue = value;
                                    });
                                  },
                                  items: list.map<DropdownMenuItem<String>>(
                                    (String value) {
                                      return DropdownMenuItem<String>(
                                        
                                        value: value,
                                        child: Text(value),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Doctor Name and Description
                      
                      Row(
                        children: [
                                      Expanded(
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
    // Set the width as needed
    child: Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: DropdownButton<String>(
        value: catfirst,
        elevation: 16,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 20,
        ),
        underline: Container(
          height: 2,
          color: Colors.white,
        ),
        onChanged: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            catresult = value!;
            catfirst = value;
          });
        },
        items: cat.map<DropdownMenuItem<String>>(
              (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              },
            )
            .toList(),
      ),
    ),
  ),
),
SizedBox(width: 40),
                          Expanded(
                            child: Container(
                              width: 200,
                              height: 50,
                              padding: EdgeInsets.only(bottom: 10),
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
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Description',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]
                      ),
                      SizedBox(height: 20),
                      // Phone Number and Dropdown
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: 200,
                              height: 50,
                              padding: EdgeInsets.only(bottom: 10),
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
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: TextFormField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 40),
                          Expanded(
                            child: Container(
                              width: 200,
                              height: 50,
                              padding: EdgeInsets.only(bottom: 10),
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
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: TextFormField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: 'Confirm Password',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40,),
                       ElevatedButton(
                onPressed: () {
                  // Close the drawer
                
                },
                child: Text('Register Doctor'),
              ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
        ],
        
      ),
    );
  }
}
