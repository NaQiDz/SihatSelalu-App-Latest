import 'package:SihatSelaluApp/bottombar.dart';
import 'package:SihatSelaluApp/header.dart';
import 'package:SihatSelaluApp/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

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

class HomePageToUse extends StatefulWidget {
  HomePageToUse({super.key});

  @override
  _HomePageToUseState createState() => _HomePageToUseState();
}

class _HomePageToUseState extends State<HomePageToUse> {
  List<ChartData> chartData = [];
  List<ProgressBarData> progressBarData = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      await fetchChartData();
      await fetchProgressBarData();
    } catch (e) {
      setState(() {
        errorMessage = '\n\n\n\n\n\n\n\n\n\n\nPlease Add Your Child And Use IOT First';
      });
      print('Error fetching data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchChartData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('ID');
    // Replace with your server's IP address and port
    await dotenv.load(fileName: '.env');
    String? serverIp;
    serverIp = dotenv.env['ENVIRONMENT']! == 'dev'
        ? dotenv.env['DB_HOST_EMU']!
        : dotenv.env['DB_HOST_IP'];
    final response = await http.get(Uri.parse(
        'http://$serverIp/SihatSelaluAppDatabase/childbardata.php?userId=$userId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<ChartData> fetchedData = [];
      final random = Random();

      for (var item in data) {
        fetchedData.add(ChartData(
          item['child_username'],
          double.parse(item['total_records']),
          Color.fromRGBO(
            random.nextInt(256),
            random.nextInt(256),
            random.nextInt(256),
            0.6,
          ),
        ));
      }

      setState(() {
        chartData = fetchedData;
      });
    } else {
      // Handle error
      throw Exception('Failed to load chart data: ${response.statusCode}');
    }
  }

  Future<void> fetchProgressBarData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('ID');
    try {
      // Load environment variables
      await dotenv.load(fileName: '.env');

      String? serverIp = dotenv.env['ENVIRONMENT'] == 'dev'
          ? dotenv.env['DB_HOST_EMU']
          : dotenv.env['DB_HOST_IP'];

      if (serverIp == null || serverIp.isEmpty) {
        throw Exception('Server IP not found in environment variables');
      }

      // Perform the HTTP GET request
      final response = await http.get(Uri.parse('http://$serverIp/SihatSelaluAppDatabase/get_calorie_progress.php?userId=$userId'));

      // Check the response status code
      if (response.statusCode == 200) {
        // Attempt to parse the response body as JSON
        try {
          final List<dynamic> data = json.decode(response.body);
          List<ProgressBarData> fetchedData = data.map((item) {
            double totalCalorie = double.tryParse(item['total_calorie'] ?? '0') ?? 0;
            double suggestedCalorie = double.tryParse(item['suggestion_calorie'] ?? '0') ?? 0;
            double progressValue = suggestedCalorie > 0 ? totalCalorie / suggestedCalorie : 0;
            if (progressValue > 1.0) {
              progressValue = 1.0;
            }
            return ProgressBarData(
              childUsername: item['child_username'] ?? '',
              progressValue: progressValue,
            );
          }).toList();

          // Update the state with the fetched data
          setState(() {
            progressBarData = fetchedData;
          });
        } catch (jsonError) {
          throw Exception('Error parsing JSON response: $jsonError');
        }
      } else {
        throw Exception('Failed to load progress data: ${response.statusCode}');
      }
    } catch (e) {
      // Catch and log any errors that occur during the process
      throw Exception('Error fetching progress data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    DateTime now = DateTime.now();
    // Format the date using DateFormat
    String formattedDate = DateFormat('d, MMM yyyy').format(now);

    return Scaffold(
      backgroundColor: Colors.blue.shade900, // Scaffold background color
      drawer: const SideBar(),
      body: Stack(
        children: [
          // Main content wrapped in SingleChildScrollView
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.lightBlue.shade900],
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
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight * 0.02),
                          Text(
                            'Today | $formattedDate,',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: screenHeight * 0.025,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          if (isLoading)
                            Center(child: CircularProgressIndicator())
                          else if (errorMessage.isNotEmpty)
                            Center(
                              child: Text(
                                errorMessage,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenHeight * 0.02,
                                ),
                              ),
                            )
                          else
                            _buildUsageSection(screenHeight, screenWidth), // Custom widget
                          SizedBox(height: screenHeight * 0.02),
                          Center( // Center the Calorie Remaining text
                            child: Text(
                              'Calorie Remaining',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenHeight * 0.02,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          if (!isLoading && errorMessage.isEmpty)
                            for (var data in progressBarData)
                              _buildProgressBar(screenWidth, data), // Custom widget
                        ],
                      ),
                    ),
                    SizedBox(
                        height: screenHeight *
                            0.15), // Margin to allow space for BottomBar
                  ],
                ),
              ),
            ),
          ),

          // Positioned BottomBar outside the Scaffold
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: const BottomBar(), // BottomBar positioned at the bottom
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double screenWidth, ProgressBarData data) {
    int percentage = (data.progressValue * 100).toInt();
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: screenWidth * 0.04), // Add margin between progress bars
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.childUsername,
                style: TextStyle(color: Colors.white),
              ),
              Text(
                '$percentage%',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: screenWidth * 0.02),
          Container(
            height: screenWidth * 0.03,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: data.progressValue,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageSection(double screenHeight, double screenWidth) {
    // Calculate total for percentages
    double total = chartData.fold(0, (sum, item) => sum + item.y);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'IoT Usage',
            style: TextStyle(
              color: Colors.white,
              fontSize: screenHeight * 0.02,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: screenWidth * 0.45,
                height: screenWidth * 0.5,
                child: SfCircularChart(
                  series: <CircularSeries>[
                    PieSeries<ChartData, String>(
                      dataSource: chartData,
                      pointColorMapper: (ChartData data, _) => data.color,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      dataLabelMapper: (ChartData data, _) =>
                      '${data.x}\n${(data.y / total * 100).toStringAsFixed(0)}%', // Show name and percentage
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: screenHeight *
                                0.012), // Adjust label style
                      ),
                      radius: '100%',
                    ),
                  ],
                ),
              ),
              SizedBox(width: screenWidth * 0.04),
              // Legend with percentages

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: chartData.map((data) {
                  return Padding(
                    padding:
                    EdgeInsets.symmetric(vertical: screenHeight * 0.005),
                    child: Row(
                      children: [
                        Container(
                          width: screenWidth * 0.03,
                          height: screenWidth * 0.03,
                          decoration: BoxDecoration(
                            color: data.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Text(
                          '${data.x}: ${(data.y / total * 100).toStringAsFixed(0)}%',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenHeight * 0.015),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);

  final String x;
  final double y;
  final Color color;
}

class ProgressBarData {
  final String childUsername;
  final double progressValue;

  ProgressBarData({
    required this.childUsername,
    required this.progressValue,
  });
}