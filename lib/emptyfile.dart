import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HeightPage(),
    );
  }
}

class HeightPage extends StatelessWidget {
  final int number = 34;

  const HeightPage({super.key}); // Tukar number yg collect dari iot kat sini

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          children: [
            Text(
              'Your Height:',
              style: TextStyle(
                fontSize: 30, // Font size
                fontWeight: FontWeight.bold, // Make it bold
                color: Colors.black, // Text color
              ),
            ),
            SizedBox(height: 10), // Space between the texts
            Text(
              '$number',
              style: TextStyle(
                fontSize: 48, // Font size
                fontWeight: FontWeight.bold, // Make it bold
                color: Colors.blue, // Text color
              ),
            ),
          ],
        ),
      ),
    );
  }

}
