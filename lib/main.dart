import 'package:flutter/material.dart';
import 'loading.dart';

void main() {
  runApp(MyApp());
}

//naqid
//lisha

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main Page',
      home: LoadingPage(),
    );
  }
}
