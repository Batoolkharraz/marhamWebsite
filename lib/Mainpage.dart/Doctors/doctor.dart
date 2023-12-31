import 'dart:convert';
import 'package:dash/Mainpage.dart/Overview.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:dash/Drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

class Doctor extends StatefulWidget {
  final Map<String, dynamic> doc;

  const Doctor({Key? key, required this.doc}) : super(key: key);

  @override
  State<Doctor> createState() => _DoctorState();
}

class _DoctorState extends State<Doctor> {
  String price = '';

  final addressController = TextEditingController();
  final priceController = TextEditingController();
  final phoneController = TextEditingController();
  final catController = TextEditingController();
  final nameController = TextEditingController();
  List<String> list = <String>[
    'Nablus',
    'Ramallah',
    'Tulkarm',
    'Jenin',
    'Betlahem',
    'Hebron',
    'Jericho'
  ];
  late String dropdownValue = list.first;
  late String address = '';

  List<String> category = <String>[];
  late String dropdownValuecat = list.first;
  late String cat = '';
  String numPatient = '';
  String numApp = '';
  String numAppM = '';
  Uint8List? image;

  Future<void> selectImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final Uint8List img = await pickedFile.readAsBytes();
      setState(() {
        image = img;
      });
    }
  }

  Future getPrice() async {
    var url = "https://marham-backend.onrender.com/price/${widget.doc['_id']}";

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var responseBody = response.body.toString();
        responseBody = responseBody.trim();
        var app = jsonDecode(responseBody);

        if (app != null && app is Map<String, dynamic>) {
          setState(() {
            price = app['price'];
          });
        } else {
          print('Unexpected response structure: $app');
        }
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during network request: $error');
    }
  }

  Future<void> getCategory() async {
    var url = "https://marham-backend.onrender.com/category/";

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var responseBody = response.body.toString();
        responseBody = responseBody.trim();
        responseBody = responseBody.substring(14, responseBody.length - 1);
        var cat = jsonDecode(responseBody);
        setState(() {
          for (var c in cat) {
            // Assuming cat is a List<Map<String, dynamic>>
            var categoryName =
                c['name']; // Assuming 'name' is the key for the category name
            category.add(categoryName);
          }

          // Assuming cat['name'] is a list of category names
          dropdownValuecat = category.first;
        });
      } else {
        // Handle the error when the HTTP request fails
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other types of errors, such as network errors
      print('Error: $error');
    }
  }

  void updateDoctor(Uint8List? imageBytes) async {
    String name = '';
    String phone = '';
    String add = '';
    String category = '';
    nameController.text.isEmpty
        ? name = widget.doc['name']
        : name = nameController.text;
    phoneController.text.isEmpty
        ? phone = widget.doc['phone']
        : phone = phoneController.text;
    address.isEmpty ? add = widget.doc['address'] : add = address;
    catController.text.isEmpty ? category = cat : category = catController.text;
    String email = widget.doc['email'];

    final updates = {
      "email": email,
      "name": name,
      "address": add,
      "phone": phone,
      "category": category,
      "description": category
    };

    var url = Uri.parse("https://marham-backend.onrender.com/doctor/update/");

    try {
      var request = http.MultipartRequest('PATCH', url)..fields.addAll(updates);

      // Add the image file to the request if available
      if (imageBytes != null) {
        final http.MultipartFile file = http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: 'image.jpg',
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(file);
      }

      var response = await http.Client().send(request);

      if (response.statusCode == 200) {
        // Handle the success response
        print('doctor updated successfully');
      } else {
        // Handle the error response
        print('Failed to update doctor. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other types of errors, such as network errors
      print('Error: $error');
    }
  }

  void updatePrice() async {
    String p = '';
    priceController.text.isEmpty ? p = price : p = priceController.text;
    final upPrice = {"price": p};
    var url = Uri.parse(
        "https://marham-backend.onrender.com/price/updates/${widget.doc['_id']}");
    var response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(upPrice),
    );
    print(response.body);
  }

  void deleteDoctor() async {
    final deleteDoc = {"email": widget.doc['email']};
    var url = Uri.parse("https://marham-backend.onrender.com/doctor/");
    var response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(deleteDoc),
    );
    print(response.body);
  }

  Future<void> getNumApp() async {
    var url =
        "https://marham-backend.onrender.com/schedule/getNumApp/${widget.doc['_id']}";

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var responseBody = response.body.toString();
        responseBody = responseBody.trim();
        var num = jsonDecode(responseBody);
        setState(() {
          var numP = num;
          numApp = numP.toString();

          // Assuming cat['name'] is a list of category names
          dropdownValuecat = category.first;
        });
      } else {
        // Handle the error when the HTTP request fails
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other types of errors, such as network errors
      print('Error: $error');
    }
  }

  Future<void> getNumAppMonth() async {
    var url =
        "https://marham-backend.onrender.com/schedule/getNumAppMonth/${widget.doc['_id']}";

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var responseBody = response.body.toString();
        responseBody = responseBody.trim();
        var num = jsonDecode(responseBody);
        setState(() {
          var numP = num;
          numAppM = numP.toString();

          // Assuming cat['name'] is a list of category names
          dropdownValuecat = category.first;
        });
      } else {
        // Handle the error when the HTTP request fails
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other types of errors, such as network errors
      print('Error: $error');
    }
  }

  Future<void> getNumP() async {
    var url =
        "https://marham-backend.onrender.com/schedule/getNumPatient/${widget.doc['_id']}";

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var responseBody = response.body.toString();
        responseBody = responseBody.trim();
        var num = jsonDecode(responseBody);
        setState(() {
          var numP = num;
          numPatient = numP.toString();
        });
      } else {
        // Handle the error when the HTTP request fails
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other types of errors, such as network errors
      print('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    getPrice();
    getCategory();
    getNumP();
    getNumApp();
    getNumAppMonth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        // title: Padding(
        //   padding: const EdgeInsets.only(left: 200.0),
        //   child: Text('Doctor Details'), // Provide a title here
        // ),
      ),
      drawer: DrawerWidget(context),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //1st col
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //img and name and category
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40, top: 40),
                      child: Container(
                        width:
                            180, // Width and height to accommodate the border
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.blue, // Blue border color
                            width: 3, // Adjust the border width as needed
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0561DD)
                                  .withOpacity(0.3), // Shadow color
                              offset: const Offset(0, 4), // Shadow position
                              blurRadius: 15, // Shadow blur radius
                            ),
                          ],
                        ),
                        child: widget.doc['image'] != null
                            ? CircleAvatar(
                                backgroundColor: Colors.transparent,
                                backgroundImage: NetworkImage(
                                    widget.doc['image']['secure_url']),
                                radius: 90,
                              )
                            : const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/5bbc3519d674c.jpg'),
                                radius: 100,
                              ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.doc['name'],
                            style: TextStyle(
                                fontFamily: 'salsa',
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.doc['description'],
                            style: TextStyle(
                                fontFamily: 'salsa',
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.moneyBill,
                        color: Colors.blue,
                        size: 30.0,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        price + " nis",
                        style: TextStyle(
                            fontFamily: 'salsa',
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.addressBook,
                        color: Colors.blue,
                        size: 30.0,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        widget.doc['address'],
                        style: TextStyle(
                            fontFamily: 'salsa',
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.mobileScreen,
                        color: Colors.blue,
                        size: 30.0,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        widget.doc['phone'],
                        style: TextStyle(
                            fontFamily: 'salsa',
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.message,
                        color: Colors.blue,
                        size: 30.0,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        widget.doc['email'],
                        style: TextStyle(
                            fontFamily: 'salsa',
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //2nd col
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 250.0),
                    child: FaIcon(
                      FontAwesomeIcons.check,
                      color: Colors.blue,
                      size: 30.0,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 250.0),
                    child: Text(
                      'some of Doctor achevment:  ',
                      style: TextStyle(
                          fontFamily: 'Salsa',
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.person,
                    color: Colors.blue,
                    size: 30.0,
                  ),
                  SizedBox(
                    width: 38,
                  ),
                  Text(
                    'Number of patient: ',
                    style: TextStyle(
                      fontFamily: 'Salsa',
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    numPatient,
                    style: TextStyle(
                      fontFamily: 'Salsa',
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.peopleGroup,
                    color: Colors.blue,
                    size: 30.0,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Number of booked Appoitment: ',
                    style: TextStyle(
                      fontFamily: 'Salsa',
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    width: 0,
                  ),
                  Text(
                    numApp,
                    style: TextStyle(
                      fontFamily: 'Salsa',
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.peopleGroup,
                    color: Colors.blue,
                    size: 30.0,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Number of booked Appoitment in last month: ',
                    style: TextStyle(
                      fontFamily: 'Salsa',
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    numAppM,
                    style: TextStyle(
                      fontFamily: 'Salsa',
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
          //3rd col
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Clear the input fields or update the UI as needed
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('DELETE the Doctor'),
                              content: const Text(
                                  'Please note when you click on confirm the doctor"s will be deleted from database!'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Confirm'),
                                  onPressed: () {
                                    deleteDoctor();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => OverView(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(
                        "DELETE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Salsa',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Clear the input fields or update the UI as needed
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('SAVE the updates'),
                              content: const Text(
                                  'Please note when you click on confirm the doctor"s will be updated!'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Confirm'),
                                  onPressed: () {
                                    updateDoctor(image);
                                    updatePrice();

                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text(
                        "SAVE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Salsa',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Container(
                height: 40,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextFormField(
                  style: const TextStyle(fontSize: 20),
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    hintText: 'Doctor Name',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                    prefixIcon:
                        Icon(Icons.person, color: Colors.grey, size: 30),
                  ),
                  onChanged: (value) {
                    setState(() {
                      nameController.value = nameController.value.copyWith(
                          text: value,
                          selection:
                              TextSelection.collapsed(offset: value.length),
                          composing: TextRange.empty);
                    });
                  },
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 40,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextFormField(
                  style: const TextStyle(fontSize: 20),
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    hintText: 'phone Number',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                    prefixIcon: Icon(
                      Icons.phone_android,
                      color: Colors.grey,
                      size: 25,
                    ),
                  ),
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.digitsOnly,
                  //   LengthLimitingTextInputFormatter(16),
                  //   CardInputFormatter(),
                  // ],
                  onChanged: (value) {
                    if (value.length == 10) {
                      setState(() {
                        phoneController.text = value;
                      });
                    } else {
                      // You can show an error message or handle the invalid input as needed
                    }
                  },
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 40,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextFormField(
                  style: const TextStyle(fontSize: 20),
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}$')),
                  ],
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    hintText: 'price of Appotiment',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                    prefixIcon: Icon(
                      Icons.money,
                      color: Colors.grey,
                      size: 25,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      priceController.text = '$value ';
                      priceController.selection = TextSelection.fromPosition(
                          TextPosition(offset: value.length + 1));
                    });
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 170,
                    height: 40,
                    // Set the width as needed
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      elevation: 16,
                      style: const TextStyle(color: Colors.grey, fontSize: 18),
                      underline: Container(
                        height: 2,
                        color: Color.fromARGB(255, 180, 178, 178),
                      ),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          address = value!;
                          dropdownValue = value;
                          print(address);
                        });
                      },
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 170,
                    height: 40,
                    // Set the width as needed
                    child: DropdownButton<String>(
                      value: dropdownValuecat,
                      elevation: 16,
                      style: const TextStyle(color: Colors.grey, fontSize: 18),
                      underline: Container(
                        height: 2,
                        color: Color.fromARGB(255, 180, 178, 178),
                      ),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          cat = value!;
                          dropdownValuecat = value;
                          print(cat);
                        });
                      },
                      items: category
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 70),
                child: SizedBox(
                  width: 200,
                  height: 180,
                  child: Stack(
                    children: [
                      image != null
                          ? Container(
                              width: 200,
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF0561DD),
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF0561DD)
                                        .withOpacity(0.3),
                                    offset: const Offset(0, 4),
                                    blurRadius: 15,
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 90,
                                backgroundImage: MemoryImage(image!),
                              ),
                            )
                          : Container(
                              width: 200,
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF0561DD)
                                        .withOpacity(0.3),
                                    offset: const Offset(0, 4),
                                    blurRadius: 15,
                                  ),
                                ],
                              ),
                              child: const CircleAvatar(
                                radius: 90,
                                backgroundImage: AssetImage("images/pic.png"),
                              ),
                            ),
                      Positioned(
                        bottom: 10,
                        left: 140,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.add_a_photo,
                            size: 35,
                            color: Color(0xFF0561DD),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
