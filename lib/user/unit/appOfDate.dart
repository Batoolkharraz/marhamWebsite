import 'package:flutter/material.dart';

class appOfDate extends StatelessWidget {
  final date;
  final VoidCallback onTap;
  const appOfDate({super.key, 
    required this.date,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
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
          child: Center(
            child: Text(date,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Salsa')),
          ),
        ),
      ),
    );
  }
}
