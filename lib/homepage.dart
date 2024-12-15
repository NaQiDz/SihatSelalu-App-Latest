import 'package:SihatSelaluApp/started.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'qrpage.dart';
import 'accountpage.dart';

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    );
  }
}

class ChartData {
  final String x;
  final double y;
  final Color color;

  ChartData(this.x, this.y, this.color);
}

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      drawer: _buildSidebar(screenHeight),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.blue.shade900], // Gradient for background
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, screenWidth),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'Today',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenHeight * 0.025,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildCircularChart(screenHeight),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  children: [
                    _buildInfoCard(
                      title: 'Weight:',
                      icon: FontAwesomeIcons.weight,
                      iconColor: Colors.red,
                      screenWidth: screenWidth,
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    _buildInfoCard(
                      title: 'Height:',
                      icon: FontAwesomeIcons.ruler,
                      iconColor: Colors.blue,
                      screenWidth: screenWidth,
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildWeightGoals(screenWidth),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context), // Bottom bar
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
                        'Akmal!', // Replace with dynamic data if needed
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

  Widget _buildCircularChart(double screenHeight) {
    return Container(
      padding: EdgeInsets.all(screenHeight * 0.02),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Calories',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: screenHeight * 0.01),
          Center(
            child: SizedBox(
              width: screenHeight * 0.25,
              height: screenHeight * 0.25,
              child: SfCircularChart(
                annotations: <CircularChartAnnotation>[
                  CircularChartAnnotation(
                    widget: Text(
                      '60%\nRemaining',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenHeight * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
                series: <CircularSeries>[
                  DoughnutSeries<ChartData, String>(
                    dataSource: [
                      ChartData('Consumed', 40, Colors.blue),
                      ChartData('Remaining', 60, Colors.green),
                    ],
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    pointColorMapper: (ChartData data, _) => data.color,
                    innerRadius: '90%',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required double screenWidth,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: screenWidth * 0.02),
            Icon(
              icon,
              color: iconColor,
              size: screenWidth * 0.08,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightGoals(double screenWidth) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weight Goals:',
            style: TextStyle(color: Colors.white),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Text(
                    '${95 - (index * 5)} kg',
                    style: TextStyle(color: Colors.white),
                  ),
                  Divider(color: Colors.white),
                ],
              );
            },
          ),
        ],
      ),
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
            color: Colors.black87, // Bottom bar color
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
          top: -25, // Adjust the position for the larger size
          left: MediaQuery.of(context).size.width / 2 - 30, // Center it properly
          child: Container(
            width: 60, // Make the circle bigger
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white, // QR Button background color
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
                size: 40, // Larger QR code icon
                color: Colors.black, // QR code icon color
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
