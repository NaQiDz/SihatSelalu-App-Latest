import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: SfLinearGauge(
            minimum: 0,
            maximum: 180,
            orientation: LinearGaugeOrientation.vertical,
            ranges: <LinearGaugeRange>[
              LinearGaugeRange(startValue: 0, endValue: 30, color: Colors.green),
              LinearGaugeRange(startValue: 30, endValue: 50, color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'Flutter Demo',
    home: MyHomePage(title: 'Linear Gauge'),
  ));
}