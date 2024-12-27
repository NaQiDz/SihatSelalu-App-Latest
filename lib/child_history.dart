import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(ChildHistoryApp());
}

class ChildHistoryApp extends StatelessWidget {
  const ChildHistoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChildHistoryPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ChildHistoryPage extends StatelessWidget {
  const ChildHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(screenWidth),
                SizedBox(height: screenHeight * 0.05),
                Expanded(
                  child: ListView(
                    children: [
                      _buildSection(
                        context,
                        title: "Calories Consume",
                        content: Column(
                          children: [
                            CircleAvatar(
                              radius: screenWidth * 0.15,
                              backgroundImage: NetworkImage(
                                'https://storage.googleapis.com/a1aa/image/Da5I3v9MsPaLDhKsgjxvfaP44evjJqT3IzzX38bTfe74vUbPB.jpg',
                              ),
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.sentiment_satisfied,
                                    color: Colors.yellow[700]),
                                SizedBox(width: 8),
                                Text(
                                  "Great Job! Let's eat healthier tomorrow.",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      _buildSection(
                        context,
                        title: "Monthly Summary",
                        content: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: 100,
                            barTouchData: BarTouchData(enabled: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 28,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value.toInt().toString(),
                                      style: TextStyle(fontSize: 10, color: Colors.white),
                                    );
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 28,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      (value.toInt() + 1).toString(),
                                      style: TextStyle(fontSize: 10, color: Colors.white),
                                    );
                                  },
                                ),
                              ),
                            ),
                            gridData: FlGridData(show: true),
                            borderData: FlBorderData(show: true),
                            barGroups: [
                              BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 10, color: Colors.black)]),
                              BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 20, color: Colors.black)]),
                              BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 30, color: Colors.black)]),
                              BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 40, color: Colors.black)]),
                              BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 50, color: Colors.black)]),
                              BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 60, color: Colors.black)]),
                              BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 70, color: Colors.black)]),
                              BarChartGroupData(x: 7, barRods: [BarChartRodData(toY: 80, color: Colors.black)]),
                              BarChartGroupData(x: 8, barRods: [BarChartRodData(toY: 90, color: Colors.black)]),
                              BarChartGroupData(x: 9, barRods: [BarChartRodData(toY: 60, color: Colors.black)]),
                              BarChartGroupData(x: 10, barRods: [BarChartRodData(toY: 80, color: Colors.black)]),
                              BarChartGroupData(x: 11, barRods: [BarChartRodData(toY: 100, color: Colors.black)]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(
                FontAwesomeIcons.clipboardList,
                color: Colors.white,
              ),
            ),
            SizedBox(width: screenWidth * 0.18),
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

  Widget _buildSection(BuildContext context,
      {required String title, required Widget content}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue.shade900, Colors.black],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context,
            label: 'Calculate BMI',
            icon: FontAwesomeIcons.calculator,
            destination: ChildHistoryPage(),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                FontAwesomeIcons.qrcode,
                color: Colors.black,
              ),
              onPressed: () {
                // QR navigation
              },
            ),
          ),
          _buildNavItem(
            context,
            label: 'Track Calorie',
            icon: FontAwesomeIcons.search,
            destination: ChildHistoryPage(),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context,
      {required String label, required IconData icon, required Widget destination}) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => destination));
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
