import 'package:SihatSelaluApp/bottombar.dart';
import 'package:SihatSelaluApp/header.dart';
import 'package:SihatSelaluApp/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(TemplatePage());
}

class TemplatePage extends StatelessWidget {
  const TemplatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TemplatePageToUse(),
    );
  }
}

class TemplatePageToUse extends StatelessWidget {
  const TemplatePageToUse({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.blue.shade900, // Scaffold background color
      drawer: const SideBar(),
      body: Stack(
        children: [
          // Main content wrapped in SingleChildScrollView
          Container(
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
              child: SingleChildScrollView(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Header(),
                    SizedBox(height: screenHeight * 0.02),
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Builder(
                        builder: (context) => IconButton(
                          icon: Icon(
                            FontAwesomeIcons.arrowLeft,
                            color: Colors.white,
                            size: 14,
                          ),
                          onPressed: () {
                            // back button navigation logic here
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    // Add your content here (like About Us, Profile, etc.)
                    Text(
                      'Some Content Here',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenHeight * 0.025,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.15), // Margin to allow space for BottomBar
                  ],
                ),
              ),
            ),
          ),

          // Positioned BottomBar outside the Scaffold
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: const BottomBar(), // BottomBar positioned at the bottom
          ),
        ],
      ),
    );
  }

//To put widget or section
}