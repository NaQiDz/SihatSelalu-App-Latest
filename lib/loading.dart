import 'package:SihatSelaluApp/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'started.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {

    // Navigate to MainPage after 4 seconds
    Future.delayed(Duration(seconds: 4), () {
      getValidationData().whenComplete(() async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => accessEmail == null && accessID == null && accessUsername == null ? StartedPage() : HomePage()),
        );
      });
    });
    super.initState();
  }
  String? accessEmail;
  String? accessID;
  String? accessUsername;

  Future getValidationData() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var obtainEmail = sharedPreferences.getString('Email');
    var obtainID = sharedPreferences.getString('ID');
    var obtainUsername = sharedPreferences.getString('Username');
    setState(() {
      accessEmail = obtainEmail;
      accessID = obtainID;
      accessUsername = obtainUsername;
    });
    print('Email : $accessEmail ID: $accessID');
  }

  @override
  Widget build(BuildContext context) {
    // Get screen height using MediaQuery
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.blue.shade900],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'sources/logo.png', // Ensure this matches the path in pubspec.yaml
                    height: screenHeight * 0.2, // 20% of screen height
                    width: screenWidth * 0.3,  // 30% of screen width
                  ),
                  SizedBox(height: screenHeight * 0.02), // 2% of screen height
                  Text(
                    'SihatSelalu App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenHeight * 0.03, // 3% of screen height
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.05), // 5% of screen height
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
