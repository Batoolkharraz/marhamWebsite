import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';

class load extends StatefulWidget {
  final String num;

  const load({required this.num});

  @override
  State<load> createState() => _loadState();
}

class _loadState extends State<load> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircularPercentIndicator(
              animation: true,
              animationDuration: 3000,
              radius: 150,
              lineWidth: 20,
              percent: 1,
              progressColor: Colors.blue,
              backgroundColor: const Color.fromARGB(255, 111, 207, 252),
              circularStrokeCap: CircularStrokeCap.round,
              center: Text(widget.num,
              style: TextStyle(
                fontFamily: 'Salsa',
                fontSize: 20,
                fontWeight: FontWeight.w500
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
