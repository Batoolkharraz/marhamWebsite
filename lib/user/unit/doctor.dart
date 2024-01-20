import 'package:flutter/material.dart';

class doctor extends StatelessWidget {
  final String doctorPic;
  final String doctorRate;
  final String doctorName;
  final String doctorCat;
  final VoidCallback onTap;

  const doctor({super.key, 
    required this.doctorPic,
    required this.doctorRate,
    required this.doctorName,
    required this.doctorCat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: SizedBox(
          height: 185, // Set your desired height here
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
            ),
            child: Column(
              children: [
                //pic
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.network(
                      doctorPic,
                      height: 150.0,
                      width: 150.0,
                    ),
                  ),
                ),
                //name
                Text(
                  doctorName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'Salsa',
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                //category
                Text(
                  doctorCat,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: 'Salsa',
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                //rate
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     const Icon(
                //       Icons.star,
                //       color: Color.fromARGB(255, 227, 212, 142),
                //     ),
                //     const SizedBox(height: 15,),
                //     Text(
                //       doctorRate,
                //       style: const TextStyle(
                //         fontWeight: FontWeight.bold,
                //         fontSize: 18,
                //         fontFamily: 'Salsa',
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
