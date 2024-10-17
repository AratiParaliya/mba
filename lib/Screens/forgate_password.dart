import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mba/Screens/verification_email.dart';

class ForgatePassword extends StatelessWidget {
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
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              
             
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      'assets/logo.png', 
                      width: 50, 
                    ),
                    SizedBox(height: 10), 
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
          
              
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                       
                        if (!isKeyboardVisible)
                          Container(
                            height: MediaQuery.of(context).size.height / 2.5, 
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/forgetpassword.png"),
                                fit: BoxFit.cover, 
                              ),
                            ),
                          ),
                        if (!isKeyboardVisible) SizedBox(height: 20),
          
                        
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
      ),
    );
  }
}
