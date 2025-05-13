import 'dart:convert';
import 'package:SihatSelaluApp/home.dart';          // Ensure this path is correct
import 'package:SihatSelaluApp/session_manager.dart'; // Ensure this path is correct
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';          // For SystemUiOverlayStyle
import 'package:flutter_dotenv/flutter_dotenv.dart'; // For environment variables
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'choose.dart';                            // For back navigation fallback
import 'forgot_password.dart';                   // For forgot password navigation

// Main widget - No MaterialApp here, assumes one exists higher up the widget tree
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // For validation (optional but good practice)
  bool _isLoading = false; // To show loading indicator on the button
  bool _obscurePassword = true; // To toggle password visibility

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- Login Logic ---
  Future<void> _loginUser() async {
    // Basic validation (can be enhanced with _formKey.currentState!.validate())
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      _showPopup("Validation Error", "Please enter both username and password.", isError: true);
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await dotenv.load(fileName: '.env'); // Load environment variables

    String? serverIp;
    try {
      // Determine server IP based on environment
      serverIp = dotenv.env['ENVIRONMENT']! == 'dev'
          ? dotenv.env['DB_HOST_EMU']!
          : dotenv.env['DB_HOST_IP'];
      String uri = "http://$serverIp/SihatSelaluAppDatabase/login.php"; // Your API endpoint

      print("Attempting login to: $uri"); // Debug print

      // Make the HTTP POST request
      var res = await http.post(
        Uri.parse(uri),
        headers: {"Content-Type": "application/json"}, // Set content type for JSON body
        body: jsonEncode({
          "username": _usernameController.text.trim(), // Trim whitespace
          "password": _passwordController.text,
        }),
      ).timeout(const Duration(seconds: 15)); // Add timeout

      print("Response status: ${res.statusCode}"); // Debug print
      print("Response body: ${res.body}");       // Debug print

      if (res.statusCode == 200) {
        var response = jsonDecode(res.body); // Decode JSON response

        if (response["success"] == "true" || response["success"] == true) { // Handle boolean or string "true"
          // Check if essential data exists
          if (response["data"] != null &&
              response["data"]["userid"] != null &&
              response["data"]["username"] != null &&
              response["data"]["email"] != null)
          {

            // Start session using SessionManager (if you have one)
            SessionManager.startSession(
              response["token"] ?? "", // Use token if available
              response["data"]["userid"].toString(), // Ensure ID is string
              response["data"]["username"],
              response["data"]["email"],
              response["data"]["icon"], // Handle potential null icon
            );

            // Save essential info to SharedPreferences as fallback or for other uses
            await prefs.setString('Email', response["data"]["email"]);
            await prefs.setString('ID', response["data"]["userid"].toString());
            await prefs.setString('Username', response["data"]["username"]);

            // Show success message (optional, can navigate directly)
            _showPopup("Success", "Login successful!", isError: false);

            // Navigate to HomePage, replacing the login stack
            if (mounted) { // Check if widget is still in the tree
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()), // Ensure HomePageToUse exists
                    (Route<dynamic> route) => false, // Remove all previous routes
              );
            }

          } else {
            _showPopup("Login Failed", "Incomplete user data received from server.", isError: true);
          }

        } else {
          // Show specific error message from backend if available
          _showPopup("Login Failed", response["message"] ?? "Invalid username or password.", isError: true);
        }
      } else {
        // Handle non-200 HTTP status codes
        _showPopup("Connection Error", "Server error: ${res.statusCode}. Please try again later.", isError: true);
      }
    } on FormatException catch (e) {
      print("JSON parsing error: $e");
      _showPopup("Error", "Invalid response format from server.", isError: true);
    } catch (e) {
      // Handle network errors, timeouts, etc.
      print("Login exception: $e");
      _showPopup("Error", "An error occurred: ${e.toString()}. Please check your connection.", isError: true);
    } finally {
      // Ensure loading indicator is turned off regardless of outcome
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // --- Popup Dialog ---
  void _showPopup(String title, String message, {required bool isError}) {
    // Check if the context is still valid
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: true, // Allow dismissal by tapping outside
      builder: (BuildContext context) {
        // Optional: Auto-close after a few seconds
        // Future.delayed(Duration(seconds: 3), () {
        //   if (Navigator.of(context).canPop()) {
        //     Navigator.of(context).pop();
        //   }
        // });

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Softer corners
          ),
          backgroundColor: Colors.grey[800]?.withOpacity(0.9), // Darker, slightly transparent background
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isError ? Colors.redAccent : Colors.greenAccent, // Brighter error/success colors
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          actions: [
            TextButton(
              child: const Text('OK', style: TextStyle(color: Colors.white70)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }


  // --- Build Method ---
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // Icons visible on white top gradient
    ));

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.lightBlue.shade800,
              Colors.lightBlue.shade900,
            ],
            stops: const [0.0, 0.5, 1.0], // Adjust gradient transition
          ),
        ),
        child: SafeArea( // Avoid status bar overlap
          child: SingleChildScrollView( // Allow scrolling on smaller screens
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08), // Consistent padding
              child: Form( // Wrap with Form for potential validation
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center vertically in available space
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.02), // Space from top safe area

                    // --- Back Button ---
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black54, size: 28), // Icon color visible on white
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context); // Use pop instead of push
                          } else {
                            // Fallback if cannot pop (e.g., this is the first screen)
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ChoosePage()));
                          }
                        },
                      ),
                    ),

                    // --- Header Text ---
                    Padding(
                      // Adjust padding if needed based on image size
                      padding: EdgeInsets.only(top: screenHeight * 0.04, bottom: screenHeight * 0.02),
                      child: Text(
                        'Welcome Back!',
                        style: TextStyle(
                          color: Colors.blue.shade800, // Dark blue matching lower gradient
                          fontSize: screenHeight * 0.035, // Larger text
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // --- Image --- Added this section ---
                    Image.asset(
                      'sources/img2.png', // Make sure this path is correct and image exists
                      height: screenHeight * 0.20, // Adjust height as needed (e.g., 20% of screen height)
                      fit: BoxFit.contain, // Ensures the image scales nicely
                    ),
                    SizedBox(height: screenHeight * 0.04), // Spacing after the image
                    // --- End of Added Image Section ---


                    // --- Username Field ---
                    TextFormField(
                      controller: _usernameController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.text,
                      decoration: _buildInputDecoration(
                        hintText: 'Username',
                        prefixIcon: Icons.person_outline,
                      ),
                      validator: (value) { // Optional: Add validation
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.025),

                    // --- Password Field ---
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword, // Use state variable
                      style: const TextStyle(color: Colors.white),
                      decoration: _buildInputDecoration(
                        hintText: 'Password',
                        prefixIcon: Icons.lock_outline,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword; // Toggle visibility
                            });
                          },
                        ),
                      ),
                      validator: (value) { // Optional: Add validation
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.015), // Smaller space before forgot password

                    // --- Forgot Password Link ---
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _isLoading ? null : () { // Disable when loading
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ForgotPassword()), // Ensure ForgotPassword exists
                          );
                        },
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05), // Space before Login button

                    // --- Login Button ---
                    ElevatedButton(
                      onPressed: _isLoading ? null : _loginUser, // Disable button when loading
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, screenHeight * 0.065), // Full width, fixed height
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // Consistent corner rounding
                        ),
                        elevation: 5,
                      ),
                      child: _isLoading
                          ? const SizedBox( // Show loading indicator inside button
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                          : Text(
                        'Login',
                        style: TextStyle(
                          fontSize: screenHeight * 0.02,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05), // Bottom spacing
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper function remains the same
  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    // ... (Keep the existing helper function code)
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
      prefixIcon: Icon(prefixIcon, color: Colors.white70),
      suffixIcon: suffixIcon, // Add suffix icon if provided
      filled: true,
      fillColor: Colors.black.withOpacity(0.25), // Subtle dark fill
      contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 15.0),
      border: OutlineInputBorder( // Default border
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none, // No visible border by default
      ),
      enabledBorder: OutlineInputBorder( // Border when enabled but not focused
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)), // Faint white border
      ),
      focusedBorder: OutlineInputBorder( // Border when focused
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Colors.white, width: 1.5), // Brighter white border on focus
      ),
      errorBorder: OutlineInputBorder( // Border when there's a validation error
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder( // Border when focused with an error
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
      ),
    );
  }
}
