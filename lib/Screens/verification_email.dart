import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mba/Screens/create_new_pass.dart';

class VerificationEmail extends StatelessWidget {
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
            children: <Widget>[
              
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
                      if (!isKeyboardVisible)
                        Container(
                          height: MediaQuery.of(context).size.height / 2.6, 
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/email.png"),
                              fit: BoxFit.cover, 
                            ),
                          ),
                        ),
                      if (!isKeyboardVisible) SizedBox(height: 5),
          
                    
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
          
             
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  children: [
                    
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
                              counterText: '', 
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
      ),
    );
  }
}
