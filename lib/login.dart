import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Image.asset(
            'assets/background_image.png',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          'assets/Majesty_logo.png',
                          width: 80,
                          height: 80,
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.amber,
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.amber,
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _loginUser,
                      style: ElevatedButton.styleFrom(primary: Colors.black),
                      child: Text('Submit'),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _forgotPassword,
                      style: ElevatedButton.styleFrom(primary: Colors.black),
                      child: Text('Forgot Password'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loginUser() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    if (!email.contains('@')) {
      setState(() {
        _errorMessage = 'Invalid email address';
      });
    } else {
      try {
        UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        User? user = userCredential.user;
        if (user != null) {
          if (user.emailVerified) {
            // Navigate to the home screen if email is verified
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            // Show a message to the user if email is not verified yet
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Email Not Verified'),
                  content: Text('Please verify your email address before logging in.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        }
      } catch (e) {
        print('Login error: $e');
        setState(() {
          _errorMessage = 'Invalid email or password';
        });
      }
    }
  }

  Future<void> _forgotPassword() async {
    String email = _emailController.text.trim();

    if (!email.contains('@')) {
      setState(() {
        _errorMessage = 'Invalid email address';
      });
    } else {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        // Show a dialog to inform the user that the password reset email has been sent
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Password Reset Email Sent'),
              content: Text('An email has been sent to $email. Please follow the instructions to reset your password.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        print('Forgot password error: $e');
        setState(() {
          _errorMessage = 'Failed to send password reset email. Please check your email address.';
        });
      }
    }
  }
}
