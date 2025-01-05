import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';  // Add this import

void main() {
  runApp(ParentHistoryPage());
}

class ParentHistoryPage extends StatelessWidget {
  const ParentHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ParentHistoryScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ParentHistoryScreen extends StatelessWidget {
  const ParentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 20),
                Expanded(child: _buildContent()),
                _buildBottomNavigation(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
            SizedBox(width: 16),
            Text(
              'SihatSelalu App',
              style: TextStyle(
                color: Colors.blue[900],
                fontSize: 20,
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

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDailyGoalSection(),
          SizedBox(height: 20),
          _buildMonthlySummarySection(),
          SizedBox(height: 20),
          BarChartSample(),  // Add the BarChart here
        ],
      ),
    );
  }

  Widget _buildDailyGoalSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildProgressRow(label: 'Daily Goal:'),
          SizedBox(height: 8),
          _buildProgressRow(label: 'Current Intake:'),
          SizedBox(height: 16),
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                "Child's daily calorie intake",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRow({required String label}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.white)),
        Container(
          width: 100,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.grey[500],
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlySummarySection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Summary',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 8),
          Container(
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://storage.googleapis.com/a1aa/image/fS1RIAFfAfS3bpr4JOXqmfH0jBTC1nbYAgw7pB9SgTrHGVbPB.jpg'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
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
            destination: ParentHistoryScreen(),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ParentHistoryScreen()),
                );
              },
            ),
          ),
          _buildNavItem(
            context,
            label: 'Track Calorie',
            icon: FontAwesomeIcons.search,
            destination: ParentHistoryScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, {required String label, required IconData icon, required Widget destination}) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
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

// BarChartSample widget (corrected code)
class BarChartSample extends StatelessWidget {
  const BarChartSample({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return Text(
                    (value.toInt() + 1).toString(),
                    style: TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: true),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [
              BarChartRodData(toY: 10, color: Colors.black)
            ]),
            BarChartGroupData(x: 1, barRods: [
              BarChartRodData(toY: 20, color: Colors.black)
            ]),
            BarChartGroupData(x: 2, barRods: [
              BarChartRodData(toY: 30, color: Colors.black)
            ]),
            BarChartGroupData(x: 3, barRods: [
              BarChartRodData(toY: 40, color: Colors.black)
            ]),
            BarChartGroupData(x: 4, barRods: [
              BarChartRodData(toY: 50, color: Colors.black)
            ]),
            BarChartGroupData(x: 5, barRods: [
              BarChartRodData(toY: 60, color: Colors.black)
            ]),
            BarChartGroupData(x: 6, barRods: [
              BarChartRodData(toY: 70, color: Colors.black)
            ]),
            BarChartGroupData(x: 7, barRods: [
              BarChartRodData(toY: 80, color: Colors.black)
            ]),
            BarChartGroupData(x: 8, barRods: [
              BarChartRodData(toY: 90, color: Colors.black)
            ]),
            BarChartGroupData(x: 9, barRods: [
              BarChartRodData(toY: 60, color: Colors.black)
            ]),
            BarChartGroupData(x: 10, barRods: [
              BarChartRodData(toY: 80, color: Colors.black)
            ]),
            BarChartGroupData(x: 11, barRods: [
              BarChartRodData(toY: 100, color: Colors.black)
            ]),
          ],
        ),
      ),
    );
  }
}
