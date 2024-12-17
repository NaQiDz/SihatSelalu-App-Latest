import 'package:SihatSelaluApp/accountpage.dart';
import 'package:SihatSelaluApp/started.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';

void main() {
  runApp(MaterialApp(home: StickyBottomPage()));
}

class StickyBottomPage extends StatelessWidget {
  const StickyBottomPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: _buildSidebar(screenHeight),
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
                const SizedBox(height: 60),
                _buildHeader(context, screenWidth),
                const SizedBox(height: 60),
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
                  radius: 50,
                  backgroundColor: Colors.grey.shade300,
                  child: Icon(Icons.scale, size: 50, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 20),

                // Scrollable Section with Opacity Gradient
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildChildInputField(),
                        const SizedBox(height: 10),
                        _buildChildInputField(),
                        const SizedBox(height: 10),
                        _buildChildInputField(),
                        const SizedBox(height: 100), // Space before bottom bar
                      ],
                    ),
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
      bottomNavigationBar: _buildBottomBar(context),
    );
  }



  Widget _buildHeader(BuildContext context, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Builder(
                builder: (context) => IconButton(
                  icon: Icon(
                    FontAwesomeIcons.bars,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.19),
            Text(
              'SihatSelalu App',
              style: TextStyle(
                color: Colors.blue[900],
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Icon(
          FontAwesomeIcons.bell,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget _buildSidebar(double screenHeight) {
    return Drawer(
      child: Builder(
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(screenHeight * 0.01),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Section
                Container(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.05),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.05),
                      CircleAvatar(
                        radius: screenHeight * 0.04,
                        backgroundImage: AssetImage('sources/user/user1.jpg'), // Replace with your asset path
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        'Welcome, Akmal!', // Replace with dynamic data if needed
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenHeight * 0.025,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Akmal@gmail.com!', // Replace with dynamic data if needed
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: screenHeight * 0.018,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.0),
                _buildSidebarItem(
                  icon: FontAwesomeIcons.home,
                  title: 'Home',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildSidebarItem(
                  icon: FontAwesomeIcons.user,
                  title: 'Profile',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AccountPage()
                      ),
                    );
                  },
                ),
                _buildSidebarItem(
                  icon: FontAwesomeIcons.cog,
                  title: 'Settings',
                  onTap: () {
                    // Navigate to Settings
                  },
                ),
                Spacer(), // Pushes the logout button to the bottom
                Divider(color: Colors.white70),
                _buildSidebarItem(
                  icon: FontAwesomeIcons.signOutAlt,
                  title: 'Logout',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StartedPage(
                      )),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      onTap: onTap,
    );
  }

  Widget _buildChildInputField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade700,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Text(
          '1.',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Child name',
            hintStyle: const TextStyle(color: Colors.white),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white),
        ),
        trailing: Container(
          width: 60,
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Age',
              hintStyle: TextStyle(color: Colors.white),
              border: InputBorder.none,
            ),
            keyboardType: TextInputType.number,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentlyUsedSection(BuildContext context) {
    return Positioned(
      bottom: 0, // Posisi di bagian bawah
      left: 0,
      right: 0,
      child: ClipPath(
        clipper: ProsteBezierCurve(
          position: ClipPosition.top, // Gelombang di bagian atas
          list: [
            BezierCurveSection(
              start: const Offset(0, 60),
              top: const Offset(110, 0),
              end: const Offset(0, 60),
            ),
          ],
        ),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(top: 50, bottom: 20), // Padding untuk konten
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E2E7D),
                  borderRadius: BorderRadius.circular(20),
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

  Widget _buildBottomBar(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Bottom Bar Container
        Container(
          height: 80,
          decoration: const BoxDecoration(
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
              _buildNavItemBottom(Icons.track_changes, 'Track Calorie'),
              const SizedBox(width: 20), // Space for the floating button
              _buildNavItemBottom(Icons.tips_and_updates, 'Plan'),
              _buildNavItemBottom(Icons.calculate, 'Calculate BMI'),
            ],
          ),
        ),
        // Floating QR Code Button
        Positioned(
          top: -25,
          left: MediaQuery.of(context).size.width / 2 - 30,
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.monitor_weight,
                size: 35,
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
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }
}
