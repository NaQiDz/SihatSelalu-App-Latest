import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomBarScreen(),
    );
  }
}

class BottomBarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Text(
          'Main Content Area',
          style: TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Bottom navigation background
        Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItemBottom(Icons.home, 'Home'),
              _buildNavItemBottom(Icons.star_border, 'Track Calorie'),
              SizedBox(width: 20), // Space for the floating QR icon
              _buildNavItemBottom(Icons.star, 'Plan'),
              _buildNavItemBottom(Icons.calculate, 'Calculate BMI'),
            ],
          ),
        ),
        // Floating QR Code Button
        Positioned(
          top: -44, // Adjust the position for the larger size
          left: MediaQuery.of(context).size.width / 2 - 42, // Center it properly
          child: Container(
            width: 80, // Make the circle bigger
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle, // Ensures the circle shape
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 4), // Adds subtle shadow
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.qr_code,
                size: 60, // Larger QR code icon
                color: Colors.black,
              ),
            ),
          ),
        ),

      ],
    );
  }

  Widget _buildNavItemBottom(IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 28,
        ),
        SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

