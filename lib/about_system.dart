import 'package:SihatSelaluApp/accountpage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:SihatSelaluApp/bottombar.dart';
import 'package:SihatSelaluApp/header.dart';
import 'package:SihatSelaluApp/sidebar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TemplatePageToUse(),
    );
  }
}

@override
void initState(){
  _loadSessionData();
}

void _loadSessionData() async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AccountPage()),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.00),
                    AboutUsContent(), // Add the content for "About Us" here
                    SizedBox(height: screenHeight * 0.15), // Margin for the bottom
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

}

class AboutUsContent extends StatelessWidget {
  const AboutUsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 0),
        const ProfileAvatar(),
        SizedBox(height: 2),
        IntroductionSection(),
        HealthTipsSection(),
        BmiSection(),
      ],
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 50,
      backgroundImage: AssetImage('sources/logo2.png')
    );
  }
}

class IntroductionSection extends StatelessWidget {
  const IntroductionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ReusableSection(
      title: 'HEALTH INFO',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white, size: 24),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Welcome to Our Health Management App',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'This project addresses childhood obesity by developing a smartphone '
                'application designed to monitor and manage weight and health tips. '
                'The app provides educational resources, BMI calculation, and '
                'personalized health tips to encourage healthy eating and physical activity.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[300],
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Add your action here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent, // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded button
                ),
              ),
              child: Text(
                'Learn More',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BmiSection extends StatelessWidget {
  const BmiSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ReusableSection(
      title: 'HOW BMI WORKS',
      content: 'BMI =\nweight (kg)\nheight x height (m)',
      imageUrl: 'https://storage.googleapis.com/a1aa/image/QWqQtA0zThLIMp7iuTNu570kqeNrRnlapVwCyTocBq06OUeTA.jpg',
    );
  }
}

class HealthTipsSection extends StatelessWidget {
  const HealthTipsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ReusableSection(
      title: 'HEALTH TIPS',
      child: Column(
        children: [
          HealthTip(icon: Icons.directions_run, text: 'Stay Active'),
          SizedBox(height: 10),
          HealthTip(icon: Icons.restaurant, text: 'Eat Balanced Meals'),
          SizedBox(height: 10),
          HealthTip(icon: Icons.favorite, text: 'Monitor Progress'),
        ],
      ),
    );
  }
}

class HealthTip extends StatelessWidget {
  final IconData icon;
  final String text;

  const HealthTip({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ],
    );
  }
}

class ReusableSection extends StatelessWidget {
  final String title;
  final String? content;
  final String? imageUrl;
  final Widget? child;

  const ReusableSection({super.key,
    required this.title,
    this.content,
    this.imageUrl,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2), // Increased opacity for stronger color
        borderRadius: BorderRadius.circular(15), // More rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // Darker shadow for more depth
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 4), // Shadow position for a "floating" effect
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20, // Increased font size for more prominence
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          if (imageUrl != null)
            Image.network(
              imageUrl!,
              height: 100,
              fit: BoxFit.cover, // Ensures the image fits nicely
            ),
          if (content != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                content!,
                style: TextStyle(fontSize: 16, color: Colors.white), // Increased font size
                textAlign: TextAlign.center,
              ),
            ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class SihatSelaluBottomNavigationBar extends StatelessWidget {
  const SihatSelaluBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.grey[900],
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          label: 'Track Calories',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code),
          label: 'Plan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Monitor',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
