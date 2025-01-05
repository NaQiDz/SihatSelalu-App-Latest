import 'package:flutter/material.dart';

class SlidingTextBox extends StatefulWidget {
  @override
  _SlidingTextBoxState createState() => _SlidingTextBoxState();
}

class _SlidingTextBoxState extends State<SlidingTextBox> {
  double _position = 0.0; // Initial position of the text box

  @override
  Widget build(BuildContext context) {
    // Get the screen width for responsive design
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Sliding Text Box'),
      ),
      body: Center(
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              // Update position based on the horizontal drag
              _position += details.primaryDelta!;
              // Constrain the movement to the screen width
              _position = _position.clamp(0.0, screenWidth - 200); // Ensure it doesn't slide out
            });
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300), // Smooth transition duration
            curve: Curves.easeInOut, // Smooth transition curve
            width: 200, // Set the width of the text box
            height: 100, // Set the height of the text box
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              'Slide Me!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SlidingTextBox(),
  ));
}
