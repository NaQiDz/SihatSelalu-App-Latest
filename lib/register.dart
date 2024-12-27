import 'dart:convert';
import 'package:SihatSelaluApp/choose.dart';
import 'package:SihatSelaluApp/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
  TextEditingController phoneControl = TextEditingController();
  TextEditingController ageControl = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController passwordCheck = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();

  RegisterStylePage({super.key});

  Future<void> registerUser(BuildContext context) async {
    await dotenv.load(fileName:'.env');
    String? serverIp;
    if (username.text.isNotEmpty &&
        emailControl.text.isNotEmpty &&
        phoneControl.text.isNotEmpty &&
        ageControl.text.isNotEmpty &&
        selectedGender != null &&
        passwordCheck.text.isNotEmpty &&
        confirmpassword.text.isNotEmpty) {
      String email = emailControl.text;
      String age = ageControl.text;
      String phone = phoneControl.text;
      String password = passwordCheck.text;

      if (passwordCheck.text != confirmpassword.text) {
        showPopup(context, "Error" , "Passwords do not match!", loginSession:false);
      } else if (!isValidEmail(email)) {
        showPopup(context, "Error" , "Please enter a valid email.", loginSession:false);
      }else if (!isValidPhoneNumber(phone)) {
        showPopup(context, "Error"  , "Phone number is not valid!.", loginSession:false);
      }else if (!isValidTwoDigitNumber(age)) {
        showPopup(context, "Error" , "Invalid age, age must be 2 digit of number!.", loginSession:false);
      }else if (!isValidPassword(password)) {
        showPopup(context, "Error" , "Password must be 8-15 characters.", loginSession:false);
      } else {
        try {
          serverIp = dotenv.env['ENVIRONMENT']! == 'dev' ? dotenv.env['DB_HOST_EMU']! : dotenv.env['DB_HOST_IP'];
          String uri = "http://$serverIp/SihatSelaluAppDatabase/register.php";          var res = await http.post(
            Uri.parse(uri),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "username": username.text,
              "email": emailControl.text,
              "phone": phoneControl.text,
              "age": ageControl.text,
              "gender": selectedGender,
              "password": passwordCheck.text,
            }),
          );

          var response = jsonDecode(res.body);
          if (response["success"] == "true") {
            showPopup(context, "Success", "Registration successful!", loginSession:true);

          } else {
            showPopup(context, "Error" , "Failed to register!", loginSession:false);
          }
        } catch (e) {
          showPopup(context, "Error" , "An unexpected error occurred.", loginSession:false);
          print(e);
        }
      }
    } else {
      showPopup(context, "Error" , "Please fill in all the fields!", loginSession:false);
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
                        MaterialPageRoute(builder: (context) => ChoosePage()),
                      );
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Image.asset(
                  'sources/img4.png',
                  height: screenHeight * 0.1,
                  width: screenWidth * 0.3,
                ),
                SizedBox(height: screenHeight * 0.01),
                const Text(
                  'Register Now!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildTextField(context, 'Enter your username', TextInputType.text, controller: username),
                SizedBox(height: screenHeight * 0.02),
                _buildTextField(context, 'Enter your email', TextInputType.emailAddress, controller: emailControl),
                SizedBox(height: screenHeight * 0.02),
                _buildTextField(context, 'Enter your Phone Number', TextInputType.phone, controller: phoneControl),
                SizedBox(height: screenHeight * 0.02),
                _buildTextField(context, 'Enter your Age', TextInputType.number, controller: ageControl),
                SizedBox(height: screenHeight * 0.02),
                _buildDropdownMenuGender(context, 'Select your gender'),
                SizedBox(height: screenHeight * 0.02),
                _buildTextField(context, 'Enter your password', TextInputType.text, isObscure: true, controller: passwordCheck),
                SizedBox(height: screenHeight * 0.02),
                _buildTextField(context, 'Re-enter your password', TextInputType.text, isObscure: true, controller: confirmpassword),
                SizedBox(height: screenHeight * 0.04),
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
                      fontSize: screenHeight * 0.015,
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

bool isValidPhoneNumber(String phoneNumber) {
  // Modified regular expression to optionally accept "60" at the beginning
  String pattern = r'^(60)?(01[0-9]-?\d{7,8}|0[3-9]-?\d{6,8})$';
  return RegExp(pattern).hasMatch(phoneNumber);
}
bool isValidPassword(String password) {
  return password.length >= 8 && password.length <= 15;
}

bool isValidTwoDigitNumber(String input) {
  String pattern = r'^\d{1,2}$'; // Matches 1 or 2 digits only
  return RegExp(pattern).hasMatch(input);
}


Widget _buildTextField(BuildContext context, String label, TextInputType type,
    {bool isObscure = false,
      required TextEditingController controller,
      double? height}) {
  return SizedBox(
    height: height ?? 45.0, // Default height if none is provided
    child: TextField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white, fontSize: 12),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.4),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
      ),
      style: TextStyle(color: Colors.white, fontSize: 12),
    ),
  );
}


Widget _buildDropdownMenuGender(BuildContext context, String hintText, {double? width,double? height}) {
  return SizedBox(
    width: width ?? double.infinity,
    height: height ?? 45.0, // Default height if none is provided
    child: DropdownButtonFormField<String>(
      value: selectedGender,
      items: ['Male', 'Female', 'Other']
          .map(
            (gender) => DropdownMenuItem(
          value: gender,
          child: Text(
            gender,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      )
          .toList(),
      onChanged: (value) {
        selectedGender = value;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.withOpacity(0.4),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white, fontSize: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      dropdownColor: Colors.grey,
    ),
  );
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
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

class MalaysiaPhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text;

    if (newText.isEmpty) {
      return newValue;
    }

    // Remove non-digit characters
    String digitsOnly = newText.replaceAll(RegExp(r'\D'), '');

    // Add prefix if not present
    if (!digitsOnly.startsWith('60')) {
      digitsOnly = '60$digitsOnly';
    }

    // Format the number
    String formattedNumber = '';
    int digitIndex = 0;
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i == 2) {
        formattedNumber += ' '; // Space after 60
      } else if (i == 5 || i == 8) {
        formattedNumber += '-'; // Hyphens
      }
      formattedNumber += digitsOnly[digitIndex];
      digitIndex++;
    }

    return TextEditingValue(
      text: formattedNumber,
      selection: TextSelection.collapsed(offset: formattedNumber.length),
    );
  }
}
