import 'package:dash/user/payment/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

final storage = const FlutterSecureStorage();

String point = '';
int p = 0;
String discount = '';
double d = 0;
String finalP = '';
double f = 0;
Future<String> getTokenFromStorage() async {
  final token = await storage.read(key: 'jwt');
  if (token != null) {
    final String userId = getUserIdFromToken(token);
    await Future.delayed(const Duration(seconds: 2));
    return userId;
  } else {
    print('Token not found in local storage.');
    return '';
  }
}

String getUserIdFromToken(String token) {
  try {
    final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    final String userId = decodedToken['id'];
    return userId;
  } catch (e) {
    print('Error decoding token: $e');
    return '';
  }
}

void payment(String price, String bookId, String docId) async {
  String finalPrice = (p == 0 ? price : finalP);
  print(finalPrice);
  String id = await getTokenFromStorage();
  final pay = {
    "payMethod": "paypal",
    "price": finalPrice,
  };
  final response = await http.post(
    Uri.parse('https://marham-backend.onrender.com/payment/$id/$bookId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(pay),
  );
  if (response.statusCode == 201 || response.statusCode == 200) {
    // Show a success message
    print('Data sent successfully');
    bookedApp(bookId, docId);
  } else {
    // Handle the error when the HTTP request fails
    print('Error in sending data');
  }
}

void bookedApp(String bookId, String docId) async {
  String id = await getTokenFromStorage();
  final response = await http.post(
    Uri.parse(
        'https://marham-backend.onrender.com/schedule/$id/$bookId/$docId'), // Replace with your server URL
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    print("success in booking");
  } else {
    print("error on booking");
  }
}

Future getPoint(String price) async {
  String id = await getTokenFromStorage();
  var url = "https://marham-backend.onrender.com/payment/points/$id/123";

  try {
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var responseBody = response.body.toString();
      responseBody = responseBody.trim();
      var app = jsonDecode(responseBody);

      print(response.body);
      print(app);
      if (app != null && app is Map<String, dynamic>) {
        p = app['point'];
        point = p.toString();
        calcPrice(price);
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

String calcPrice(String price) {
  double Number = double.parse(price);
  if (p < 500) {
    d = 0.0;
    f = Number;
    discount = d.toString();
    finalP = f.toString();
  } else {
    d = (((p / 100) * Number) / 100);
    f = Number - (((p / 100) * Number) / 100);
    discount = d.toString();
    finalP = f.toString();
  }
  return discount;
}

void showpaymentalertt(
    BuildContext context, String book, String doc, String price) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            content: SizedBox(
              width: 400, // Set the width as desired
              height: 400, // Set the height as desired
              child: Center(
                  child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  const SizedBox(
                    width: 400,
                    height: 40,
                    child: Text(
                      "Payment Mode",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontFamily: 'Salsa',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: 400,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey, // Set border color to gray
                        width: 2.0, // Set border width
                      ),
                      // color: Colors.blue,
                      borderRadius:
                          BorderRadius.circular(20), // Set circular radius
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset("images/visa_196578.png"),
                        SizedBox(
                          width: 20,
                        ),
                        const Text(
                          "Visa Card",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontFamily: 'Salsa',
                          ),
                        ),
                        const SizedBox(
                          width: 100,
                        ),
                        InkWell(
                          child: const Icon(
                            FontAwesomeIcons.angleRight,
                            size: 30.0,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SecondScreen(
                                      bookId: book, docId: doc, price: price)),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: 400,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey, // Set border color to gray
                        width: 2.0, // Set border width
                      ),

                      borderRadius:
                          BorderRadius.circular(20), // Set circular radius
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset("images/paypal_174861.png"),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "PayPal",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontFamily: 'Salsa',
                          ),
                        ),
                        const SizedBox(
                          width: 140,
                        ),
                        InkWell(
                            child: const Icon(
                              FontAwesomeIcons.angleRight,
                              size: 30.0,
                            ),
                            onTap: () async {
                              getPoint(price);
                              String p = price;
                              print("price is: " + p);
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    PaypalCheckout(
                                  sandboxMode: true,
                                  clientId:
                                      "AZ86RqEBr0WWmJ3BxerCjf8uvKAraHbL9eaR6G8KqjPYnQR4ZFYVXLDMEPHny2KPWgw1qq8fpS2pOCHA",
                                  secretKey:
                                      "EJ85V6XMLZcNxef_6ydNeEklpHcKp5UVFCC_TgivllICQBTZitXgyLJ6bfJm5UTcw7-DWx7iG1H86Z1T",
                                  returnURL: "success.snippetcoder.com",
                                  cancelURL: "cancel.snippetcoder.com",
                                  transactions: [
                                    {
                                      "amount": {
                                        "total": finalP,
                                        "currency": "USD",
                                        "details": {
                                          "subtotal":finalP,
                                          "shipping": '0',
                                          "shipping_discount": 0
                                        }
                                      },
                                      "description":
                                          "The payment transaction description.",
                                      // "payment_options": {
                                      //   "allowed_payment_method":
                                      //       "INSTANT_FUNDING_SOURCE"
                                      // },
                                      "item_list": {
                                        "items": [
                                          {
                                            "name": "Appointment price",
                                            "quantity": 1,
                                            "price": p,
                                            "currency": "USD"
                                          },
                                          {
                                            "name": "Discount",
                                            "quantity": 1,
                                            "price": "-" + discount,
                                            "currency": "USD"
                                          }
                                        ],
                                      }
                                    }
                                  ],
                                  note:
                                      "Contact us for any questions on your order.",
                                  onSuccess: (Map params) async {
                                    print("onSuccess: ");
                                      payment(price, book, doc);
                                    
                                  },
                                  onError: (error) {
                                    print("onError: $error");
                                    Navigator.pop(context);
                                  },
                                  onCancel: () {
                                    print('cancelled:');
                                    Navigator.pop(context);
                                  },
                                ),
                              ));
                            })
                      ],
                    ),
                  )
                ],
              )),
            ));
      });
}
