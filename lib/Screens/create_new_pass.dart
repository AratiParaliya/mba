import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mba/Screens/login.dart'; // Ensure this import points to the correct Login page

class CreateNewPass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Check if the keyboard is visible (viewInsets will be non-zero when the keyboard is up)
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      resizeToAvoidBottomInset: true, // Allow resizing when the keyboard appears
      body: SafeArea(
        child: Container(
          width: double.infinity,
            height: MediaQuery.of(context).size.height, // Ensure the container takes up full height
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Color.fromARGB(255, 110, 102, 188), // Darker purple
                  Colors.white, // Light center
                ],
                radius: 2,
                center: Alignment(2.8, -1.0),
                tileMode: TileMode.clamp,
              ),
            ),
           
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 30,
                      right: 30,
                      top: 30,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 30, // Adjust padding for keyboard
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // Logo and title
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
                                "Create New Password",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20), // Space after the logo and title
          
                        // Conditionally display the image only if the keyboard is not visible
                        if (!isKeyboardVisible)
                          Container(
                            height: MediaQuery.of(context).size.height / 3,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/code.png"), // Replace with your image asset
                                fit: BoxFit.cover, // Adjust how the image fits
                              ),
                            ),
                          ),
                        if (!isKeyboardVisible) SizedBox(height: 5),
          
                        Text(
                          "All Set For Creating New Password",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 22,
                          ),
                        ),
                        SizedBox(height: 20), // Space before the input fields
          
                        // New Password TextField
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
                              obscureText: true, // To hide password input
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
                        SizedBox(height: 20), // Space before the confirm password input
          
                        // Confirm Password TextField
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
                              obscureText: true, // To hide password input
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
                        SizedBox(height: 30), // Space before the button
          
                        // "Save" button
                        MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to Login page
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
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
