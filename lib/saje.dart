import 'package:SihatSelaluApp/bottombar.dart';
import 'package:SihatSelaluApp/header.dart';
import 'package:SihatSelaluApp/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

void main() {
  runApp(TemplatePage());
}

class TemplatePage extends StatelessWidget {
  const TemplatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TemplatePageToUse(),
    );
  }
}

class TemplatePageToUse extends StatefulWidget {
  const TemplatePageToUse({super.key});

  @override
  State<TemplatePageToUse> createState() => _TemplatePageToUseState();
}

class _TemplatePageToUseState extends State<TemplatePageToUse> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      drawer: const SideBar(),
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
          child: SingleChildScrollView(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Header(),
                SizedBox(height: screenHeight * 0.02),
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text(
                      "Check Your\nWeight and Height",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                // Row for Ruler and other content
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ruler Section (Left Side)
                    Expanded(
                      flex: 3, // Increased flex from 2 to 4
                      child: SizedBox(
                        height: screenHeight * 0.6, // Decreased height from 0.65 to 0.55
                        child: _buildRuler(),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.05), // Added space between sections
                    // Placeholder for other content (Right Side)
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          // Radial Gauge Section
                          SizedBox(
                            height: screenHeight * 0.26, // Adjusted height for the radial gauge
                            child: _buildRadialGauge(),
                          ),
                          SizedBox(height: screenHeight * 0.02), // Space between sections
                          // Right Section with Info Rows
                          Container(
                            height: screenHeight * 0.32,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.6), // Background color for the container
                              borderRadius: BorderRadius.circular(15),
                            ), // Adjusted height for the info section
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: screenHeight * 0.02),
                                _buildInfoRow("Name", "Child name"),
                                SizedBox(height: screenHeight * 0.01),
                                _buildInfoRow("Weight", "13 kg"),
                                SizedBox(height: screenHeight * 0.01),
                                _buildInfoRow("Height", "123 cm"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )

                  ],
                ),
                // Adjusted SizedBox height here
                SizedBox(height: screenHeight * 0.1),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }

  Widget _buildRuler() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6), // Background color for the container
        borderRadius: BorderRadius.circular(15), // Rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Centered Title for the Gauge
          Center(
            child: Text(
              'Height',
              style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10), // Space between title and gauge
          // Linear Gauge with Animated Range
          Expanded(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 123), // Animate from 0 to 90
              duration: const Duration(seconds: 2), // Set the animation duration
              builder: (context, value, child) {
                return SfLinearGauge(
                  minimum: 0,
                  maximum: 180,
                  orientation: LinearGaugeOrientation.vertical,
                  ranges: <LinearGaugeRange>[
                    LinearGaugeRange(
                      startValue: 0,
                      endValue: value, // Animated end value
                      color: Colors.blue.shade900, // Color for the range
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildRadialGauge() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6), // Background color for the container
        // Background color for the gauge container
        borderRadius: BorderRadius.circular(15), // Rounded corners
      ),
      child: SfRadialGauge(
        title: GaugeTitle(
          text: 'Weight',
          textStyle: TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold),
        ),
        enableLoadingAnimation: true,
        animationDuration: 4500,
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 75,
            pointers: <GaugePointer>[
              NeedlePointer(value: 30, enableAnimation: true),
            ],
            ranges: <GaugeRange>[
              GaugeRange(startValue: 0, endValue: 25, color: Colors.green),
              GaugeRange(startValue: 25, endValue: 50, color: Colors.orange),
              GaugeRange(startValue: 50, endValue: 75, color: Colors.red),
            ],
            annotations: <GaugeAnnotation>[
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 12.0), // Add padding here
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label Text
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenWidth * 0.009), // Space between label and value

          // Value Container
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(screenWidth * 0.02),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

}