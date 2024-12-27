import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:SihatSelaluApp/accountpage.dart';
import 'package:SihatSelaluApp/bottombar.dart';
import 'package:SihatSelaluApp/header.dart';
import 'package:SihatSelaluApp/session_manager.dart';
import 'package:SihatSelaluApp/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http_parser/http_parser.dart';

class Profilepage extends StatelessWidget {
  const Profilepage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? username = SessionManager.username; // Hardcoded username
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchUser(); // Fetch data automatically on app start
  }

  File? _image;
  final picker = ImagePicker();
  String _uploadedImageUrl = "";

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    final uri = Uri.parse("http://172.20.10.3/SihatSelaluAppDatabase/upload.php");
    var request = http.MultipartRequest('POST', uri)
      ..fields['username'] = username!  // The username to identify which user to update
      ..files.add(await http.MultipartFile.fromPath(
          'file', _image!.path, contentType: MediaType('image', 'jpg')
      ));

    var response = await request.send();

    if (response.statusCode == 200) {
      // Decode the server's response
      final responseString = await response.stream.bytesToString();
      final responseJson = json.decode(responseString);

      if (responseJson['status'] == 'success') {
        print("Image uploaded and icon updated successfully!");
        setState(() {
          // Update the image URL if the upload is successful
          _uploadedImageUrl = "http://172.20.10.3/SihatSelaluAppDatabase/" + responseJson['url'];
        });
      } else {
        print("Failed to update icon: ${responseJson['message']}");
      }
    } else {
      print("Failed to upload image");
    }
  }

  Future<void> fetchUser() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      userData = null;
    });

    try {
      final response = await http.post(
        Uri.parse('http://172.20.10.3/SihatSelaluAppDatabase/manageuser.php'), // Replace with your URL
        body: {'username': username}, // Send the hardcoded username
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic> && data['error'] == null) {
          setState(() {
            userData = data;
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = data['error'] ?? data['message'] ?? 'An error occurred';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Request failed with status: ${response.statusCode}.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  // Tracks whether the form fields are editable
  bool isEditable = false;
  bool showEditButton = false; // Track if edit text should be shown
  String? userImageUrl; // URL for user's profile image (can be null)

  @override
  Widget build(BuildContext context) {
    String? username = SessionManager.username;
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
                          MaterialPageRoute(builder: (context) => AccountPage()),
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
                        'Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenHeight * 0.025,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      GestureDetector(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (userData?['Icon'] == null)
                            CircleAvatar(
                              radius: screenHeight * 0.06,
                              backgroundImage: NetworkImage('http://172.20.10.3/SihatSelaluAppDatabase/images/defaultprofile.png'), // Use user image or default
                              backgroundColor: showEditButton ? Colors.white.withOpacity(0.5) : Colors.transparent,
                            ),
                            if (userData?['Icon'] != null)
                            CircleAvatar(
                              radius: screenHeight * 0.06,
                              backgroundImage: NetworkImage('http://172.20.10.3/SihatSelaluAppDatabase/' + userData?['Icon']), // Use user image or default
                              backgroundColor: showEditButton ? Colors.white.withOpacity(0.5) : Colors.transparent,
                            ),
                            if(_uploadedImageUrl.isNotEmpty)
                              CircleAvatar(
                                radius: screenHeight * 0.06,
                                backgroundImage: NetworkImage(_uploadedImageUrl), // Use user image or default
                                backgroundColor: showEditButton ? Colors.white.withOpacity(0.5) : Colors.transparent,
                              ),
                            if (showEditButton)
                              CircleAvatar(
                                radius: screenHeight * 0.06,
                                  backgroundColor: Colors.black.withOpacity(0.8),
                              ),// Show the edit text conditionally
                            if (showEditButton)
                              GestureDetector(
                                onTap: () {
                                  _showUploadImage(context);
                                  print("Edit button pressed");
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  child: Text(
                                    "Edit",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              )
                            else if (!showEditButton) // Show the edit text conditionally
                              GestureDetector(
                                child: Container(
                                  color: Colors.transparent,
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                ),
                              )
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        username!.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      _buildForm(context, screenHeight, screenWidth),
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

  Widget _buildForm(BuildContext context, double screenHeight, double screenWidth) {
    // Check if userData is null
    if (userData == null) {
      return Center(
        child: Text(
          isLoading ? "Loading..." : "Error: $errorMessage",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isEditable = !isEditable; // Toggle editable state
                    showEditButton = isEditable; // Show edit text when form is editable
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.edit,
                      color: Colors.white,
                    ),
                    SizedBox(width: 4),
                    Text(
                      isEditable ? 'Cancel' : 'Edit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildTextField(
            label: userData?['Email'] ?? 'Email not available',
            isEditable: isEditable,
          ),
          SizedBox(height: 10),
          _buildTextField(
            label: userData?['PhoneNum']?.toString() ?? 'Phone number not available',
            isEditable: isEditable,
          ),
          SizedBox(height: 10),
          _buildTextField(
            label: userData?['Age']?.toString() ?? 'Age not available',
            isEditable: isEditable,
          ),
          SizedBox(height: 10),
          _buildTextField(
            label: userData?['Gender'] ?? 'Gender not available',
            isEditable: isEditable,
          ),
          SizedBox(height: screenHeight * 0.04),
          if (isEditable)
            ElevatedButton(
              onPressed: () {
                // Handle save action
              },
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
    );
  }

  Widget _buildTextField({required String label, required bool isEditable}) {
    return SizedBox(
      height: 45,
      child: TextField(
        enabled: isEditable, // Now you can use isEditable directly
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          filled: true,
          fillColor: isEditable
              ? Colors.white.withOpacity(0.2)
              : Colors.grey.withOpacity(0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  void _showUploadImage(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: EdgeInsets.all(20),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.black.withOpacity(0.6),
          title: Center(
            child: Text(
              'Upload Image',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          content: SizedBox(
            width: 600,
            height: 240,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  // Display the image in a circular shape if selected
                  if (_image != null)
                    Center(
                      child: ClipOval(
                        child: Image.file(
                          _image!,
                          width: 100,  // Set width for the circle
                          height: 100, // Set height for the circle
                          fit: BoxFit.cover, // Crop the image to fit inside the circle
                        ),
                      ),
                    ),
                  SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await _pickImage();
                        // Rebuild the widget to update the selected image
                        (context as Element).reassemble();
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      child: Text(
                        _image == null ? "Pick Image" : "Change Image",
                        style: TextStyle(color: Colors.white),
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
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Cancel',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () {
                _uploadImage();
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Upload',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}

class MalaysiaPhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text;

    if (newText.isEmpty) {
      return newValue;
    }

    // Remove non-digit characters
    String digitsOnly = newText.replaceAll(RegExp(r'\D'), '');

    // Add prefix if not present
    if (!digitsOnly.startsWith('60')) {
      digitsOnly = '60$digitsOnly';
    }

    // Format the number
    String formattedNumber = '';
    int digitIndex = 0;
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i == 2) {
        formattedNumber += ' '; // Space after 60
      } else if (i == 5 || i == 8) {
        formattedNumber += '-'; // Hyphens
      }
      formattedNumber += digitsOnly[digitIndex];
      digitIndex++;
    }

    return TextEditingValue(
      text: formattedNumber,
      selection: TextSelection.collapsed(offset: formattedNumber.length),
    );
  }
}