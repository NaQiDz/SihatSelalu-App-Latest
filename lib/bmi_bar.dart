import 'package:SihatSelaluApp/bottombar.dart';
import 'package:SihatSelaluApp/components/theme_settings_screen.dart';
import 'package:SihatSelaluApp/layout.dart';
import 'package:SihatSelaluApp/sidebar.dart';
import 'package:flutter/material.dart';
import 'header.dart';

/// This widget represents the BMI Calculator Page
class BMIBarPage extends StatelessWidget {
  final Function(
      {required String name,
      required Brightness brightness,
      required double contrast})? themeUpdater;

  const BMIBarPage({this.themeUpdater, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBar(),
      // Remove AppBar and replace with Header widget
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.blue.shade900],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header widget
              const Header(),

              // Expanded BMI components
              const Expanded(child: BMIAppLayout()),

              // Ensure bottom navigation bar stays fixed at the bottom
              const BottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  void _showThemeOptions(BuildContext context) {
    if (themeUpdater != null) {
      showModalBottomSheet(
          context: context,
          isScrollControlled: false,
          builder: (context) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.5,
              minChildSize: 0.5,
              maxChildSize: 0.8,
              builder: (context, scrollControl) {
                return SingleChildScrollView(
                  controller: scrollControl,
                  child: ThemeSettingsScreen(themeUpdater: themeUpdater!),
                );
              },
            );
          });
    }
  }
}