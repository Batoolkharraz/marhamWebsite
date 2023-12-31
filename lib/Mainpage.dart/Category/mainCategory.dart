import 'dart:convert';
import 'dart:typed_data';
import 'package:dash/Drawer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

class mainCategory extends StatefulWidget {
  const mainCategory({Key? key}) : super(key: key);

  @override
  State<mainCategory> createState() => _mainCategoryState();
}

class _mainCategoryState extends State<mainCategory> {
  final nameController = TextEditingController();
  final desController = TextEditingController();
  final UnameController = TextEditingController();
  final UdesController = TextEditingController();
  List categories = [];

  Map<String, int> categoryCount = {};
  List doctors = [];
  List<String> category = <String>[];
  List<String> categoryD = <String>[];
  late String dropdownValuecat = '';
  late String dropdownValuedelete = '';
  late String cat = '';
  late String catD = '';
  Uint8List? image;
  Uint8List? imageUpdate;

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

  Future<void> selectImageUpdate() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final Uint8List img = await pickedFile.readAsBytes();
      setState(() {
        imageUpdate = img;
      });
    }
  }

  Future<void> addCategory(
      String name, String description, Uint8List? imageBytes) async {
    try {
      final uri = Uri.parse("https://marham-backend.onrender.com/category/");

      // Create a new multipart request
      final request = http.MultipartRequest("POST", uri);
      request.headers['Content-Type'] = 'multipart/form-data';

      // Add the name and description to the request body
      request.fields['name'] = name;
      request.fields['description'] = description;

      // Add the image file to the request
      if (imageBytes != null) {
        final http.MultipartFile file = http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: 'image.jpg',
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(file);
      }

      final http.Response response =
          await http.Response.fromStream(await request.send());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print(data); // Handle the response from the server as needed
      } else {
        print('Failed to add category. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
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
          categoryD.clear();
          category.clear();
          categories.addAll(cat);
          for (var c in cat) {
            // Assuming cat is a List<Map<String, dynamic>>
            var categoryName =
                c['name']; // Assuming 'name' is the key for the category name
            category.add(categoryName);
            categoryD.add(categoryName);
          }

          // Assuming cat['name'] is a list of category names
          dropdownValuecat = category.first;
          dropdownValuedelete = categoryD.first;
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

  Future<void> updateCategory(String catName, Uint8List? imageBytes) async {
    String name = '';
    String des = '';
    String id = '';

    for (var c in categories) {
      if (c['name'] == catName) {
        id = c['_id'];
        UnameController.text.isEmpty
            ? name = c['name']
            : name = UnameController.text;
        UdesController.text.isEmpty
            ? des = c['description']
            : des = UdesController.text;
      }
    }
    final updates = {
      "Nname": name,
      "description": des,
    };

    var url =
        Uri.parse("https://marham-backend.onrender.com/category/update/$id");

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
        print('Category updated successfully');
      } else {
        // Handle the error response
        print('Failed to update category. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other types of errors, such as network errors
      print('Error: $error');
    }
  }

  Future<void> deleteCategory(String catName) async {
    String id = '';

    for (var c in categories) {
      if (c['name'] == catName) {
        id = c['_id'];
      }
    }

    var url = Uri.parse("https://marham-backend.onrender.com/category/$id");
    var response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
    });
    print(response.body);
  }

  Future<List<dynamic>> getDoctor() async {
    var url = "https://marham-backend.onrender.com/doctor/";

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var responceBody = response.body.toString();
      responceBody = responceBody.trim();
      responceBody = responceBody.substring(11, responceBody.length - 1);
      var doc = jsonDecode(responceBody);
      setState(() {
        doctors.addAll(doc);
      });
    }

    return []; // Return an empty list if there's an error
  }

  Future<Map<String, int>> numDoc() async {
    var url = "https://marham-backend.onrender.com/category/getNumDoctor/123";

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var responseBody = response.body.toString();
      responseBody = responseBody.trim();

      // Parse JSON and access the "result" key
      Map<String, dynamic> data = jsonDecode(responseBody);
      Map<String, int> result = {};

      // Check if "result" key exists
      if (data.containsKey("result")) {
        // Convert dynamic values to int where needed
        Map<String, dynamic> resultData = data["result"];
        resultData.forEach((key, value) {
          result[key] = value as int;
        });

        setState(() {
          categoryCount.addAll(result);
        });

        return result;
      }
    }

    // Return an empty map if there's an error or "result" key is missing
    return {};
  }

  @override
  void initState() {
    super.initState();
    getDoctor();
    getCategory();
    numDoc();
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
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 40.0, top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Add Category',
                  style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Salsa',
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
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
                SizedBox(
                  height: 25,
                ),
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
                      hintText: 'Category Name',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                      prefixIcon: Icon(Icons.dashboard_customize_sharp,
                          color: Colors.grey, size: 30),
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
                SizedBox(
                  height: 25,
                ),
                Container(
                  height: 150,
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 20),
                    controller: desController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      hintText: 'Category Des',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                      prefixIcon:
                          Icon(Icons.description, color: Colors.grey, size: 30),
                    ),
                    onChanged: (value) {
                      setState(() {
                        desController.value = desController.value.copyWith(
                            text: value,
                            selection:
                                TextSelection.collapsed(offset: value.length),
                            composing: TextRange.empty);
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // Button to add category
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('SAVE the updates'),
                          content: const Text(
                              'Please note when you click on confirm the category will be added!'),
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
                                addCategory(nameController.text,
                                    desController.text, image);
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
                    "Add Category",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Salsa',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40.0, top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      'Edit Category',
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Salsa',
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 60,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('SAVE the updates'),
                              content: const Text(
                                  'Please note when you click on confirm the category will be updated!'),
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
                                    updateCategory(cat, imageUpdate);
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
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      'choose the category first:',
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Salsa',
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Container(
                      width: 170,
                      height: 40,
                      // Set the width as needed
                      child: DropdownButton<String>(
                        value: dropdownValuecat,
                        elevation: 16,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 18),
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
                SizedBox(
                  width: 200,
                  height: 180,
                  child: Stack(
                    children: [
                      imageUpdate != null
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
                                backgroundImage: MemoryImage(imageUpdate!),
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
                          onPressed: selectImageUpdate,
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
                SizedBox(
                  height: 25,
                ),
                Container(
                  height: 40,
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 20),
                    controller: UnameController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      hintText: 'Category Name',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                      prefixIcon: Icon(Icons.dashboard_customize_sharp,
                          color: Colors.grey, size: 30),
                    ),
                    onChanged: (value) {
                      setState(() {
                        UnameController.value = UnameController.value.copyWith(
                            text: value,
                            selection:
                                TextSelection.collapsed(offset: value.length),
                            composing: TextRange.empty);
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  height: 100,
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 20),
                    controller: UdesController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      hintText: 'Category Des',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                      prefixIcon:
                          Icon(Icons.description, color: Colors.grey, size: 30),
                    ),
                    onChanged: (value) {
                      setState(() {
                        UdesController.value = UdesController.value.copyWith(
                            text: value,
                            selection:
                                TextSelection.collapsed(offset: value.length),
                            composing: TextRange.empty);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50.0, top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      width: 170,
                      height: 40,
                      // Set the width as needed
                      child: DropdownButton<String>(
                        value: dropdownValuedelete,
                        elevation: 16,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 18),
                        underline: Container(
                          height: 2,
                          color: Color.fromARGB(255, 180, 178, 178),
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            catD = value!;
                            dropdownValuedelete = value;
                            print(cat);
                          });
                        },
                        items: categoryD
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('DELETE the category'),
                              content: const Text(
                                  'Please note when you click on confirm the category will be deleted!'),
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
                                    deleteCategory(catD);
                                    Navigator.of(context).pop();
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
                  ],
                ),
                SizedBox(
                  height: 70,
                ),
                //add the table here
                Text(
                  'Number of Doctor in each Category',
                  style: TextStyle(
                    fontFamily: 'Salsa',
                    fontSize: 18,
                  ),
                ),
                // Table to display category information
                SizedBox(
                  height: 350, // Set your desired height
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Category Name')),
                        DataColumn(label: Text('Number of Doctors')),
                      ],
                      rows: category.map((categoryName) {
                        int numberOfDoctors = categoryCount[categoryName] ?? 0;

                        return DataRow(
                          cells: [
                            DataCell(Text(categoryName)),
                            DataCell(Center(
                              child: Text(
                                numberOfDoctors.toString(),
                              ),
                            )),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
