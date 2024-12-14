import 'package:flutter/material.dart';

void main() {
  runApp(SihatSelaluApp());
}

class SihatSelaluApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AccountPage(),
    );
  }
}

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Icon(Icons.menu),
        title: Text('SihatSelalu App', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Icon(Icons.notifications),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text('Account', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey,
            child: Text('Image', style: TextStyle(color: Colors.black)),
          ),
          SizedBox(height: 10),
          Text('YOUR NAME', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: [
                AccountOption(
                  title: 'Your Account',
                  subtitle: 'email@gmail.com',
                  icon: Icons.account_circle,
                ),
                AccountOption(
                  title: 'Your Child',
                  icon: Icons.child_care,
                ),
                AccountOption(
                  title: 'Record Health',
                  icon: Icons.health_and_safety,
                ),
                AccountOption(
                  title: 'History Usage',
                  icon: Icons.history,
                ),
                AccountOption(
                  title: 'About System',
                  icon: Icons.info,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Icon(Icons.calculate, color: Colors.white),
                Text('Calculate BMI', style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Icon(Icons.qr_code, color: Colors.white),
                Text('QR Code', style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Icon(Icons.home, color: Colors.white),
                Text('Home', style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}

class AccountOption extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;

  AccountOption({required this.title, this.subtitle, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[600],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: Colors.white)),
                  if (subtitle != null)
                    Text(subtitle!, style: TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ],
          ),
          Icon(Icons.chevron_right, color: Colors.white),
        ],
      ),
    );
  }
}