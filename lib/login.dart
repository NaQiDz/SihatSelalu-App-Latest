import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'choose.dart';
import 'homepage.dart';
import 'started.dart';
import 'forgot_password.dart';

//lisha

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
          showPopup(
            context,
            "Success",
            "Login successful!",
            isSuccess: true,
            username: response["data"]["username"],
            email: response["data"]["email"],
          );
        } else {
          showPopup(context, "Error", response["message"]);
        }
      } catch (e) {
        print(e);
        showPopup(context, "Error", "An error occurred. Please try again.");
      }
    } else {
      showPopup(context, "Error", "Please enter both username and password!");
    }
  }

  @override
  Widget build(BuildContext context) {
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
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.05),
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StartedPage()),
                      );
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.08),
                Image.asset(
                  'sources/img2.png',
                  height: screenHeight * 0.3,
                  width: screenWidth * 0.6,
                ),
                SizedBox(height: screenHeight * 0.04),
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
                SizedBox(height: screenHeight * 0.03),
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
                SizedBox(height: screenHeight * 0.06),
                ElevatedButton(
                  onPressed: () {
                    loginUser(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                      horizontal: screenWidth * 0.2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: screenHeight * 0.022,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPassword()),
                    );
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

void showPopup(BuildContext context, String title, String message,
    {bool isSuccess = false, String? username, String? email}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: TextStyle(color: isSuccess ? Colors.green : Colors.red),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (isSuccess) {
                // Navigate to HomePage on success
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(
                      username: username ?? "",
                      email: email ?? "",
                    ),
                  ),
                );
              }
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
