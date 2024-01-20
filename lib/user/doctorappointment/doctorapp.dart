import 'dart:convert';

import 'package:dash/user/doctorappointment/appTime.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../Drawer.dart';
import '../unit/appOfDate.dart';

class appointment extends StatefulWidget {
  final Map<String, dynamic> doctor;

  const appointment({super.key, required this.doctor});
  @override
  _appointmentState createState() => _appointmentState();
}

class _appointmentState extends State<appointment> {
  List apps = [];
  String price = '';
  List<String> appointmentDates = [];
  Map<String, List<Map<String, dynamic>>> dateToTimeSlots = {};
  Future getApps() async {
    var url =
        "https://marham-backend.onrender.com/schedule/${widget.doctor['_id']}";
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var responceBody = response.body.toString();
      responceBody = responceBody.trim();
      responceBody = responceBody.substring(13, responceBody.length - 1);
      var app = jsonDecode(responceBody);
      final dateFormatter = DateFormat("yyyy/MM/dd");
      if (mounted) {
        setState(() {
          apps.add(app);

          for (var appointment in apps) {
            var scheduleByDay = appointment['scheduleByDay'] as List<dynamic>;

            for (var schedule in scheduleByDay) {
              var date = dateFormatter.parse(schedule['date'] as String);
              final formattedDate = DateFormat('dd MMM yyyy').format(date);

              // Create a list of time slots for the date
              var timeSlots = <Map<String, dynamic>>[];

              if (schedule['timeSlots'] != null) {
                timeSlots = (schedule['timeSlots'] as List<dynamic>)
                    .map((slot) => {
                          'time': slot['time'] as String,
                          'is_booked': slot['is_booked'] as bool,
                          '_id': slot['_id'] as String,
                        })
                    .toList();
              }

              // Add the time slots to the map
              dateToTimeSlots[formattedDate] = timeSlots;
            }
          }

          appointmentDates = dateToTimeSlots.keys.toList()..sort();
        });
      }
    }
  }

  Future getPrice() async {
    var url =
        "https://marham-backend.onrender.com/price/${widget.doctor['_id']}";

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var responseBody = response.body.toString();
        responseBody = responseBody.trim();
        var app = jsonDecode(responseBody);

        if (app != null && app is Map<String, dynamic>) {
          setState(() {
            price = app['price'];
          });
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

  @override
  void initState() {
    super.initState();
    getApps();
    getPrice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      //drawer: DrawerWidget(context),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 40),
                child: Column(
                  children: [
                    Container(
                      // width: 600,
                      // color: Colors.white,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                            ),
                            child: ClipOval(
                              child: Container(
                                width:
                                    200.0, // Set the width of the circular container
                                height:
                                    200.0, // Set the height of the circular container
                                color: Colors
                                    .grey, // Background color for the circular container
                                child: Image.network(
                                  widget.doctor['image'][
                                      'secure_url'], // Replace with your image URL
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            // color: Colors.blue,
                            padding: EdgeInsets.only(top: 10, left: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.doctor['name'],
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 35,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Salsa')),
                                SizedBox(height: 10),
                                Text(widget.doctor['description'],
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Salsa')),
                                SizedBox(height: 10),
                                Container(
                                  width: 300,
                                  // color: Colors.blue,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.blue, width: 2),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.attach_money,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(price + ' nis',
                                          style: const TextStyle(
                                              color:
                                                  Color.fromRGBO(58, 58, 58, 1),
                                              fontSize: 25,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Salsa')),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      FaIcon(
                                        FontAwesomeIcons.locationDot,
                                        size: 26.0,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(widget.doctor['address'],
                                          style: const TextStyle(
                                              color:
                                                  Color.fromRGBO(58, 58, 58, 1),
                                              fontSize: 25,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Salsa'))
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  child: Row(
                                    children: [
                                      SizedBox(width: 5),
                                      FaIcon(
                                        FontAwesomeIcons.envelope,
                                        size: 26.0,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(widget.doctor['email'],
                                          style: const TextStyle(
                                              color:
                                                  Color.fromRGBO(58, 58, 58, 1),
                                              fontSize: 25,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Salsa'))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    child: Column(
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.only(left: 20, bottom: 5, top: 15),
                          child: SizedBox(
                            child: Text("Book Apponitment",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold
                                    // fontFamily: 'Salsa',
                                    )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  appointmentDates == null || appointmentDates.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 150,left:100),
                          child: Column(
                            children: [
                              Container(
                                child: Image.asset('images/time.png'),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        )
                      : Container(
                          width: 800, // Set a fixed width based on screen width
                          child: SingleChildScrollView(
                            child: SizedBox(
                              height: 1000,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    crossAxisSpacing: 5.0,
                                    mainAxisSpacing: 10.0,
                                  ),
                                  itemBuilder: (context, int index) {
                                    return appOfDate(
                                      date: appointmentDates[index],
                                      onTap: () {
                                        final selectedDate =
                                            appointmentDates[index];
                                        final timeSlots =
                                            dateToTimeSlots[selectedDate];
                                        if (timeSlots != null &&
                                            timeSlots.isNotEmpty) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => appTime(
                                                docId: apps[0]['writtenBy'],
                                                date: selectedDate,
                                                timeSlots: timeSlots,
                                                price: price,
                                              ),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.red,
                                              content: Center(
                                                child: Text(
                                                  "No Appointment available for $selectedDate",
                                                  style: const TextStyle(
                                                    fontFamily: 'salsa',
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              duration:
                                                  const Duration(seconds: 2),
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  },
                                  itemCount: appointmentDates.length,
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.all(8),
                                ),
                              ),
                            ),
                          ),
                        )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
