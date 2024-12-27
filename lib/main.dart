import 'package:flutter/material.dart';
import 'loading.dart';

void main() {
  runApp(MyApp());
}

//naqid
//lisha

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Main Page',
      home: LoadingPage(),
    );
  }
}
