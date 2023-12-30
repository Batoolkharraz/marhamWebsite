import 'package:flutter/material.dart';

class findDoctorList extends StatelessWidget {
  final String doctorPic;
  final String doctorName;
  final VoidCallback onTap;

  const findDoctorList({super.key, 
    required this.doctorPic,
    required this.doctorName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
      return 
      GestureDetector(
      onTap: onTap,
        child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(doctorPic),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doctorName,
                        style: const TextStyle(
                            color: Colors.black, 
                            fontWeight: FontWeight.w500,
                            fontSize: 20)),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
          ),
      );
  }
  }
