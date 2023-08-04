import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatelessWidget {
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      _showLogoutMessage(context);
    } catch (e) {
      print('Logout error: $e');
      // Handle any error during logout if needed
    }
  }

  void _showLogoutMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('You\'re Logged Out'),
          content: Text('You have been successfully logged out.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Esport Club'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'Welcome to Esport Club',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Image.asset(
              'assets/esport_logo.png',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),
            Text(
              'Join our club to compete in exciting esports tournaments and events!',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Call the _logout function when the "Log Out" button is pressed
                _logout(context);
              },
              style: ElevatedButton.styleFrom(primary: Colors.black),
              child: Text('Log Out', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
