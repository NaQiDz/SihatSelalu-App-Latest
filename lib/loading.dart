import 'dart:async';
import 'package:SihatSelaluApp/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'started.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

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
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isConnected = true; // Assume connected initially

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    sendApiLinkToPhp();

  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    _updateConnectionStatus(connectivityResult);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      isConnected = result != ConnectivityResult.none;
    });
    if (isConnected) {
      _navigateToNextPage();
    } else {
      _showConnectivityDialog();
    }
  }

  void _navigateToNextPage() {
    Future.delayed(Duration(seconds: 4), () {
      getValidationData().whenComplete(() async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => accessEmail == null &&
                  accessID == null &&
                  accessUsername == null
                  ? StartedPage()
                  : HomePage()),
        );
      });
    });
  }

  void _showConnectivityDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("No Internet Connection"),
          content: Text("Please connect to your Wi-Fi or mobile data."),
          actions: <Widget>[
            TextButton(
              child: Text("Retry"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _checkConnectivity(); // Check connectivity again
              },
            ),
          ],
        );
      },
    );
  }

  String? accessEmail;
  String? accessID;
  String? accessUsername;

  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
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

  Future<void> sendApiLinkToPhp() async {
    // Load environment variables
    await dotenv.load(fileName: '.env');

    // Get server IP based on environment
    String? serverIp = dotenv.env['ENVIRONMENT'] == 'dev'
        ? dotenv.env['DB_HOST_EMU']
        : dotenv.env['DB_HOST_IP'];

    if (serverIp == null || serverIp.isEmpty) {
      print('Error: Server IP not found in .env file or ENVIRONMENT is not set.');
      return;
    }

    // Construct the PHP endpoint URL with the apiLink as a query parameter
    final phpEndpoint = Uri.parse(
        'http://$serverIp/SihatSelaluAppDatabase/functions.php?api_link=start');

    try {
      // Use http.get() since we are not sending a body
      final response = await http.get(phpEndpoint);

      if (response.statusCode == 200) {
        print('API link sent successfully!');
        print('Response from PHP server: ${response.body}');
      } else {
        print('Failed to send API link. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error sending API link: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.lightBlue.shade900],
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
                    'sources/logo3.png',
                    height: screenHeight * 0.4,
                    width: screenWidth * 0.5,
                  )
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.05),
              child: isConnected
                  ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
                  : Column(
                children: [
                  Icon(
                    Icons.wifi_off,
                    size: screenHeight * 0.1,
                    color: Colors.white,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    "No Internet Connection",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenHeight * 0.02,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
