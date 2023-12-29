import 'package:dash/Drawer.dart';
import 'package:dash/Mainpage.dart/Doctors/search/searchDoctor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Delete_doctor extends StatefulWidget {
  const Delete_doctor({super.key});

  @override
  State<Delete_doctor> createState() => _Delete_doctorState();
}

class _Delete_doctorState extends State<Delete_doctor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      drawer: DrawerWidget(context),
      body: Row(
        children: [
          
          Expanded(
            flex: 1,
            child: Container(
              height: double.infinity,
              color: Colors.white,
              child: Image.asset(
                "images/Search-rafiki.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(child:
          Padding(
            padding: const EdgeInsets.only(left:40,right: 40),
            child: Container(
              width: 600,
              height: 400,
              child: Column(
                children: [
                  Container(
                                    
                                     child: Text(
                                             '  Search ',
                                             style: TextStyle(
                                               fontSize: 28,
                                               fontWeight: FontWeight.bold,
                                               color: Colors.grey,
                                                fontFamily: 'salsa',
                                             
                                             ),
                                     ),
                                   ),
                  Container(
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
                    width: 400,
                    height: 50,
                    child: Row(
                      children: [
                          IconButton(
                                icon: const Icon(
                                  FontAwesomeIcons.search,
                                  size: 30.0,
                                ),
                                onPressed: () {
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: (context) => const searchDoctor(),
                                  //   ),
                                  // );
                                },
                              ),
                      ],
                    ),
                    
                  ),
                ],
              ),
            ),
          ),)
        ],
      ),
    );
  }
}