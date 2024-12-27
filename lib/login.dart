import 'dart:convert';
import 'package:SihatSelaluApp/home.dart';
import 'package:SihatSelaluApp/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'choose.dart';
import 'forgot_password.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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

  LoginStylePage({super.key});

  Future<void> loginUser(BuildContext context) async {
    await dotenv.load(fileName:'.env');
    String? serverIp;
    if (username.text.isNotEmpty && password.text.isNotEmpty) {
      try {
        serverIp = dotenv.env['ENVIRONMENT']! == 'dev' ? dotenv.env['DB_HOST_EMU']! : dotenv.env['DB_HOST_IP'];
        String uri = "http://$serverIp/SihatSelaluAppDatabase/login.php";
        var res = await http.post(
          Uri.parse(uri),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "username": username.text,
            "password": password.text,
          }),
        );

        print("Response status: ${res.statusCode}");
        print("Response body: ${res.body}");

        if (res.statusCode == 200) {
          var response;

          try {
            response = jsonDecode(res.body);
          } catch (e) {
            print("JSON parsing error: $e");
            showPopup(context, "Error", "Invalid response from server.", loginSession: false);
            return;
          }

          if (response["success"] == "true") {
            // Save session
            if (response["data"] != null &&
                response["data"]["username"] != null &&
                response["data"]["email"] != null) {
              SessionManager.startSession(
                response["token"] ?? "",
                response["data"]["userid"],
                response["data"]["username"],
                response["data"]["email"],
                response["data"]["icon"],
              );
              // Show success message and navigate
              showPopup(context, "Success", "Login successful!", loginSession: true);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePageToUse(),
                ),
              );
            } else {
              showPopup(context, "Error", "Invalid response data", loginSession: false);
            }
          } else {
            showPopup(context, "Error", response["message"], loginSession: false);
          }
        } else {
          print("Unexpected status code: ${res.statusCode}");
          showPopup(context, "Error", "Server error: ${res.statusCode}", loginSession: false);
        }
      } catch (e) {
        print("Exception occurred: $e");
        showPopup(context, "Error", "An error occurred. Please try again.", loginSession: false);
      }

    } else {
      showPopup(context, "Error" , "Please enter both username and password!", loginSession:false);
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
                        MaterialPageRoute(builder: (context) => ChoosePage()),
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
                SizedBox(height: screenHeight * 0.05),
                SizedBox(
                  width: screenWidth * 0.9, // Adjust width relative to the screen size
                  height: 45.0,            // Set the desired height
                  child: TextField(
                    controller: username,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 12),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.4),
                      contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0), // Adjust internal padding
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
                ),

                SizedBox(height: screenHeight * 0.02),
                SizedBox(
                  width: screenWidth * 0.9, // Adjust width relative to the screen size
                  height: 45.0,            // Set the desired height
                  child: TextField(
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white, fontSize: 12),
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
                ),
                SizedBox(height: screenHeight * 0.04),
                ElevatedButton(
                  onPressed: () {
                    loginUser(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.015,
                      horizontal: screenWidth * 0.2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: screenHeight * 0.020,
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

void showPopup(BuildContext context, String textMessage, String message, {bool loginSession = false}) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissal by tapping outside
    builder: (BuildContext context) {
      // Automatically close the dialog after 2 seconds
      Future.delayed(Duration(seconds: 2), () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      });

      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.grey.withOpacity(0.8),

        title: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ensures the column takes up minimal vertical space
            children: [
              Text(
                textMessage,
                style: TextStyle(color: loginSession ? Colors.green : Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8), // Adds spacing between the title and the message
              Text(
                message,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      );
    },
  );
}





