import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mba/Screens/login.dart'; 

class CreateNewPass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      resizeToAvoidBottomInset: true, 
      body: SafeArea(
        child: Container(
          width: double.infinity,
            height: MediaQuery.of(context).size.height, 
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Color.fromARGB(255, 110, 102, 188), 
                  Colors.white, 
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
                        
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Image.asset(
                              'assets/logo.png',
                              width: 50, 
                            ),
                            SizedBox(height: 10), 
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
                        SizedBox(height: 20),
          
                        
                        if (!isKeyboardVisible)
                          Container(
                            height: MediaQuery.of(context).size.height / 3,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/code.png"), 
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
                        SizedBox(height: 20), 
          
                      
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
                              obscureText: true, 
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
                              obscureText: true,
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
                        MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()), 
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
