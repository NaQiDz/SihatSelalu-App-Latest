import 'package:SihatSelaluApp/bottombar.dart';
import 'package:SihatSelaluApp/header.dart';
import 'package:SihatSelaluApp/session_manager.dart';
import 'package:SihatSelaluApp/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePageToUse(),
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

class HomePageToUse extends StatelessWidget {
  String? username = SessionManager.username;
  String? email = SessionManager.email;

  HomePageToUse({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      drawer: const SideBar(),
      body: Stack(
        children: [
          Container(
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
                    const Header(),
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
        ],
      ),
      bottomNavigationBar: const BottomBar(), // Bottom bar
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
//To put widget or section
}