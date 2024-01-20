import 'package:flutter/material.dart';

class category extends StatelessWidget {
  final icon;
  final String categoryName;
  final VoidCallback onTap;

  const category({super.key, 
    required this.icon,
    required this.categoryName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
          width: 100.0,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: const Color.fromARGB(255, 229, 231, 237),
          ),
          child: Column(
            children: [
              SizedBox(
                 height:55.0,
                child: Image.network(
                  icon,

                ),
              ),
              // ignore: prefer_const_constructors
              
              Center(
                child: Text(
                  categoryName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Salsa',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
