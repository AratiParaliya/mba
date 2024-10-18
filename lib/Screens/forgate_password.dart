import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mba/Screens/verification_email.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _generatedOTP;

 void _sendOTPEmail(String email) async {
  _generatedOTP = (Random().nextInt(900000) + 100000).toString(); // Generate 6-digit OTP

  final smtpServer = gmail('paraliyaarati@gmail.com', 'fvut lfzx mprk ijho'); 

  final message = Message()
    ..from = Address('paaraliyaarati@gmail.com', 'MBA Pharma')
    ..recipients.add(email)
    ..subject = 'Your OTP Code'
    ..text = 'Your OTP for resetting your password is $_generatedOTP.';

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("OTP sent to your email!")),
    );

    // Navigate to the Verification screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerificationScreen(
          email: email,
          generatedOTP: _generatedOTP!,
        ),
      ),
    );
  } catch (e) {
    print("SMTP Error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: Could not send OTP. Please try again later.")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email Address',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String email = _emailController.text.trim();
                  if (email.isNotEmpty) {
                    _sendOTPEmail(email);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please enter a valid email address.")),
                    );
                  }
                },
                child: Text('Send OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
