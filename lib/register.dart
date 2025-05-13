import 'dart:convert';
import 'package:SihatSelaluApp/choose.dart';      // Ensure path is correct
import 'package:SihatSelaluApp/login.dart';       // Ensure path is correct
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';       // For SystemUiOverlayStyle and input formatters
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// Main Stateless Widget - No MaterialApp
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Return the stateful widget directly
    return const RegisterStylePage();
  }
}

// Stateful Widget for managing state
class RegisterStylePage extends StatefulWidget {
  const RegisterStylePage({super.key});

  @override
  State<RegisterStylePage> createState() => _RegisterStylePageState();
}

class _RegisterStylePageState extends State<RegisterStylePage> {
  // --- State Variables ---
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _selectedGender; // Holds the selected gender
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // --- Dispose Controllers ---
  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // --- Validation Helper Functions ---
  bool _isValidEmail(String email) {
    // More robust email regex
    return RegExp(r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    // Basic validation for digits, allows optional + and common lengths
    // You might want a more specific regex depending on your target audience
    return RegExp(r'^\+?[0-9]{9,15}$').hasMatch(phoneNumber.replaceAll(RegExp(r'[-\s]'), '')); // Remove spaces/dashes before check
  }

  bool _isValidAge(String input) {
    if (input.isEmpty) return false;
    final age = int.tryParse(input);
    // Allow ages from e.g., 1 to 120
    return age != null && age > 0 && age < 120;
  }


  // --- Registration Logic ---
  Future<void> _registerUser() async {
    // Validate the form first
    if (!_formKey.currentState!.validate()) {
      _showPopup("Validation Error", "Please fix the errors in the form.", isError: true);
      return; // Stop if validation fails
    }

    // Check if passwords match (already handled by validator, but good double check)
    if (_passwordController.text != _confirmPasswordController.text) {
      _showPopup("Validation Error", "Passwords do not match.", isError: true);
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    await dotenv.load(fileName: '.env');
    String? serverIp;

    try {
      serverIp = dotenv.env['ENVIRONMENT']! == 'dev'
          ? dotenv.env['DB_HOST_EMU']!
          : dotenv.env['DB_HOST_IP'];
      String uri = "http://$serverIp/SihatSelaluAppDatabase/register.php"; // Your API endpoint

      print("Attempting registration to: $uri"); // Debug print

      var res = await http.post(
        Uri.parse(uri),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": _usernameController.text.trim(),
          "email": _emailController.text.trim(),
          "phone": _phoneController.text.trim(), // Send cleaned phone number if needed
          "age": _ageController.text.trim(),
          "gender": _selectedGender,
          "password": _passwordController.text, // Send the actual password
        }),
      ).timeout(const Duration(seconds: 20)); // Increased timeout slightly

      print("Response status: ${res.statusCode}"); // Debug print
      print("Response body: ${res.body}");       // Debug print


      if (res.statusCode == 200) {
        var response = jsonDecode(res.body);
        // Adjust condition based on your API's actual success response
        if (response["success"] == "true" || response["success"] == true) {
          _showPopup("Success", "Registration successful! You can now log in.", isError: false, navigateToLogin: true);
        } else {
          // Show specific error from backend if available
          _showPopup("Registration Failed", response["message"] ?? "Could not register user. Please try again.", isError: true);
        }
      } else {
        _showPopup("Connection Error", "Server error: ${res.statusCode}. Please try again later.", isError: true);
      }

    } on FormatException catch (e) {
      print("JSON parsing error: $e");
      _showPopup("Error", "Invalid response format from server.", isError: true);
    } catch (e) {
      print("Registration exception: $e");
      _showPopup("Error", "An error occurred: ${e.toString()}. Please check your connection.", isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
      }
    }
  }

  // --- Popup Dialog --- (Similar to Login Page's popup)
  void _showPopup(String title, String message, {required bool isError, bool navigateToLogin = false}) {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: !navigateToLogin, // Prevent dismissal if navigating away
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.grey[800]?.withOpacity(0.9),
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isError ? Colors.redAccent : Colors.greenAccent,
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
              child: Text('OK', style: TextStyle(color: Colors.white.withOpacity(0.8))),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                if (navigateToLogin) {
                  // Navigate to Login Page after successful registration
                  Navigator.pushReplacement( // Use pushReplacement to avoid going back to register
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                }
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

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light, // Icons light on black top gradient
    ));

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.lightBlue.shade900],
            stops: const [0.0, 0.8], // Adjust gradient transition
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.00),
                    // --- Back Button ---
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          } else {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ChoosePage()));
                          }
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.00),

                    // --- Header ---
                    Text(
                      'Create Your Account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.lightBlue,
                        fontSize: screenHeight * 0.032,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      'Join the NutriGuardian community!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: screenHeight * 0.018,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),

                    // --- Form Fields ---
                    TextFormField(
                      controller: _usernameController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.text,
                      decoration: _buildInputDecoration(
                        hintText: 'Username',
                        prefixIcon: Icons.person_outline,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a username';
                        }
                        if (value.trim().length < 3) {
                          return 'Username must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      decoration: _buildInputDecoration(
                        hintText: 'Email Address',
                        prefixIcon: Icons.email_outlined,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter an email address';
                        }
                        if (!_isValidEmail(value.trim())) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    TextFormField(
                      controller: _phoneController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Allow only digits initially
                      decoration: _buildInputDecoration(
                        hintText: 'Phone Number (e.g., 60123456789)',
                        prefixIcon: Icons.phone_outlined,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a phone number';
                        }
                        if (!_isValidPhoneNumber(value.trim())) {
                          return 'Enter a valid phone number (10-15 digits)';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    Row( // Age and Gender side-by-side
                      children: [
                        Expanded( // Age Field
                          flex: 2, // Takes less space
                          child: TextFormField(
                            controller: _ageController,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)], // Allow max 2 digits
                            decoration: _buildInputDecoration(
                              hintText: 'Age',
                              prefixIcon: Icons.cake_outlined, // Calendar icon might also work
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Enter age';
                              }
                              if (!_isValidAge(value.trim())) {
                                return 'Invalid age'; // Keep it simple
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10), // Space between fields
                        Expanded( // Gender Dropdown
                          flex: 3, // Takes more space
                          child: DropdownButtonFormField<String>(
                            value: _selectedGender,
                            items: ['Male', 'Female', 'Other']
                                .map((gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(gender), // Text color handled by theme
                            ))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              }
                            },
                            style: const TextStyle(color: Colors.white, fontSize: 16), // Style for items in dropdown list
                            dropdownColor: Colors.grey[800], // Background color of dropdown
                            iconEnabledColor: Colors.white70, // Color of the dropdown arrow
                            decoration: _buildInputDecoration(
                                hintText: 'Gender',
                                prefixIcon: Icons.wc_outlined, // Gender icon
                                // Remove border settings if using helper, or customize here
                                contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 10.0), // Adjust padding for dropdown
                                // Ensure other decoration properties match _buildInputDecoration
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.25),
                                enabledBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.white.withOpacity(0.3))),
                                focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(12.0), borderSide: const BorderSide(color: Colors.white, width: 1.5)),
                                errorBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(12.0), borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
                                focusedErrorBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(12.0), borderSide: const BorderSide(color: Colors.redAccent, width: 2.0)),
                                border: OutlineInputBorder( borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none)
                            ).copyWith(hintStyle: TextStyle(color: Colors.white.withOpacity(0.7))), // Apply hintStyle separately if needed
                            validator: (value) {
                              if (value == null) {
                                return 'Select gender';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: _buildInputDecoration(
                        hintText: 'Password (8-15 characters)',
                        prefixIcon: Icons.lock_outline,
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.white70),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 8 || value.length > 15) {
                          return 'Password must be 8-15 characters long';
                        }
                        // Add more checks like uppercase, number, symbol if needed
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: _buildInputDecoration(
                        hintText: 'Confirm Password',
                        prefixIcon: Icons.lock_outline,
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.white70),
                          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.04),

                    // --- Sign Up Button ---
                    ElevatedButton(
                      onPressed: _isLoading ? null : _registerUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, screenHeight * 0.065),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                      child: _isLoading
                          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                          : Text(
                        'Sign Up',
                        style: TextStyle(fontSize: screenHeight * 0.02, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03), // Bottom spacing before potential "Already have account" link

                    // --- Optional: Link to Login ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?", style: TextStyle(color: Colors.white.withOpacity(0.7))),
                        TextButton(
                          onPressed: _isLoading ? null : () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                          },
                          style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 4)),
                          child: Text("Log In", style: TextStyle(color: Colors.blue.shade400, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.03), // Final bottom padding
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper for Input Decoration --- (Copied/Adapted from Login Page)
  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
    EdgeInsetsGeometry? contentPadding, // Allow custom padding
    InputBorder? border,               // Allow custom border
    InputBorder? enabledBorder,
    InputBorder? focusedBorder,
    InputBorder? errorBorder,
    InputBorder? focusedErrorBorder,
    bool? filled,
    Color? fillColor,
    TextStyle? hintStyle,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: hintStyle ?? TextStyle(color: Colors.white.withOpacity(0.7)),
      prefixIcon: Icon(prefixIcon, color: Colors.white70, size: 22), // Slightly smaller icon
      suffixIcon: suffixIcon,
      filled: filled ?? true,
      fillColor: fillColor ?? Colors.black.withOpacity(0.25),
      contentPadding: contentPadding ?? const EdgeInsets.symmetric(vertical: 18.0, horizontal: 15.0),
      border: border ?? OutlineInputBorder( borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
      enabledBorder: enabledBorder ?? OutlineInputBorder( borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.white.withOpacity(0.3))),
      focusedBorder: focusedBorder ?? OutlineInputBorder( borderRadius: BorderRadius.circular(12.0), borderSide: const BorderSide(color: Colors.white, width: 1.5)),
      errorBorder: errorBorder ?? OutlineInputBorder( borderRadius: BorderRadius.circular(12.0), borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
      focusedErrorBorder: focusedErrorBorder ?? OutlineInputBorder( borderRadius: BorderRadius.circular(12.0), borderSide: const BorderSide(color: Colors.redAccent, width: 2.0)),
      errorStyle: const TextStyle(fontSize: 12, height: 1.1), // Customize error text style slightly
    );
  }
}