import 'package:flutter/material.dart';
import 'started.dart';
import 'login.dart';
import 'register.dart';

void main() {
  runApp(ChoosePage());
}

class ChoosePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Colors.blue.shade900],
            ),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05), // 5% padding
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2), // 20% of screen height
                  Image.asset(
                    'sources/img1.png',
                    height: MediaQuery.of(context).size.height * 0.35, // 35% of screen height
                    width: MediaQuery.of(context).size.width * 0.6,   // 60% of screen width
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02), // 2% of screen height
                  Text(
                    'Welcome to',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.height * 0.02, // 2% of screen height
                    ),
                  ),
                  Text(
                    'SihatSelalu App',
                    style: TextStyle(
                      color: Colors.blue.shade500,
                      fontSize: MediaQuery.of(context).size.height * 0.03, // 3% of screen height
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05), // 5% of screen height
                  Text(
                    "Don't have an account?\nSign up now!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.height * 0.018, // 1.8% of screen height
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03), // 3% of screen height
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.15, // 15% of screen width
                        vertical: MediaQuery.of(context).size.height * 0.02,  // 2% of screen height
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Sign up for free',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.height * 0.02, // 2% of screen height
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02), // 2% of screen height
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
                      'Log in',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.height * 0.02, // 2% of screen height
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
