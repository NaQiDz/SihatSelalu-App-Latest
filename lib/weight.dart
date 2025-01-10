import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: WeightScreen(),
  ));
}

class WeightScreen extends StatefulWidget {
  @override
  _WeightScreenState createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  String _weight = "0";
  Timer? _timer;

  Future<void> fetchWeight() async {
    final url = Uri.parse('http://172.20.10.4/weight'); // Replace with your ESP8266's IP address
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        double weight = double.tryParse(data['weight'].toString()) ?? 0.0;
        setState(() {
          _weight = "${weight.toStringAsFixed(2)} ${data['unit']}"; // Format to 2 decimal places
        });
      }
    } catch (e) {
      setState(() {
        _weight = "Error: $e";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Start a timer to refresh the weight every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      fetchWeight();
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Weight Display")),
      body: Center(
        child: Text(
          _weight,
          style: TextStyle(fontSize: 24),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchWeight,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
