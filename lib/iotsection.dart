import 'package:SihatSelaluApp/bottombar.dart';
import 'package:SihatSelaluApp/header.dart';
import 'package:SihatSelaluApp/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class IOTPage extends StatelessWidget {
  const IOTPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IOTPageToUse(),
    );
  }
}

class IOTPageToUse extends StatefulWidget {
  const IOTPageToUse({super.key});

  @override
  State<IOTPageToUse> createState() => _IOTPageToUse();
}

class _IOTPageToUse extends State<IOTPageToUse> {
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
                SizedBox(height: screenHeight * 0.01),
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
                  crossAxisAlignment: CrossAxisAlignment.start, // Ensures proper vertical alignment
                  children: [
                    // Ruler Section (Left Side)
                    SizedBox(
                      height: screenHeight * 0.26, // Equal height for both gauges
                      width: screenWidth * 0.45, // Adjust width as needed
                      child: _buildRadialGaugeWeight(),
                    ),
                    SizedBox(width: screenWidth * 0.05), // Space between sections
                    // Placeholder for other content (Right Side)
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          // Radial Gauge Section
                          SizedBox(
                            height: screenHeight * 0.26, // Equal height for both gauges
                            width: screenWidth * 0.45, // Adjust width as needed
                            child: _buildRadialGaugeHeight(),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                // Row for Ruler and other content
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // Ensures proper vertical alignment
                  children: [
                    // Ruler Section (Left Side)
                    Container(
                      height: screenHeight * 0.10, // Set height for the container
                      width: screenWidth * 0.45, // Adjust width as needed
                      padding: const EdgeInsets.all(15), // Padding around the content inside the container
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6), // Background color for the container
                        borderRadius: BorderRadius.circular(15), // Rounded corners
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center, // Vertically center the icon and text
                        children: [
                          // Icon
                          Icon(
                            FontAwesomeIcons.weight,
                            color: Colors.red,
                            size: screenWidth * 0.08, // Adjust icon size based on screen width
                          ),
                          SizedBox(width: screenWidth * 0.02), // Space between icon and text
                          // Weight Value Text
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                            children: [
                              // Title Text
                              SizedBox(height: screenWidth * 0.04), // Space between title and value
                              // Weight Value Text
                              Text(
                                '75 kg', // Example value for weight
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.05, // Adjust font size based on screen width
                                  fontWeight: FontWeight.bold, // Make the text bold
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.05), // Space between sections
                    // Placeholder for other content (Right Side)
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Container(
                            height: screenHeight * 0.10, // Set height for the container
                            width: screenWidth * 0.45, // Adjust width as needed
                            padding: const EdgeInsets.all(15), // Padding around the content inside the container
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6), // Background color for the container
                              borderRadius: BorderRadius.circular(15), // Rounded corners
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center, // Vertically center the icon and text
                              children: [
                                // Icon
                                Icon(
                                  FontAwesomeIcons.ruler,
                                  color: Colors.blue,
                                  size: screenWidth * 0.08, // Adjust icon size based on screen width
                                ),
                                SizedBox(width: screenWidth * 0.02), // Space between icon and text
                                // Weight Value Text
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                                  children: [
                                    // Title Text
                                    SizedBox(height: screenWidth * 0.04), // Space between title and value
                                    // Weight Value Text
                                    Text(
                                      '75 kg', // Example value for weight
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.05, // Adjust font size based on screen width
                                        fontWeight: FontWeight.bold, // Make the text bold
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                // Row for Ruler and other content
                Center(
                  child: Center(
                    child: Container(
                      height: screenHeight * 0.15, // Equal height for both gauges
                      width: screenWidth * 0.9, // Adjust width as needed
                      padding: const EdgeInsets.all(10), // Padding around the gauge
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6), // Background color for the container
                        borderRadius: BorderRadius.circular(15), // Rounded corners
                      ),
                    ),
                  ),
                ),
                // Adjusted SizedBox height here
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }

  Widget _buildRadialGaugeWeight() {
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
              NeedlePointer(value: 0, enableAnimation: true),
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

  Widget _buildRadialGaugeHeight() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6), // Background color for the container
        // Background color for the gauge container
        borderRadius: BorderRadius.circular(15), // Rounded corners
      ),
      child: SfRadialGauge(
        title: GaugeTitle(
          text: 'Height',
          textStyle: TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold),
        ),
        enableLoadingAnimation: true,
        animationDuration: 4500,
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 200,
            pointers: <GaugePointer>[
              NeedlePointer(value: 0, enableAnimation: true),
            ],
            ranges: <GaugeRange>[
              GaugeRange(startValue: 0, endValue: 50, color: Colors.yellow),
              GaugeRange(startValue: 50, endValue: 100, color: Colors.blue),
              GaugeRange(startValue: 100, endValue: 150, color: Colors.green),
              GaugeRange(startValue: 150, endValue: 200, color: Colors.green),
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