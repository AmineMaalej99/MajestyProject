import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_esports_club_application/join.dart';
import 'home.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false ,
      home: HomePage(),
      routes: {
        '/join': (context) => JoinPage(),
        '/login': (context) => LoginPage(),
        '/home': (context) => Home(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var w= MediaQuery.of(context).size.width;
    var h=MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Team Majesty'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Image.asset(
            'assets/background_image.png',
            width: w,
            height: h,
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/Majesty_logo.png',
                  width: 200,
                  height: 200,
                ),
                SizedBox(height: 20),
                Text(
                  'Welcome to Team Majesty',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.black.withOpacity(0),
                  child: Text(
                    'Are you ready for the next challenge!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/join');
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.black),
                      child: Text('Join Now'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.black),
                      child: Text('Login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
