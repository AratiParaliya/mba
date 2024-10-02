import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mba/Screens/verification_email.dart';

class ForgatePassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Check if the keyboard is visible (viewInsets will be non-zero when the keyboard is up)
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      resizeToAvoidBottomInset: true, // Allows the body to adjust when keyboard or clipboard is shown
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Logo and "Forget Password" text at the top (not scrollable)
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

            // Scrollable section starts here
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Conditionally show the image when the keyboard is not visible
                      if (!isKeyboardVisible)
                        Container(
                          height: MediaQuery.of(context).size.height / 2.5, // Dynamically adjust height
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/forgetpassword.png"),
                              fit: BoxFit.cover, // Make sure image covers the area
                            ),
                          ),
                        ),
                      if (!isKeyboardVisible) SizedBox(height: 20),

                      // Static Text
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
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
