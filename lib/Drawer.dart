import 'package:dash/Mainpage.dart/Category/addcat.dart';
import 'package:dash/Mainpage.dart/Category/delete_cat.dart';
import 'package:dash/Mainpage.dart/Doctors/add_doctor.dart';
import 'package:dash/Mainpage.dart/Overview.dart';
import 'package:flutter/material.dart';

Widget DrawerWidget(BuildContext context) {
  String selectedDoctorAction = 'Add Doctor';
  String selectedCategory = 'Add Category';

  List<String> doctorsActions = ['Add Doctor', 'Delete Doctor'];
  List<String> categories = ['Add Category', 'Delete Category'];

  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.yellow,
          ),
          accountName: Text("Admin"),
          accountEmail: Text("email@gma"),
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text(
            'Overview',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: () {
            Navigator.pop(context); // Close the drawer
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OverView()),
            );
          },
        ),
         ListTile(
          leading: Icon(Icons.person),
          title: Text(
            'Add Doctors',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: () {
            // Handle the tap on the Settings item
            Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => add_doctor()),
                    ); // Close the drawer
          },
        ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 17.0),
        //   child: Row(
        //     children: [
        //       Icon(
        //         Icons.person,
        //         color: const Color.fromARGB(255, 76, 76, 76),
        //       ),
        //       SizedBox(
        //         width: 10,
        //       ),
        //       // DropdownButton<String>(
        //       //   value: selectedDoctorAction,
        //       //   underline: Container(
        //       //     height: 2,
        //       //     color: Color.fromARGB(9, 255, 255, 255),
        //       //   ),
        //       //   onChanged: (String? newValue) {
               
        //       //       selectedDoctorAction = newValue!;
                  

        //       //     // Handle different actions
        //       //     if (selectedDoctorAction == 'Add Doctor') {
        //       //       Navigator.pop(context); // Close the drawer
        //       //       Navigator.push(
        //       //         context,
        //       //         MaterialPageRoute(builder: (context) => add_doctor()),
        //       //       );
        //       //     } else if (selectedDoctorAction == 'Delete Doctor') {
        //       //       Navigator.pop(context); // Close the drawer
        //       //       Navigator.push(
        //       //         context,
        //       //         MaterialPageRoute(builder: (context) => Delete_doctor()),
        //       //       );
        //       //     }
        //       //   },
        //       //   items: doctorsActions.map((String action) {
        //       //     return DropdownMenuItem<String>(
        //       //       value: action,
        //       //       child: Text(action),
        //       //     );
        //       //   }).toList(),
        //       //   dropdownColor: Colors.white,
        //       //   focusColor: Colors.transparent,
        //       // ),
              
        //     ],
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(left: 17.0),
          child: Row(
            children: [
              Icon(
                Icons.category,
                color: const Color.fromARGB(255, 76, 76, 76),
              ),
              SizedBox(
                width: 10,
              ),
              DropdownButton<String>(
                value: selectedCategory,
                underline: Container(
                  height: 2,
                  color: Color.fromARGB(9, 255, 255, 255),
                ),
                onChanged: (String? newValue) {
                  
                    selectedCategory = newValue!;
                  

                  // Handle different categories
                  if (selectedCategory == 'Add Category') {
                    Navigator.pop(context); // Close the drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => add_Cat()),
                    );
                  } else if (selectedCategory == 'Delete Category') {
                    Navigator.pop(context); // Close the drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Delete_category()),
                    );
                  }
                },
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                dropdownColor: Colors.white,
                focusColor: Colors.transparent,
              ),
            ],
          ),
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text(
            'Settings',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: () {
            // Handle the tap on the Settings item
            Navigator.pop(context); // Close the drawer
          },
        ),
      ],
    ),
  );
}
