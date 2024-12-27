import 'package:flutter/material.dart';

void main() {
  runApp(SihatSelaluApp());
}

class SihatSelaluApp extends StatelessWidget {
  const SihatSelaluApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: SihatSelaluAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              const ProfileAvatar(),
              SizedBox(height: 20),
              IntroductionSection(),
              BmiSection(),
              HealthTipsSection(),
            ],
          ),
        ),
        bottomNavigationBar: SihatSelaluBottomNavigationBar(),
      ),
    );
  }
}

class SihatSelaluAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SihatSelaluAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      title: Text('SihatSelalu App'),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30,
      backgroundImage: NetworkImage(
        'https://storage.googleapis.com/a1aa/image/G5JF3NimGX54A5geGXQfMqceqMa9FSB6WuMESlyfGFe6uDlfE.jpg',
      ),
    );
  }
}

class IntroductionSection extends StatelessWidget {
  const IntroductionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ReusableSection(
      title: 'INTRODUCTION',
      content:
      'This project addresses childhood obesity by developing a smartphone application that can be used to monitor and manage weight and health tips. The app provides educational resources, BMI calculation, and personalized health tips to encourage healthy eating and physical activity.',
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
      imageUrl:
      'https://storage.googleapis.com/a1aa/image/QWqQtA0zThLIMp7iuTNu570kqeNrRnlapVwCyTocBq06OUeTA.jpg',
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
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
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
            ),
          if (content != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                content!,
                style: TextStyle(fontSize: 14, color: Colors.white),
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
