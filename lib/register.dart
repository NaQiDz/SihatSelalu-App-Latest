import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workshop_2/started.dart';
import 'package:http/http.dart' as http;
import 'choose.dart';
import 'login.dart';
import 'homepage.dart';

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
          showToast(context, "Passwords do not match!");
        }
        else if (!isValidEmail(email)) {
          showToast(context, "Please enter a valid email.");
        }
        else if(!isValidPassword(password)){
          showToast(context, "Please enter a password min 8 and max 15.");
        }
        else {
          try {
            String uri = "http://10.0.2.2/SihatSelaluAppDatabase/register.php";
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
              showToast(context, "Register successful!");
              Future.delayed(Duration(seconds: 2), () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              });
              username.clear();
              emailControl.clear();
              passwordCheck.clear();
              confirmpassword.clear();
              selectedAge = null;
              selectedGender = null;
            } else {
              showToast(context, "Failed to register!");
            }
          } catch (e) {
            print(e);
          }
        }
    } else {
      showToast(context, "Please fill up the form!");
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
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07), // 7% horizontal padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.05), // 5% top padding
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
                SizedBox(height: screenHeight * 0.02), // 2% spacing
                Image.asset(
                  'sources/img3.png',
                  height: screenHeight * 0.2, // 20% of screen height
                  width: screenWidth * 0.4,   // 40% of screen width
                ),
                SizedBox(height: screenHeight * 0.03), // 3% spacing
                const Text(
                  'Register Now!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                  ),
                ),
                SizedBox(height: screenHeight * 0.04), // 4% spacing
                _buildTextField(context, 'Enter your username', TextInputType.text, controller: username),
                SizedBox(height: screenHeight * 0.03),
                _buildTextFieldEmail(context, 'Enter your email', TextInputType.emailAddress, controller: emailControl, validateEmail: true,),
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
                SizedBox(height: screenHeight * 0.02),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: 'Login Now!',
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

// Helper Widgets
Widget _buildTextField(BuildContext context, String label, TextInputType type, {bool isObscure = false, required TextEditingController controller, List<TextInputFormatter>? inputFormatters}) {
  return TextField(
    controller: controller,
    obscureText: isObscure,
    keyboardType: type,
    inputFormatters: inputFormatters,
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

bool isValidEmail(String email) {
  // Regular expression to validate email
  String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  RegExp regExp = RegExp(pattern);

  // Check if email matches the pattern
  return regExp.hasMatch(email);
}

bool isValidPassword(String password) {
  return password.length >= 8 && password.length <= 15;
}

Widget _buildTextFieldEmail(
    BuildContext context, String label, TextInputType type,
    {bool isObscure = false,
      required TextEditingController controller,
      List<TextInputFormatter>? inputFormatters,
      bool validateEmail = false}) {
  return TextField(
    controller: controller,
    obscureText: isObscure,
    keyboardType: type,
    inputFormatters: inputFormatters,
    onSubmitted: (value) {
      if (validateEmail) {
        if (!isValidEmail(controller.text)) {
          showToast(context, "Invalid email format!");
        } else {
          showToast(context, "Email is valid!");
        }
      }
    },
    decoration: InputDecoration(
      labelText: label,
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
  );
}

Widget _buildDropdownMenuAge(BuildContext context, String hintText) {
  return DropdownButtonFormField<String>(
    value: selectedAge,
    items: List.generate(100, (index) => (index + 1).toString())
        .map((age) => DropdownMenuItem(
      value: age,
      child: Text(age, style: TextStyle(color: Colors.white)),
    ))
        .toList(),
    onChanged: (value) {
      selectedAge = value; // Update the selected age
    },
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.grey.withOpacity(0.4),
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    dropdownColor: Colors.grey,
    style: TextStyle(color: Colors.white),
  );
}

Widget _buildDropdownMenuGender(BuildContext context, String hintText) {
  return DropdownButtonFormField<String>(
    value: selectedGender,
    items: ['Male', 'Female', 'Other'].map((gender) => DropdownMenuItem(value: gender, child: Text(gender, style: TextStyle(color: Colors.white)))).toList(),
    onChanged: (value) {
      selectedGender = value;
    },
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.grey.withOpacity(0.4),
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.white)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.blue)),
    ),
    dropdownColor: Colors.grey,
    style: TextStyle(color: Colors.white),
  );
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
