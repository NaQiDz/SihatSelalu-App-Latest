import 'package:SihatSelaluApp/bmi_bar.dart';
import 'package:SihatSelaluApp/choosechild.dart';
import 'package:SihatSelaluApp/home.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
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
              _buildNavItemBottom(Icons.home, 'Home', context, HomePage()),
              _buildNavItemBottom(Icons.track_changes, 'Track Calorie', context, HomePage()),
              SizedBox(width: 20), // Space for the floating QR icon
              _buildNavItemBottom(Icons.tips_and_updates, 'Plan', context, HomePage()),
              _buildNavItemBottom(
                Icons.calculate,
                'Calculate BMI',
                context, BMIBarPage(
                themeUpdater: ({required String name, required Brightness brightness, required double contrast}) {
                  // Provide a valid function body here
                  // For now, it's a placeholder that does nothing
                },
              ),
              )

            ],
          ),
        ),
        // Floating Button
        Positioned(
          top: -25, // Adjust the position for the larger size
          left: MediaQuery
              .of(context)
              .size
              .width / 2 - 30, // Center it properly
          child: GestureDetector( // Wrap it in GestureDetector to handle tap
            onTap: () {
              // Navigate to the new page when the button is clicked
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    childchoosePage()), // Replace with the desired page
              );
            },
            child: Container(
              width: 60, // Make the circle bigger
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white, // Scale Button background color
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
                  Icons.monitor_weight,
                  size: 40, // Larger Scale icon
                  color: Colors.black, // Scale icon color
                ),
              ),
            ),
          ),
        ),

      ],
    );
  }

  Widget _buildNavItemBottom(IconData icon, String label, BuildContext context, Widget targetPage) {
    return GestureDetector(
      onTap: () {
        // Check if targetPage is provided, and only navigate if it's not null
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
            },
      child: Column(
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
      ),
    );
  }
}
