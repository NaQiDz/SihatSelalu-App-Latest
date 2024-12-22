import 'package:SihatSelaluApp/bottombar.dart';
import 'package:SihatSelaluApp/editchild.dart';
import 'package:SihatSelaluApp/header.dart';
import 'package:SihatSelaluApp/infochild.dart';
import 'package:SihatSelaluApp/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'accountpage.dart';

class ChildPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChildrenPage(),
    );
  }
}

class ChildrenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      // Make Scaffold background transparent
      drawer: const SideBar(),
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
                    builder: (context) =>
                        IconButton(
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
                Center(
                  child: Text(
                    'Manage Children',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenHeight * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                Row(
                  children: [
                    CircleAvatar(
                      radius: screenHeight * 0.06,
                      backgroundColor: Colors.grey,
                      child: Text('Image'),
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'YOUR NAME',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Age',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Gender',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Parent',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                Divider(color: Colors.grey),
                SizedBox(height: screenHeight * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // Center them horizontally
                  children: [
                    Container(
                      padding: EdgeInsets.all(0),
                      // Adjust padding to control circle size
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors
                            .blue, // Change the background color of the circle
                      ),
                      child: IconButton(
                        icon: Icon(Icons.add, color: Colors.white),
                        onPressed: () {
                          _showAddChildDialog(context);
                        },
                        iconSize: 30, // Adjust icon size as needed
                      ),
                    ),
                    SizedBox(width: 8), // Spacing between the icon and the text
                    Text(
                      'Add Child',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Column(
                  children: [
                    ChildItem(),
                    ChildItem(),
                    ChildItem(),
                    ChildItem(),
                    ChildItem(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }

  // Function to show Add Child Dialog
  void _showAddChildDialog(BuildContext context) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final genderController = TextEditingController();
    final birthdateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: EdgeInsets.all(20),
          // Adjust title padding
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          // Adjust content padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Rounded corners
          ),
          backgroundColor: Colors.black.withOpacity(0.6),
          // Set dialog background color
          title: Center(
            child: Text(
              'Add Child',
              style: TextStyle(fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white), // Adjust title font size
            ),
          ),
          content: Container(
            width: 600, // Adjust dialog width
            height: 240, // Adjust dialog height
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    style: TextStyle(color: Colors.white),
                    // Text color for the input
                    decoration: InputDecoration(
                      labelText: 'Child Name',
                      labelStyle: TextStyle(color: Colors.white), // Label color
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors
                            .white), // Border color when focused
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors
                            .white), // Border color when enabled
                      ),
                    ),
                  ),
                  TextField(
                    controller: ageController,
                    style: TextStyle(color: Colors.white),
                    // Text color for the input
                    decoration: InputDecoration(
                      labelText: 'Child Age',
                      // Add a label
                      labelStyle: TextStyle(color: Colors.white),
                      // Label text color
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors
                            .white), // Border color when focused
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors
                            .white), // Border color when enabled
                      ),
                    ),
                    keyboardType: TextInputType.number, // Ensures numeric input
                  ),
                  TextField(
                    controller: genderController,
                    style: TextStyle(color: Colors.white),
                    // Text color for the input
                    decoration: InputDecoration(
                      labelText: 'Child Gender',
                      labelStyle: TextStyle(color: Colors.white), // Label color
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors
                            .white), // Border color when focused
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors
                            .white), // Border color when enabled
                      ),
                    ),
                  ),
                  TextField(
                    controller: birthdateController,
                    readOnly: true,
                    // Prevents manual editing
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        // Default date
                        firstDate: DateTime(1900),
                        // Earliest selectable date
                        lastDate: DateTime.now(),
                        // Latest selectable date
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.dark(), // Customize theme if needed
                            child: child!,
                          );
                        },
                      );

                      if (pickedDate != null) {
                        birthdateController.text =
                        "${pickedDate.month}/${pickedDate.day}/${pickedDate
                            .year}";
                      }
                    },
                    style: TextStyle(color: Colors.white),
                    // Input text color
                    decoration: InputDecoration(
                      labelText: 'Child Birthday Date',
                      labelStyle: TextStyle(color: Colors.white),
                      // Label text color
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors
                            .white), // Border color when focused
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors
                            .white), // Border color when enabled
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, // Sets the text color to white
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Makes the text bold
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // You can save the child information here
                String name = nameController.text;
                String age = ageController.text;
                print('Child Added: $name, $age');
                Navigator.of(context).pop(); // Close the dialog
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, // Sets the text color to white
              ),
              child: Text(
                'Add',
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Makes the text bold
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ChildItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to ProfilePage when the entire box is tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InfoChild()), // Replace with your actual ProfilePage
        );
      },
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(width: 5),
              Text(
                'Child name',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Age',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(width: 2), // Space between the buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditChild()
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: CircleBorder(), // Makes the button circular
                  minimumSize: Size(50, 50), // Ensure the button size is consistent (adjust as needed)
                ),
                child: Icon(Icons.edit, size: 20), // Icon size can be adjusted
              ),
              SizedBox(width: 0), // Space between the buttons
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: CircleBorder(), // Makes the button circular
                  minimumSize: Size(50, 50), // Ensure the button size is consistent (adjust as needed)
                ),
                child: Icon(Icons.delete, size: 20), // Icon size can be adjusted
              ),
            ],
          )
        ],
      ),
    ),
    );
  }
}
