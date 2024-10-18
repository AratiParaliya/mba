
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:mba/Admin/dashboard.dart';
import 'package:mba/Screens/auth_service.dart';
import 'package:mba/Screens/forgate_password.dart';
import 'package:mba/Screens/medicin_search.dart';
import 'package:mba/Screens/signup.dart';
 

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService(); 
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final String _adminEmail = 'admin@gmail.com';
  final String _adminPassword = 'admin123';

 
  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      try {
        
        if (email == _adminEmail && password == _adminPassword) {
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Admin login successful!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()), // Replace with your Admin page
          );
        } else {
          
          User? user = await _authService.signInWithEmailAndPassword(email, password);

          if (user != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('User login successful!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );

            
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MedicinSearch()),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No user found for this email.';
            break;
          case 'wrong-password':
            errorMessage = 'Incorrect password.';
            break;
          default:
            errorMessage = 'Login failed. Please try again.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("An error occurred. Please try again."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image.asset(
                      'assets/logo.png', 
                      width: 50, 
                    ),
                    ElevatedButton(
                      onPressed: () {
                        
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupPage()),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 110, 102, 188),
                        ),
                      ),
                    ),
                  ],
                ),
                const Text(
                  "Sign in",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Enter your Details to proceed further",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
  children: <Widget>[
    
    Container(
     decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(15), 
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), 
            spreadRadius: 2, 
            blurRadius: 5, 
            offset: const Offset(0, 3), 
          ),
        ],
      ),
      child: TextFormField(
        controller: _emailController,
        decoration: InputDecoration(
          hintText: "Email",
          labelText: 'Email',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none, 
          ),
          fillColor: Colors.white,
          filled: true,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter an email';
          }
          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            return 'Please enter a valid email';
          }
          return null;
        },
      ),
    ),
    const SizedBox(height: 20),
    
    Container(
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(15), 
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), 
            spreadRadius: 2, 
            blurRadius: 5, 
            offset: const Offset(0, 3), 
          ),
        ],
      ),
      child: TextFormField(
        controller: _passwordController,
        decoration: InputDecoration(
          hintText: "Password",
          labelText: 'Password',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none, 
          ),
          fillColor: Colors.white,
          filled: true,
        ),
        obscureText: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a password';
          }
          return null;
        },
      ),
    ),
    const SizedBox(height: 10),
    Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ForgetPassword()),
            );
          },
          child: const Text(
            "Forgot Password?",
            style: TextStyle(
              color: Color.fromARGB(255, 110, 102, 188),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
    const SizedBox(height: 10),
  ],
),
                  SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleLogin, 
                    child: const Text(
                      "Sign in",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Color.fromARGB(255, 110, 102, 188),
                    ),
                  ),
                ),
               
              ],
            ),
          ),
        ),
      ),
    );
  }
}
