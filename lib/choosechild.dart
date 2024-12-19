import 'package:SihatSelaluApp/bottombar.dart';
import 'package:SihatSelaluApp/header.dart';
import 'package:SihatSelaluApp/iotsection.dart';
import 'package:SihatSelaluApp/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';

class chooseChildPage extends StatelessWidget {
  const chooseChildPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const SideBar(),
      body: Container(
        // Gradient Background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.blue.shade900],
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                // Scrollable Section with Opacity Gradient
                SingleChildScrollView(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      const Header(),
                      const SizedBox(height: 20),
                      // Center the Text and CircleAvatar
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Choose Your Child',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.grey.shade300,
                              child: Icon(
                                Icons.scale,
                                size: 50,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Scrollable Section
                      _buildChildInputField(1, 'Child Name', 'Age', context),
                      const SizedBox(height: 10),
                      _buildChildInputField(1, 'Child Name', 'Age', context),
                      const SizedBox(height: 10),
                      _buildChildInputField(1, 'Child Name', 'Age', context),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),

            // Recently Used Section - Sticky at Bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildRecentlyUsedSection(context),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: const BottomBar(),
    );
  }

  Widget _buildChildInputField(int count, String name, String age, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => IOTPage()), // Replace with your actual ProfilePage
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
        // Adjust margin for spacing
        height: 45,
        // Set a custom height for the entire input field container
        width: double.infinity,
        // Make it take the full width of the screen
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          leading: Text(
            '$count.', // Convert count to string for proper display
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          title: Text(
            '$name', // Display the name in the title section
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          trailing: Text(
            'Age: $age', // Display the age in the trailing section
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentlyUsedSection(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipPath(
        clipper: ProsteBezierCurve(
          position: ClipPosition.top,
          list: [
            BezierCurveSection(
              start: const Offset(0, 72),
              top: const Offset(90, 20),
              end: const Offset(0, 70),
            ),
          ],
        ),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(top: 45, bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E2E7D),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Text(
                  'Recently used',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              _buildRecentlyUsedItem('1. Child name', '34 Kg', '123 Cm'),
              const SizedBox(height: 10),
              _buildRecentlyUsedItem('2. Child name', '34 Kg', '123 Cm'),
              const SizedBox(height: 10),
              _buildRecentlyUsedItem('3. Child name', '34 Kg', '123 Cm'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentlyUsedItem(String name, String weight, String height) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(color: Colors.black, fontSize: 14)),
          Text(weight, style: const TextStyle(color: Colors.black, fontSize: 14)),
          Text(height, style: const TextStyle(color: Colors.black, fontSize: 14)),
        ],
      ),
    );
  }
}
