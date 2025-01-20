import 'package:SihatSelaluApp/bottombar.dart';
import 'package:SihatSelaluApp/choosechildrecord.dart';
import 'package:SihatSelaluApp/header.dart';
import 'package:SihatSelaluApp/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecordPage extends StatelessWidget {
  final int childId;
  const RecordPage({super.key, required this.childId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RecordPageToUse(childId: childId),
    );
  }
}

class RecordPageToUse extends StatefulWidget {
  final int childId;
  const RecordPageToUse({super.key, required this.childId});

  @override
  State<RecordPageToUse> createState() => _RecordPageToUseState();
}

class _RecordPageToUseState extends State<RecordPageToUse> {
  List<FlSpot> weightSpots = [];
  List<FlSpot> heightSpots = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await dotenv.load(fileName: '.env');
    String? serverIp;
    serverIp = dotenv.env['ENVIRONMENT']! == 'dev'
        ? dotenv.env['DB_HOST_EMU']!
        : dotenv.env['DB_HOST_IP'];
    final response = await http.get(
      Uri.parse('http://$serverIp/SihatSelaluAppDatabase/record_child_data.php?childId=${widget.childId}'), // Replace with your server address
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        weightSpots = (data['weight'] as List)
            .map((item) => FlSpot(item['x'].toDouble(), item['y'].toDouble()))
            .toList();
        heightSpots = (data['height'] as List)
            .map((item) => FlSpot(item['x'].toDouble(), item['y'].toDouble()))
            .toList();
      });
    } else {
      // Handle error, e.g., show an error message
      print('Failed to load data: ${response.statusCode}');
    }
  }

  String getMonthName(double value) {
    if (value >= 0 && value < 12) {
      return DateFormat('MMM').format(DateTime(2023, value.toInt() + 1));
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
                colors: [Colors.black, Colors.blue.shade900],
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
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.arrowLeft,
                            color: Colors.white,
                            size: 14,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const ChooseRecordPage()),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.00),
                    Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            'Child Weight & Height History',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          weightSpots.isNotEmpty
                              ? _buildChartCard('WEIGHT', weightSpots, Colors.red)
                              : const CircularProgressIndicator(),
                          const SizedBox(height: 20),
                          heightSpots.isNotEmpty
                              ? _buildChartCard('HEIGHT', heightSpots, Colors.blue)
                              : const CircularProgressIndicator(),
                          const SizedBox(height: 20),
                          // Add this SizedBox to add space at the bottom
                          SizedBox(
                              height:
                              80), // Adjust the height based on BottomBar's height
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(String title, List<FlSpot> spots, Color lineColor) {
    // Find min and max values for Y-axis
    double minY = spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
    double maxY = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);

    // Adjust minY and maxY to have some padding
    minY = (minY - (minY * 0.1)).floorToDouble();
    maxY = (maxY + (maxY * 0.1)).ceilToDouble();
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                minY: minY,
                maxY: maxY,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  drawHorizontalLine: true,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: Colors.black12,
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return const FlLine(
                      color: Colors.black12,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(getMonthName(value),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              )),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text('${value.toInt()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ));
                      },
                      reservedSize: 28,
                      interval: (maxY - minY) / 5, // Adjust the number of intervals as needed
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: const Color(0xff37434d), width: 1),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: lineColor,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                            radius: 4,
                            color: lineColor.withOpacity(0.8),
                            strokeWidth: 2,
                            strokeColor: lineColor,
                          ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: lineColor.withOpacity(0.3),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    // No tooltipBgColor available
                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          final flSpot = barSpot;

                          return LineTooltipItem(
                            '${title == 'WEIGHT' ? 'Weight:' : 'Height:'} ${flSpot.y.toStringAsFixed(1)} ${title == 'WEIGHT' ? 'kg' : 'cm'}\nMonth: ${getMonthName(flSpot.x)}',
                            const TextStyle(
                              color: Colors.black87, // Customize text color
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      }),
                  getTouchedSpotIndicator:
                      (LineChartBarData barData, List<int> spotIndexes) {
                    return spotIndexes.map((spotIndex) {
                      final spot = barData.spots[spotIndex];
                      return TouchedSpotIndicatorData(
                        const FlLine(
                            color: Colors.blueGrey,
                            strokeWidth: 4), // Customize touch indicator
                        FlDotData(
                          getDotPainter: (spot, percent, barData, index) =>
                              FlDotCirclePainter(
                                radius: 6,
                                color: Colors.white,
                                strokeWidth: 2,
                                strokeColor: Colors.blueGrey,
                              ),
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}