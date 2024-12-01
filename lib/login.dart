import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'choose.dart';
import 'homepage.dart';
import 'started.dart';


void main() {
  runApp(LoginPage());
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginStylePage(),
      debugShowCheckedModeBanner: false, // Hide debug banner
    );
  }
}

class LoginStylePage extends StatelessWidget {

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> loginUser(BuildContext context) async {
    if (username.text.isNotEmpty && password.text.isNotEmpty) {
      try {
        String uri = "http://10.0.2.2/SihatSelaluAppDatabase/login.php";
        var res = await http.post(
          Uri.parse(uri),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "username": username.text,
            "password": password.text,
          }),
        );
        var response = jsonDecode(res.body);

        if (response["success"] == "true") {
          showToast(context, "Login successful!");
          // Navigate to the next page, e.g., HomePage
          String username = response["data"]["username"];
          String email = response["data"]["email"];

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                username: username,
                email: email,
              ),
            ),
          );
        } else {
          showToast(context, response["message"]); // Show failure message
        }
      } catch (e) {
        print(e);
        showToast(context, "An error occurred. Please try again.");
      }
    } else {
      showToast(context, "Please enter both username and password!");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fetch screen dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.blue.shade900],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07), // 7% of screen width
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.05), // 5% of screen height for top padding
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StartedPage()),
                      ); // Navigate back
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.08), // 8% of screen height for spacing
                Image.asset(
                  'sources/img2.png',
                  height: screenHeight * 0.3, // 30% of screen height
                  width: screenWidth * 0.6,   // 60% of screen width
                ),
                SizedBox(height: screenHeight * 0.04), // 4% of screen height
                TextField(
                  controller: username,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: screenHeight * 0.03), // 3% of screen height
                TextField(
                  controller: password,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: screenHeight * 0.06), // 6% of screen height
                ElevatedButton(
                  onPressed: () {
                    loginUser(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,  // 2% of screen height
                      horizontal: screenWidth * 0.2, // 20% of screen width
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: screenHeight * 0.022, // 2.2% of screen height
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02), // 2% of screen height
                TextButton(
                  onPressed: () {
                    // Handle forgot password action
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Forgot Password? Click ',
                      style: TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: 'Here!',
                          style: TextStyle(color: Colors.blue.shade500),
                        ),
                      ],
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

void showToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.black87,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}
