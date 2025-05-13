import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for SystemUiOverlayStyle
import 'choose.dart'; // Your next page after onboarding

class StartedPage extends StatefulWidget {
  const StartedPage({super.key});

  @override
  State<StartedPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<StartedPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Define your onboarding content here
  final List<Map<String, String>> _onboardingData = [
    {
      "image": "sources/img1.png", // Make sure this path is correct in pubspec.yaml
      "title": "Welcome to SihatSelalu",
      "description": "Your personal health companion. Let's get started on your wellness journey.",
    },
    {
      "image": "sources/img2.png", // Add another image for the second screen
      "title": "Track Your BMI",
      "description": "Easily monitor your Body Mass Index in real-time with connected devices or manual input.",
    },
    {
      "image": "sources/img3.png", // Add a third image
      "title": "Calorie Suggestions",
      "description": "Get personalized calorie intake suggestions with just one click to help you achieve your goals.",
    },
  ];

  @override
  void dispose() {
    _pageController.dispose(); // Dispose controller to prevent memory leaks
    super.dispose();
  }

  void _navigateToChoosePage() {
    // Ensure navigation replaces the onboarding stack
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ChoosePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Set status bar color to transparent for better gradient visibility
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // Adjust if background is dark at top
    ));

    return Scaffold(
      body: Container(
        // Apply the gradient background to the entire screen
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.lightBlue.shade900],
            stops: const [0.0, 0.7], // Adjust stops for gradient transition
          ),
        ),
        child: SafeArea( // Ensures content avoids notches and system bars
          child: Column(
            children: [
              // Skip Button (Top Right)
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _navigateToChoosePage,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.blueGrey.shade700, // Adjust color for visibility
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              // PageView for Onboarding Screens
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _onboardingData.length,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemBuilder: (context, index) {
                    return OnboardingScreen(
                      imageData: _onboardingData[index],
                    );
                  },
                ),
              ),

              // Page Indicators and Navigation Button
              _buildBottomSection(),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget for Bottom Section (Indicators and Button)
  Widget _buildBottomSection() {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(
        left: screenWidth * 0.05,
        right: screenWidth * 0.05,
        bottom: screenHeight * 0.05, // More space at the bottom
        top: screenHeight * 0.02,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Page Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _onboardingData.length,
                  (index) => _buildPageIndicator(index == _currentPage),
            ),
          ),

          // Next / Get Started Button
          _currentPage < _onboardingData.length - 1
              ? SizedBox(
            width: screenHeight * 0.06,
            height: screenHeight * 0.06,
            child: ElevatedButton(
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: EdgeInsets.all(screenHeight * 0.012),
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.white, width: 1.5),
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.blueAccent,
              ),
            ),
          )
              : TextButton(
            onPressed: _navigateToChoosePage,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.08,
                vertical: screenHeight * 0.018,
              ),
            ),
            child: Text(
              'Get Started',
              style: TextStyle(
                color: Colors.white,
                fontSize: screenHeight * 0.018,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }

  // Helper Widget for Page Indicator Dot
  Widget _buildPageIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0, // Active dot is wider
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white54, // Active/Inactive color
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}


// StatelessWidget for individual onboarding screen content
class OnboardingScreen extends StatelessWidget {
  final Map<String, String> imageData;

  const OnboardingScreen({super.key, required this.imageData});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08), // Horizontal padding
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
        children: [
          // Flexible makes the image take available space but not overflow
          Flexible(
            flex: 4, // Adjust flex factor as needed
            child: Image.asset(
              imageData['image']!,
              fit: BoxFit.contain, // Ensure image fits well
              height: screenHeight * 0.35, // Adjust height as needed
            ),
          ),
          SizedBox(height: screenHeight * 0.05), // Spacing

          // Title Text
          Text(
            imageData['title']!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white, // Make title white for better contrast on gradient
              fontSize: screenHeight * 0.03,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenHeight * 0.02), // Spacing

          // Description Text
          Text(
            imageData['description']!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.85), // Slightly transparent white
              fontSize: screenHeight * 0.018,
              height: 1.4, // Line height for readability
            ),
          ),
          SizedBox(height: screenHeight * 0.1), // Add some bottom buffer space within the pageview item
        ],
      ),
    );
  }
}