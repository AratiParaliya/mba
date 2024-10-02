import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mba/Screens/create_new_pass.dart';

class VerificationEmail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Allows the layout to adjust when the keyboard appears
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Scrollable Section for Image and Label
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 30,
                  right: 30,
                  top: 30,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Logo and "Verify Your Email" text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          'assets/logo.png', // Replace with your logo asset path
                          width: 50, // Adjust the size as needed
                        ),
                        SizedBox(height: 10), // Space between logo and text
                        Center(
                          child: Text(
                            "Verify Your Email",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Image section
                    Container(
                      height: MediaQuery.of(context).size.height / 2.6, // Adjust height dynamically
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/email.png"),
                          fit: BoxFit.cover, // Ensure the image fits nicely
                        ),
                      ),
                    ),
                    SizedBox(height: 5),

                    // Instruction text
                    Text(
                      "Please Enter The 6 Digit Code Sent To Your Email Address",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Fixed Section for OTP input fields and button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20), // Padding for the bottom section
              child: Column(
                children: [
                  // OTP input fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return Container(
                        width: 40,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 24),
                          maxLength: 1,
                          decoration: InputDecoration(
                            counterText: '', // Removes the counter below the text field
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 30),

                  // "Verify" button
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreateNewPass()),
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
                      "Verify",
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
          ],
        ),
      ),
    );
  }
}
