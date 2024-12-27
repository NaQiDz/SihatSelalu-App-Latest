import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'verify_code.dart';
import 'login.dart';
import 'dart:convert';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ForgotPassword(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  void sendVerificationEmail() async {
    final String email = emailController.text;

    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _showPopupMessage("Invalid Email", "Please enter a valid email address.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('http://10.131.74.170/SihatSelaluAppDatabase/forgot_password.php');
    try {
      final response = await http.post(url, body: {'email': email}).timeout(Duration(seconds: 10));

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          _showPopupMessage(
            "Email Sent",
            "A verification email has been sent successfully.",
            onClose: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VerifyCodePage()),
              );
            },
          );
        } else {
          _showPopupMessage("Error", responseData['message'] ?? "Failed to send email.");
        }
      } else {
        _showPopupMessage("Server Error", "Unable to send the request.");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showPopupMessage("Error", "Unexpected error occurred: $e");
    }
  }

  void _showPopupMessage(String title, String message, {VoidCallback? onClose}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (onClose != null) onClose();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
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
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.08),
                Image.asset(
                  'sources/img3.png',
                  height: screenHeight * 0.2,
                  width: screenWidth * 0.5,
                ),
                SizedBox(height: screenHeight * 0.05),
                Text(
                  "Reset Password",
                  style: TextStyle(
                    fontSize: screenHeight * 0.035,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                TextField(
                  controller: emailController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.4),
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                ElevatedButton(
                  onPressed: isLoading ? null : sendVerificationEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.1,
                      vertical: screenHeight * 0.02,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "Send verification email",
                    style: TextStyle(fontSize: screenHeight * 0.022, color: Colors.white),
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