import 'package:flutter/material.dart';
import 'choose.dart';

void main() {
  runApp(StartedPage());
}

class StartedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MyStartedPage(),
      ),
    );
  }
}

class MyStartedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Fetch screen height and width using MediaQuery
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.blue.shade900],
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.04), // 4% of screen width as padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.25), // 25% of screen height for spacing
                Image.asset(
                  'sources/img1.png',
                  height: screenHeight * 0.4, // 40% of screen height for image
                  width: screenWidth * 0.8,   // 80% of screen width for image
                ),
                SizedBox(height: screenHeight * 0.02), // 2% of screen height for spacing
                Text(
                  'Welcome to',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenHeight * 0.02, // 2% of screen height for font size
                  ),
                ),
                Text(
                  'SihatSelalu App',
                  style: TextStyle(
                    color: Colors.blue.shade400,
                    fontSize: screenHeight * 0.03, // 3% of screen height for font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02), // 2% of screen height for spacing
                Text(
                  'A smart health monitoring tracks your BMI in real-time using connected devices and Suggestion calorie in just one click',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenHeight * 0.018, // 1.8% of screen height for font size
                  ),
                ),
                SizedBox(height: screenHeight * 0.04), // 4% of screen height for spacing
                ElevatedButton(
                  onPressed: () {
                    // Navigate to ChoosePage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChoosePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(color: Colors.white, width: 2),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.1, // 10% of screen width for padding
                      vertical: screenHeight * 0.02, // 2% of screen height for padding
                    ),
                  ),
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenHeight * 0.02, // 2% of screen height for font size
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
