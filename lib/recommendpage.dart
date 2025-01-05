import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class RecommendationPage extends StatefulWidget {
  final int userId;
  RecommendationPage({required this.userId});
  @override
  _RecommendationPageState createState() => _RecommendationPageState();
}
class _RecommendationPageState extends State<RecommendationPage> {
  late Future<Map<String, dynamic>> recommendation;
  Future<Map<String, dynamic>> fetchRecommendation() async {
    final response = await http.get(Uri.parse('http://172.20.10.3/SihatSelaluDatabase/get_recommendation.php?user_id=${widget.userId}'));
        if (response.statusCode == 200) {
    return jsonDecode(response.body);
    } else {
    throw Exception('Failed to load recommendation');
    }
    }
  @override
  void initState() {
    super.initState();
    recommendation = fetchRecommendation();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calorie Recommendation"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: recommendation,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final data = snapshot.data!;
            return Center(
              child: Text(
                "Recommended Calories: ${data['adjusted_calories'].toStringAsFixed(2)} kcal",
                style: TextStyle(fontSize: 24),
              ),
            );
          }
        },
      ),
    );
  }
}
void main() {
  runApp(MaterialApp(home: RecommendationPage(userId: 1)));
}