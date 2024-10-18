
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mba/Screens/create_new_pass.dart';

class VerificationScreen extends StatefulWidget {
  final String email;
  final String generatedOTP;

  VerificationScreen({required this.email, required this.generatedOTP});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _otpController = TextEditingController();

  void _verifyOTP() {
    if (_otpController.text.trim() == widget.generatedOTP) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreatePasswordScreen(email: widget.email, username: '',),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid OTP. Please try again.")),
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
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  hintText: 'Enter OTP',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyOTP,
                child: Text('Verify OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
