import 'dart:convert';
import 'package:SihatSelaluApp/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:SihatSelaluApp/bottombar.dart';
import 'package:SihatSelaluApp/header.dart';
import 'package:SihatSelaluApp/sidebar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Privacypage extends StatelessWidget {
  const Privacypage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PrivacyPage(),
    );
  }
}

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  _PrivacyPageState createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? errorMessage;
  String? username;
  String? oldPassword;
  String? newPassword;
  String? confirmNewPassword;
  bool isPasswordVerified = false; // Flag for password verification

  @override
  void initState() {
    super.initState();
    _loadUsernameAndFetchUser();
  }

  Future<void> _loadUsernameAndFetchUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('Username');
    if (username != null) {
      await fetchUser();
    } else {
      setState(() {
        isLoading = false;
        errorMessage = "Username not found. Please log in.";
      });
    }
  }

  Future<void> fetchUser() async {
    await dotenv.load(fileName: '.env');
    String? serverIp = dotenv.env['ENVIRONMENT'] == 'dev'
        ? dotenv.env['DB_HOST_EMU']
        : dotenv.env['DB_HOST_IP'];

    if (serverIp == null) {
      setState(() {
        isLoading = false;
        errorMessage = "Server configuration error.";
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
      userData = null;
    });

    try {
      final response = await http.post(
        Uri.parse('http://$serverIp/SihatSelaluAppDatabase/manageuser.php'),
        body: {'username': username},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is Map<String, dynamic> && data.containsKey('Password')) {
          setState(() {
            userData = data;
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage =
                data['error'] ?? data['message'] ?? 'Invalid data format';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Request failed with status: ${response.statusCode}.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      drawer: const SideBar(),
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Header(),
                SizedBox(height: screenHeight * 0.02),
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Builder(
                    builder: (context) => IconButton(
                      icon: Icon(
                        FontAwesomeIcons.arrowLeft,
                        color: Colors.white,
                        size: 14,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsScreen()),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.00),
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: screenHeight * 0.03,
                        backgroundColor: Colors.transparent,
                        child: FaIcon(
                          FontAwesomeIcons.lock,
                          size: screenHeight * 0.05,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        'Privacy',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenHeight * 0.025,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      _buildForm(context, screenHeight, screenWidth),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }

  Widget _buildForm(
      BuildContext context, double screenHeight, double screenWidth) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Text(
          "Error: $errorMessage",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    if (userData == null) {
      return Center(
        child: Text(
          "User data not available.",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          SizedBox(height: 10),
          if (!isPasswordVerified)
            _buildTextField(
              label: 'Old Password',
              onChanged: (value) {
                oldPassword = value;
              },
            ),
          if (!isPasswordVerified) SizedBox(height: 10),
          if (!isPasswordVerified)
            ElevatedButton(
              onPressed: () {
                _verifyOldPassword();
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
                'Verify Password',
                style: TextStyle(
                  fontSize: screenHeight * 0.015,
                  color: Colors.white,
                ),
              ),
            ),
          if (isPasswordVerified)
            _buildTextField(
              label: 'New Password',
              onChanged: (value) {
                newPassword = value;
              },
            ),
          if (isPasswordVerified) SizedBox(height: 10),
          if (isPasswordVerified)
            _buildTextField(
              label: 'Re-enter New Password',
              onChanged: (value) {
                confirmNewPassword = value;
              },
            ),
          if (isPasswordVerified) SizedBox(height: screenHeight * 0.04),
          if (isPasswordVerified)
            ElevatedButton(
              onPressed: () {
                _changePassword();
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
                'Change Password',
                style: TextStyle(
                  fontSize: screenHeight * 0.015,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    void Function(String)? onChanged,
  }) {
    return SizedBox(
      height: 45,
      child: TextField(
        enabled: true,
        obscureText: true, // Always obscure password fields
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        style: TextStyle(color: Colors.white),
        onChanged: onChanged,
      ),
    );
  }

  void _verifyOldPassword() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('Username');
    if (username == null || oldPassword == null) {
      _showError("Username or old password is null.");
      return;
    }

    // Load environment variables
    await dotenv.load(fileName: '.env');
    String? serverIp = dotenv.env['ENVIRONMENT'] == 'dev'
        ? dotenv.env['DB_HOST_EMU']
        : dotenv.env['DB_HOST_IP'];

    if (serverIp == null) {
      _showError("Server IP not configured.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://$serverIp/SihatSelaluAppDatabase/verify_password.php'),
        body: {
          'username': username,
          'password': oldPassword,
        },
      );
      print('Username : $username Password : $oldPassword');

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        print('Error code: ${response.body}');
        if (responseJson['status'] == 'success') {
          setState(() {
            isPasswordVerified = true;
          });
        } else if (responseJson['status'] == 'failure') {
          _showError("Incorrect old password.");
        } else {
          _showError("Unexpected response format: ${response.body}");
        }
      } else {
        _showError("Server error: ${response.statusCode}");
        print('Username : $username Password : $oldPassword');
      }
    } catch (e) {
      _showError("An error occurred: $e");
    }
  }


  void _changePassword() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('Username');
    if (username == null || newPassword == null || confirmNewPassword == null) {
      print("Error: Username, newPassword, or confirmNewPassword is null.");
      return;
    }

    if (newPassword != confirmNewPassword) {
      print("Error: New passwords do not match.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("New passwords do not match."),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    await dotenv.load(fileName: '.env');
    String? serverIp = dotenv.env['ENVIRONMENT'] == 'dev'
        ? dotenv.env['DB_HOST_EMU']
        : dotenv.env['DB_HOST_IP'];

    if (serverIp == null) {
      print("Error: Server IP not configured.");
      return;
    }

    final response = await http.post(
      Uri.parse('http://$serverIp/SihatSelaluAppDatabase/updateuser.php'),
      body: {
        'username': username!,
        'newPassword': newPassword!,
      },
    );

    if (response.statusCode == 200) {
      try {
        if (response.body.isNotEmpty) {
          final responseJson = json.decode(response.body);
          if (responseJson['status'] == 'success') {
            setState(() {
              userData!['Password'] = newPassword!;
              isPasswordVerified = false; // Reset after successful change
              oldPassword = null; // Clear the fields
              newPassword = null;
              confirmNewPassword = null;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Password changed successfully!"),
                duration: Duration(seconds: 3),
              ),
            );
          } else {
            print("Error updating password: ${responseJson['message']}");
          }
        } else {
          print("Error: Response body is empty.");
        }
      } catch (e) {
        print("Error parsing JSON response: $e");
      }
    } else {
      print("Error: ${response.statusCode}");
      print("Error: ${response.body}");
    }
  }

  void _showError(String message) {
    print("Error: $message");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }
}