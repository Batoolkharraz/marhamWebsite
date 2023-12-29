import 'package:dash/Drawer.dart';
import 'package:flutter/material.dart';

class Delete_category extends StatefulWidget {
  const Delete_category({super.key});

  @override
  State<Delete_category> createState() => _Delete_categoryState();
}

class _Delete_categoryState extends State<Delete_category> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      drawer: DrawerWidget(context),
      body: Row(
        children: [],
      ),
    );
  }
}