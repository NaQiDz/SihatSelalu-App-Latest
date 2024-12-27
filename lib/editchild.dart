import 'package:SihatSelaluApp/bottombar.dart';
import 'package:SihatSelaluApp/childpage.dart';
import 'package:SihatSelaluApp/header.dart';
import 'package:SihatSelaluApp/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditChildInformationScreen extends StatefulWidget {
  final int childId; // You will need to pass this child ID to identify which child to update
  const EditChildInformationScreen({super.key, required this.childId});

  @override
  _EditChildInformationScreenState createState() => _EditChildInformationScreenState();
}

class _EditChildInformationScreenState extends State<EditChildInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchChildData();  // Fetch existing data to display on the screen
  }

  void _fetchChildData() async {
    // Fetch the data from the server using the childId
    final url = Uri.parse('http://172.20.10.3/SihatSelaluAppDatabase/managechild.php');
    final response = await http.post(url, body: {'childid': widget.childId.toString()});
    userData = null;

    if (response.statusCode == 200) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Child Data : $userData');
      final data = jsonDecode(response.body);
      if (data is Map<String, dynamic> && data['error'] == null) {
        // Populate the controllers with the fetched data
        setState(() {
          userData = data;
          nameController.text = userData?['child_username'];
          fullnameController.text = userData?['child_fullname'];
          ageController.text = userData?['child_dateofbirth'];
          genderController.text = userData?['child_gender'];
          birthdayController.text = userData?['child_dateofbirth'];
          widthController.text = userData?['child_current_weight'];
          heightController.text = userData?['child_current_height'];
        });
      } else {
        _showResultDialog(context, 'Error', 'Failed to fetch child data');
      }
    } else {
      _showResultDialog(context, 'Error', 'Server error: ${response.statusCode}');
    }
  }

  void _updateChild() async {
    // Prepare the data for sending to the server
    Map<String, String> updatedData = {};

    if (nameController.text.isNotEmpty) updatedData['name'] = nameController.text;
    if (fullnameController.text.isNotEmpty) updatedData['fullname'] = fullnameController.text;
    if (genderController.text.isNotEmpty) updatedData['gender'] = genderController.text;
    if (birthdayController.text.isNotEmpty) updatedData['birthday'] = birthdayController.text;

    updatedData['child_id'] = widget.childId.toString();  // Include child_id to identify which child to update

    final url = Uri.parse('http://172.20.10.3/SihatSelaluAppDatabase/update_child.php');

    final response = await http.post(url, body: updatedData);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        _showResultDialog(context, 'Success', 'Child information updated successfully!');
        _fetchChildData();
      } else {
        _showResultDialog(context, 'Failure', 'Failed to update child: ${data['message']}');
      }
    } else {
      _showResultDialog(context, 'Error', 'Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.blue.shade900,
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
                    builder: (context) => IconButton(
                      icon: Icon(
                        FontAwesomeIcons.arrowLeft,
                        color: Colors.white,
                        size: 14,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChildPage()),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.00),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Edit Your Child',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenHeight * 0.025,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Information',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenHeight * 0.025,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 1,
                        indent: screenWidth * 0.25,
                        endIndent: screenWidth * 0.25,
                      ),
                      SizedBox(height: 40),
                      _buildTextField(nameController, 'Nick Name', true),
                      SizedBox(height: 16),
                      _buildTextField(fullnameController, 'Full Name', true),
                      SizedBox(height: 16),
                      _buildGenderDropdown(genderController, 'Gender', true),
                      SizedBox(height: 16),
                      _buildDatePicker(birthdayController, 'Birthday Date', true),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _updateChild,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                            horizontal: screenWidth * 0.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontSize: screenHeight * 0.015,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, bool isFilled) {
    return SizedBox(
      width: 280,
      height: 50,
      child: TextField(
        controller: controller,
        enabled: isFilled,  // Disable input when isFilled is false
        decoration: InputDecoration(
          labelText: hint,
          labelStyle: TextStyle(color: Colors.grey[300], fontSize: 12),
          filled: isFilled,
          fillColor: Colors.grey.withOpacity(0.2),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(color: Colors.grey[300], fontSize: 12),
      ),
    );
  }

  Widget _buildGenderDropdown(TextEditingController controller, String hint, bool isFilled) {
    return SizedBox(
      width: 280,
      height: 50,
      child: DropdownButtonFormField<String>(
        value: controller.text.isEmpty ? null : controller.text, // Set initial value
        onChanged: isFilled ? (String? newValue) {
          controller.text = newValue!;
        } : null, // Only allow selection if isFilled is true
        decoration: InputDecoration(
          labelText: hint,
          labelStyle: TextStyle(color: Colors.grey[300], fontSize: 12),
          filled: isFilled,
          fillColor: Colors.grey.withOpacity(0.2),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(color: Colors.grey[300], fontSize: 12),
        items: ['Male', 'Female'].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDatePicker(TextEditingController controller, String hint, bool isFilled) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Adjust the padding as needed
      child: SizedBox(
        width: 280,
        height: 50,
        child: TextField(
          controller: controller,
          enabled: isFilled, // Disable input if isFilled is false
          readOnly: true, // Make the TextField read-only to open the calendar on tap
          onTap: isFilled ? () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (selectedDate != null) {
              controller.text = "${selectedDate.toLocal()}".split(' ')[0]; // Set the date in text format
            }
          } : null, // Only allow selecting the date if isFilled is true
          decoration: InputDecoration(
            labelText: hint,
            labelStyle: TextStyle(color: Colors.grey[300], fontSize: 12),
            filled: isFilled,
            fillColor: Colors.grey.withOpacity(0.2),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            suffixIcon: isFilled
                ? IconButton(
              icon: Icon(
                FontAwesomeIcons.calendar, // FontAwesome calendar icon
                color: Colors.grey[500],
                size: 20,
              ),
              onPressed: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (selectedDate != null) {
                  controller.text = "${selectedDate.toLocal()}".split(' ')[0];
                }
              },
            )
                : null, // Only show the calendar icon if isFilled is true
          ),
          style: TextStyle(color: Colors.grey[300], fontSize: 12),
        ),
      ),
    );
  }

  void _showResultDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
