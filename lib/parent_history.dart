import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const ParentHistoryPage());
}

class ParentHistoryPage extends StatelessWidget {
  const ParentHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ParentHistoryScreen(),
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
                const SizedBox(height: 20),
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
              child: const Icon(
                FontAwesomeIcons.clipboardList,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
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
        const Icon(
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
          const SizedBox(height: 20),
          _buildMonthlySummarySection(),
          const SizedBox(height: 20),
          _buildBarChartSection(),
        ],
      ),
    );
  }

  Widget _buildDailyGoalSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildProgressRow(label: 'Daily Goal:'),
          const SizedBox(height: 8),
          _buildProgressRow(label: 'Current Intake:'),
          const SizedBox(height: 16),
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              shape: BoxShape.circle,
            ),
            child: const Center(
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
        Text(label, style: const TextStyle(color: Colors.white)),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Monthly Summary',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Container(
            height: 100,
            decoration: BoxDecoration(
              image: const DecorationImage(
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

  Widget _buildBarChartSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bar Chart Analysis',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 16),
          const BarChartSample(),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
            destination: const ParentHistoryScreen(),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                FontAwesomeIcons.qrcode,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ParentHistoryScreen()),
                );
              },
            ),
          ),
          _buildNavItem(
            context,
            label: 'Track Calorie',
            icon: FontAwesomeIcons.search,
            destination: const ParentHistoryScreen(),
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
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class BarChartSample extends StatelessWidget {
  const BarChartSample({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
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
              getTitlesWidget: (value, meta) => Text(
                (value.toInt() + 1).toString(),
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: true),
        barGroups: List.generate(
          12,
              (index) {
            final data = [10, 20, 30, 40, 50, 60, 70, 80, 90, 60, 80, 100];
            return generateBarChartGroupData(index, data[index].toDouble());
          },
        ),
      ),
    );
  }

  BarChartGroupData generateBarChartGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(toY: y, color: Colors.black),
      ],
    );
  }
}
