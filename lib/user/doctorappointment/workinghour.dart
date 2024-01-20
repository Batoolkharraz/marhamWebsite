import 'package:flutter/material.dart';

class working extends StatefulWidget {
  final String date;
  final String time;
  final String is_booked;
  final VoidCallback onTap;

  const working({super.key, 
    required this.date,
    required this.time,
    required this.is_booked,
    required this.onTap,
  });

  @override
  _WorkingState createState() => _WorkingState();
}

class _WorkingState extends State<working> {
  late String buttonText;
  late Color buttonColor;

  @override
  void initState() {
    super.initState();
    updateButtonState();
  }

  void updateButtonState() {
    buttonText = widget.is_booked == 'true' ? 'booked' : 'book';
    buttonColor =
        widget.is_booked == 'true' ? Colors.red : const Color(0xFF0561DD);
  }

  @override
  Widget build(BuildContext context) {
    final dateParts = widget.date.split(' ');
    final formattedDate = '${dateParts[0]} ${dateParts[1]}\n${dateParts[2]}';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
          border: Border.all(
            color: Colors.grey, // Set the border color here
            width: 2.0, // Set the border width
          ),
        ),
        width: 500,
        height: 100,
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 25,
                  ),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Salsa',
                    ),
                  ),
                  const SizedBox(
                    width: 70,
                  ),
                  Text(
                    widget.time,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Salsa',
                    ),
                  ),
                  const SizedBox(
                    width: 80,
                  ),
                  InkWell(
                    onTap: widget.onTap,
                   /* onTapDown: (_) {
                      setState(() {
                        buttonText = 'booked';
                        buttonColor = Colors.red;
                      });
                    },*/
                    child: Text(
                      buttonText,
                      style: TextStyle(
                        color: buttonColor,
                        fontSize: 35,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Salsa',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
