
import 'package:flutter/material.dart';

import '../unit/medicine.dart';
import '../unit/time.dart';

class medicineSchedule extends StatefulWidget {
  final List<dynamic> medicines;

  const medicineSchedule({super.key, required this.medicines});

  @override
  State<medicineSchedule> createState() => _medicineScheduleState();
}

class _medicineScheduleState extends State<medicineSchedule> {
  String selectedTime = ''; // Initialize with 'morning'
  List<String> times = ['morning', 'noon', 'night'];
  /*List<dynamic> medicines = [
    {
      'medicine': 'Medicine A',
      'description': 'Take in the morning',
      'time': ['morning', 'noon'],
    },
    {
      'medicine': 'Medicine B',
      'description': 'Take at night',
      'time': ['night'],
    },
    {
      'medicine': 'Medicine C',
      'description': 'Take at noon',
      'time': ['noon'],
    },
  ];*/ // Store all medicines here

  @override
  void initState() {
    super.initState();
  }

  // Function to handle time tap
  handleTapTime(String index) {
    setState(() {
      selectedTime = index;
    });
  }

  late var filteredMedicines = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8EEFA),
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor:  const Color(0xFF0561DD),
        elevation: 1,
        title: const Center(
          child: Text("Medicine Schedule",
           style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Salsa',
                ),
           ),
        ),
      ),
      
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20),
        child: Column(
          children: [
          Center(
            child: SizedBox(
              height: 100,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: times.length,
                itemBuilder: (context, index) {
                  
                  return GestureDetector(
                    child: timeList(
                      time: times[index],
                      isSelected: selectedTime == times[index],
                      onTap: () {
                        handleTapTime(times[index]);
                        filteredMedicines = widget.medicines
                            .where((med) => med['time'].contains(selectedTime))
                            .toList();
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          filteredMedicines.isEmpty
              ? Padding(
                padding: const EdgeInsets.only(top: 150),
                child: Column(
                  children: [
                    Container(
                      child: Image.asset('images/med.png'),
                    ),

                    const SizedBox(height: 20,),
                    const Text(
                      'No medicine for YOU in this Time!',
                      style: TextStyle(
                        fontFamily: 'salsa',
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],
                ),
              )
              : Expanded(
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: filteredMedicines.length,
                    itemBuilder: (context, index) {
                      final med = filteredMedicines[index];
                      return medicine(
                        name: med['medicine'] ?? 'Unknown',
                        des: med['description'] ?? 'No description',
                      );
                    },
                  ),
                )
        ]),
      ),
    );
  }
}
