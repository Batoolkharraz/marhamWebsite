
import 'package:flutter/material.dart';


class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left side (Image)
          Expanded(
            flex: 1,
            child: Container(
              height: double.infinity,
              color: Colors.blue,
              child: Image.asset(
                "images/pic.png"
               ,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Right side (Login Form)
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(20.0),
              color: Colors.white,
              child: LoginForm(),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
      
      child: Column(
        children: [
        Padding(
          padding: const EdgeInsets.only(top:200.0,bottom: 20),
          child: Container(
            width: 450,
            child: Text(
                    'Welcome Back to Marham',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                       fontFamily: 'salsa',
                    
                    ),
            ),
          ),
        ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                   fontFamily: 'salsa',
                
                ),
              ),
              Text(
                'Enter your Email and password to enter our dashboard',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                   fontFamily: 'salsa',
                
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 400,
                height: 50,
               padding: EdgeInsets.only(bottom: 10),
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextFormField(
                    
                    decoration: InputDecoration(labelText: 'Username',
                    border: InputBorder.none
                    ),
                    
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 400,
                height: 50,
               padding: EdgeInsets.only(bottom: 10),
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
                child: Padding(
                  padding: const EdgeInsets.only(left:8.0),
                  child: TextFormField(
                    
                    decoration: InputDecoration(labelText: 'Password',
                    border: InputBorder.none
                    ),
                    
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implement your login logic here
                },
                child: Text('Login'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}