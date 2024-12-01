import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(CalPage());
}

class CalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalCaloriePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalCaloriePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.blue.shade900],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(
                            FontAwesomeIcons.clipboardList,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 90),
                        Text(
                          'SihatSelalu App',
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      FontAwesomeIcons.bell,
                      color: Colors.white,
                    ),
                  ],
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          print('Calculate BMI tapped!');
                          //Navigator.push(
                          //context,
                          //MaterialPageRoute(builder: (context) => QrPage()),
                          //);
                        },
                        child: Column(
                          children: [
                            Icon(
                              FontAwesomeIcons.calculator,
                              color: Colors.white,
                              size: 32,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Calculate BMI',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),

                      // QR Navigation Button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: InkWell(
                          onTap: () {
                            //Navigator.push(
                            //context,
                            //MaterialPageRoute(builder: (context) => QrPage()),
                            //);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(
                              FontAwesomeIcons.qrcode,
                              color: Colors.black,
                              size: 36,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              //Navigator.push(
                              //context,
                              //MaterialPageRoute(builder: (context) => QrPage()),
                              //);
                            },
                            child: Column(
                              children: [
                                Icon(
                                  FontAwesomeIcons.search,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Track Calorie',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
