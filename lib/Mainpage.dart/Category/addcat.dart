import 'package:dash/Drawer.dart';
import 'package:flutter/material.dart';

class add_Cat extends StatefulWidget {
  const add_Cat({super.key});

  @override
  State<add_Cat> createState() => _add_CatState();
}

class _add_CatState extends State<add_Cat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      drawer:DrawerWidget(context),
    );
  }
}