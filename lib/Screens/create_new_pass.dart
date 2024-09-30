import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mba/Screens/signup.dart';

class CreateNewPass extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: const RadialGradient(
              colors: [
                Color.fromARGB(255, 110, 102, 188), // Darker purple
                Colors.white, // Light center
              ],
              radius: 2,
              center: Alignment(2.8, -1.0),
              tileMode: TileMode.clamp,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Aligns to the left
                children: <Widget>[
                  Image.asset(
                    'assets/logo.png', // Replace with your logo asset path
                    width: 50, // Adjust the size as needed
                  ),
                  SizedBox(height: 10), // Add space between logo and text
                  Center(
                    child: Text(
                      "Create New Password",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20), // Add some space after the logo and text
              Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/code.png"),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text(
                "All Set For Creating New Password",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 20),

              // New Password TextField with shadow
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8, // Adjust width if needed
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "New Password",
                      labelText: 'New Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Confirm Password TextField with shadow
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),
              Column(
                mainAxisSize: MainAxisSize.min, // Minimize the size to fit content
                children: <Widget>[
                  SizedBox(height: 5),
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Signup()),
                      );
                    },
                    color: Color.fromARGB(255, 110, 102, 188),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Color.fromARGB(255, 110, 102, 188),
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
