import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For SystemUiOverlayStyle
import 'login.dart';       // Assuming login.dart exists
import 'register.dart';    // Assuming register.dart exists

class ChoosePage extends StatelessWidget {
  const ChoosePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    // Set status bar style for better integration with the gradient
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent, // Make status bar transparent
      statusBarIconBrightness: Brightness.dark, // Icons dark on white top gradient
    ));

    return Scaffold( // Only one Scaffold is needed for the page
      body: Container(
        // Apply the gradient background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.lightBlue.shade900],
            stops: const [0.0, 0.6, 1.0], // Control gradient transition points
          ),
        ),
        child: SafeArea( // Ensures content avoids notches and system bars
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08), // Consistent horizontal padding
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space
              children: [
                // --- Top Section (Logo & Welcome) ---
                Expanded( // Allows this section to take available space pushing buttons down
                  flex: 3, // Takes more space
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: screenHeight * 0.05), // Top spacing
                      Image.asset(
                        'sources/img1.png', // Ensure this asset exists
                        height: screenHeight * 0.28, // Slightly smaller image
                        // width: screenWidth * 0.55, // Adjust if needed
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Text(
                        'NutriGuardian',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenHeight * 0.035,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      Text(
                        'Fuel your body, nourish your life.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenHeight * 0.018,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        'Discover smart nutrition tips, build healthy habits, and take control of your wellness journey—one step at a time.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: screenHeight * 0.016,
                          height: 1.4,
                        ),
                      ),

                    ],
                  ),
                ),

                // --- Bottom Section (Buttons) ---
                Expanded( // Use Expanded instead of Spacer for more control if needed
                  flex: 2, // Takes less space
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Center buttons vertically in their space
                    children: [
                      // Sign Up Button (Primary Action)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600, // Button color
                          foregroundColor: Colors.white, // Text color
                          minimumSize: Size(double.infinity, screenHeight * 0.065), // Full width, fixed height
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // Slightly less rounded
                          ),
                          elevation: 5, // Add subtle shadow
                        ),
                        child: Text(
                          'Create Account', // Clearer text
                          style: TextStyle(
                            fontSize: screenHeight * 0.02,
                            fontWeight: FontWeight.w600, // Bolder text
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02), // Space between buttons

                      // Log In Button (Secondary Action)
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white, // Text color
                          minimumSize: Size(double.infinity, screenHeight * 0.065), // Full width, fixed height
                          side: const BorderSide(color: Colors.white, width: 1.5), // White border
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // Match primary button
                          ),
                        ),
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: screenHeight * 0.02,
                            fontWeight: FontWeight.w600, // Match primary button weight
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04), // Bottom padding
                    ],
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