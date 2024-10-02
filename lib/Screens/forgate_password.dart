import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mba/Screens/verification_email.dart';

class ForgatePassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Allows the body to adjust when keyboard or clipboard is shown
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Logo and "Forget Password" text at the top
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.asset(
                    'assets/logo.png', // Replace with your logo asset path
                    width: 50, // Adjust the size as needed
                  ),
                  SizedBox(height: 10), // Space between logo and text
                  Center(
                    child: Text(
                      "Forget Password",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Image section
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height / 2.5, // Dynamically adjust height
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/forgetpassword.png"),
                      fit: BoxFit.cover, // Make sure image covers the area
                    ),
                  ),
                ),
              ),
            ),

            // Static Text and Input Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  SizedBox(height: 5),
                  Text(
                    "Please Enter Your Email Address To Receive a Verification Code",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(height: 40),

                  // Email Input Field
                  Container(
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
                        hintText: "Email Address",
                        labelText: 'Email Address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  // Send Button
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VerificationEmail()),
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
                      "Send",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
