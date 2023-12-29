import 'package:dash/Drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OverView extends StatefulWidget {
  const OverView({super.key});

  @override
  State<OverView> createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {
  // Default category

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Padding(
          padding: const EdgeInsets.only(left:200.0),
          child: Container(
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
            width: 600, // Adjust the width as needed
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left:10.0,bottom: 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Search for a doctor',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.search,
                    size: 20.0,
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
        ),
      ),
      drawer: DrawerWidget(context),
      body: Row(
        children: [],
      ),
    );
  }
}
