import 'package:flutter/material.dart';
import 'package:mba/Screens/create_new_pass.dart';

class VerificationScreen extends StatefulWidget {
  final String email;
  final String generatedOTP;

  VerificationScreen({required this.email, required this.generatedOTP});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  // Create individual controllers for each digit
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());

  bool isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
      });
    });
  }

  void _verifyOTP() {
    // Combine all the 6 digits into one string
    String enteredOTP = _otpControllers.map((controller) => controller.text).join();

    if (enteredOTP == widget.generatedOTP) {
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
                    // OTP Input Fields
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
                            controller: _otpControllers[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 24),
                            maxLength: 1,  // Only 1 digit per field
                            decoration: InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (value) {
                              if (value.length == 1 && index < 5) {
                                FocusScope.of(context).nextFocus(); // Move to next field
                              } else if (value.isEmpty && index > 0) {
                                FocusScope.of(context).previousFocus(); // Move to previous field on delete
                              }
                            },
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 30),
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: _verifyOTP,
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
