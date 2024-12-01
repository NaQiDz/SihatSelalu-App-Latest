import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workshop_2/started.dart';
import 'package:http/http.dart' as http;
import 'choose.dart';
import 'login.dart';

//lisha

void main() {
  runApp(RegisterPage());
}

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegisterStylePage(),
      debugShowCheckedModeBanner: false, // Hide debug banner
    );
  }
}

String? selectedGender; // To hold the selected gender
String? selectedAge;

class RegisterStylePage extends StatelessWidget {
  TextEditingController username = TextEditingController();
  TextEditingController emailControl = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController passwordCheck = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();

  Future<void> registerUser(BuildContext context) async {
    if (username.text.isNotEmpty &&
        emailControl.text.isNotEmpty &&
        selectedAge != null &&
        selectedGender != null &&
        passwordCheck.text.isNotEmpty &&
        confirmpassword.text.isNotEmpty) {
      String email = emailControl.text;
      String password = passwordCheck.text;

      if (passwordCheck.text != confirmpassword.text) {
        showPopup(context, "Error", "Passwords do not match!");
      } else if (!isValidEmail(email)) {
        showPopup(context, "Error", "Please enter a valid email.");
      } else if (!isValidPassword(password)) {
        showPopup(context, "Error", "Password must be 8-15 characters.");
      } else {
        try {
          String uri = "http://192.168.0.145/SihatSelaluAppDatabase/register.php";
          var res = await http.post(
            Uri.parse(uri),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "username": username.text,
              "email": emailControl.text,
              "age": selectedAge,
              "gender": selectedGender,
              "password": passwordCheck.text,
            }),
          );

          var response = jsonDecode(res.body);
          if (response["success"] == "true") {
            showPopup(context, "Success", "Registration successful!", isSuccess: true);
          } else {
            showPopup(context, "Error", "Failed to register!");
          }
        } catch (e) {
          showPopup(context, "Error", "An unexpected error occurred.");
          print(e);
        }
      }
    } else {
      showPopup(context, "Error", "Please fill in all the fields!");
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
                SizedBox(height: screenHeight * 0.02),
                Image.asset(
                  'sources/img3.png',
                  height: screenHeight * 0.2,
                  width: screenWidth * 0.4,
                ),
                SizedBox(height: screenHeight * 0.03),
                const Text(
                  'Register Now!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                _buildTextField(context, 'Enter your username', TextInputType.text, controller: username),
                SizedBox(height: screenHeight * 0.03),
                _buildTextField(context, 'Enter your email', TextInputType.emailAddress, controller: emailControl),
                SizedBox(height: screenHeight * 0.03),
                _buildDropdownMenuAge(context, 'Select your age'),
                SizedBox(height: screenHeight * 0.03),
                _buildDropdownMenuGender(context, 'Select your gender'),
                SizedBox(height: screenHeight * 0.03),
                _buildTextField(context, 'Enter your password', TextInputType.text, isObscure: true, controller: passwordCheck),
                SizedBox(height: screenHeight * 0.03),
                _buildTextField(context, 'Re-enter your password', TextInputType.text, isObscure: true, controller: confirmpassword),
                SizedBox(height: screenHeight * 0.06),
                ElevatedButton(
                  onPressed: () {
                    registerUser(context);
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
                    'Sign Up',
                    style: TextStyle(
                      fontSize: screenHeight * 0.022,
                      color: Colors.white,
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

// Helper functions and widgets
bool isValidEmail(String email) {
  String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  return RegExp(pattern).hasMatch(email);
}

bool isValidPassword(String password) {
  return password.length >= 8 && password.length <= 15;
}

Widget _buildTextField(BuildContext context, String label, TextInputType type,
    {bool isObscure = false, required TextEditingController controller}) {
  return TextField(
    controller: controller,
    obscureText: isObscure,
    keyboardType: type,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white),
      filled: true,
      fillColor: Colors.grey.withOpacity(0.4),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.blue, width: 2),
      ),
    ),
    style: TextStyle(color: Colors.white),
  );
}

Widget _buildDropdownMenuAge(BuildContext context, String hintText) {
  return DropdownButtonFormField<String>(
    value: selectedAge,
    items: List.generate(100, (index) => (index + 1).toString())
        .map((age) => DropdownMenuItem(value: age, child: Text(age, style: TextStyle(color: Colors.white))))
        .toList(),
    onChanged: (value) {
      selectedAge = value;
    },
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.grey.withOpacity(0.4),
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    ),
    dropdownColor: Colors.grey,
  );
}

Widget _buildDropdownMenuGender(BuildContext context, String hintText) {
  return DropdownButtonFormField<String>(
    value: selectedGender,
    items: ['Male', 'Female', 'Other']
        .map((gender) => DropdownMenuItem(value: gender, child: Text(gender, style: TextStyle(color: Colors.white))))
        .toList(),
    onChanged: (value) {
      selectedGender = value;
    },
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.grey.withOpacity(0.4),
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    ),
    dropdownColor: Colors.grey,
  );
}

void showPopup(BuildContext context, String title, String message, {bool isSuccess = false}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title, style: TextStyle(color: isSuccess ? Colors.green : Colors.red)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (isSuccess) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
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
