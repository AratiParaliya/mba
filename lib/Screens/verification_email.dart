import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mba/Screens/create_new_pass.dart';


class VerificationEmail extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
     final isKeyboard = MediaQuery.of(context).viewInsets.bottom !=0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          child:  SingleChildScrollView(
             padding: EdgeInsets.all(12),
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
                        "Verify Your Email",
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
                  height: MediaQuery.of(context).size.height / 2.5,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/email.png"),
                    ),
                  ),
                ),
                SizedBox(height: 5),
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
            
                // OTP input fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return Container(
                      width: 50,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

