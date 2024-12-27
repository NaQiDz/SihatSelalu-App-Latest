import 'package:SihatSelaluApp/bottombar.dart';
import 'package:SihatSelaluApp/editchild.dart';
import 'package:SihatSelaluApp/header.dart';
import 'package:SihatSelaluApp/infochild.dart';
import 'package:SihatSelaluApp/session_manager.dart';
import 'package:SihatSelaluApp/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'accountpage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChildPage extends StatelessWidget {
  const ChildPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChildrenPage(),
    );
  }
}

class ChildrenPage extends StatefulWidget {
  const ChildrenPage({super.key});

  @override
  _ChildrenPageState createState() => _ChildrenPageState();
}

class _ChildrenPageState extends State<ChildrenPage> {
  String? username = SessionManager.username; // Hardcoded username
  String? userid = SessionManager.userid; // Hardcoded username
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? errorMessage;
  List<dynamic>? childData;

  @override
  void initState() {
    super.initState();
    fetchUser();
    fetchChild();// Fetch data automatically on app start
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

  Future<void> fetchChild() async {
    if (userid == null) {
      setState(() {
        errorMessage = 'User ID is not available.';
        isLoading = false;
      });
      return;
    }
    setState(() {
      isLoading = true;
      errorMessage = null; // Clear previous error
      childData = null; // Clear previous users data
    });

    try {
      final response = await http.post(
        Uri.parse('http://172.20.10.3/SihatSelaluAppDatabase/try.php'), // Replace with your URL
        body: {'userid': userid},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            childData = data['datachild'];
            isLoading = false;
          });
          print('Child Data : $childData');
          // Show success message
          /*ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Data loaded successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3), // Adjust duration as needed
            ),
          );*/
        }
        else {
          setState(() {
            errorMessage = data['message'] ?? 'An error occurred';
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
                    if (userData?['Icon'] == null)
                      CircleAvatar(
                        radius: screenHeight * 0.06,
                        backgroundImage: NetworkImage('http://172.20.10.3/SihatSelaluAppDatabase/images/defaultprofile.png'), // Use user image or default
                      ),
                    if (userData?['Icon'] != null)
                      CircleAvatar(
                        radius: screenHeight * 0.06,
                        backgroundImage: NetworkImage('http://172.20.10.3/SihatSelaluAppDatabase/' + userData?['Icon']), // Use user image or default
                      ),
                    SizedBox(width: screenWidth * 0.04),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (userData?['Username']?.toString() ?? 'loading..'),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Age      : ${userData?['Age']?.toString() ?? 'loading..'} Years',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Gender : ${userData?['Gender']?.toString() ?? 'loading..'}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Role     : Parent',
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
                Column(
                  children: [
                    const SizedBox(height: 20),

                    // Check loading state or errors
                    isLoading
                        ? const CircularProgressIndicator()
                        : errorMessage != null
                        ? Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    )
                        : childData != null
                        ? SizedBox(
                      height: 300, // Provide a fixed height or use MediaQuery for dynamic height
                      child: ListView.builder(
                        itemCount: childData!.length,
                        itemBuilder: (context, index) {
                          var child = childData![index];
                          int age = calculateAge(child['child_dateofbirth']); // Calculate age
                          return GestureDetector(
                            onTap: () {
                              // Navigate to InfoChild page when the entire box is tapped
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InfoChildPage(
                                    childId: child['child_id'],
                                  ),
                                ),
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
                                        child['child_fullname'] ?? 'No Name',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Age: $age', // Display the calculated age
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(width: 2), // Space between the buttons
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditChildInformationScreen(
                                                  childId: child['child_id'],
                                              ),
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
                                        onPressed: () {
                                          String childId = '123'; // Replace with actual child_id you want to delete
                                          _deleteChild(context, child['child_id'].toString());
                                          print('child id: ${child['child_id'].toString()}');
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          shape: CircleBorder(),
                                          minimumSize: Size(50, 50),
                                        ),
                                        child: Icon(Icons.delete, size: 20),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                        : const SizedBox(), // Empty when no user data or error
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

  void _deleteChild(BuildContext context, String childId) async {
    // Confirm deletion with a dialog
    bool confirm = await _showConfirmationDialog(context) ?? false;

    if (confirm) {
      final url = Uri.parse('http://172.20.10.3/SihatSelaluAppDatabase/delete_child.php');

      final response = await http.post(
        url,
        body: {'child_id': childId}, // Sending child_id to delete
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          _showResultDialog(context, 'Success', 'Child deleted successfully!');
          fetchChild();
        } else {
          _showResultDialog(context, 'Failure', 'Failed to delete child: ${data['message']}');
        }
      } else {
        _showResultDialog(context, 'Error', 'Error: ${response.statusCode}');
      }
    }
  }

  Future<bool?> _showConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // Prevents dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text('Are you sure you want to delete this child?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User chose not to delete
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed deletion
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    ) ?? false; // Return false if dialog is dismissed
  }


  void _addChild(BuildContext context, String name, String fullname, String gender, String birthdate) async {
    final url = Uri.parse('http://172.20.10.3/SihatSelaluAppDatabase/add_child.php');

    final response = await http.post(
      url,
      body: {
        'name': name,
        'fullname': fullname,
        'gender': gender,
        'birthdate': birthdate,
        'parentid': userid,
      },
    );
    print('parentid $userid');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        _showResultDialog(context, 'Success', 'Child added successfully!');
        fetchChild();
      } else {
        _showResultDialog(context, 'Failure', 'Failed to add child: ${data['message']}');
      }
    } else {
      _showResultDialog(context, 'Error', 'Error: ${response.statusCode}');
    }
  }

// Function to show result dialog
  void _showResultDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
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

  // Function to show Add Child Dialog
  void _showAddChildDialog(BuildContext context) {
    final nameController = TextEditingController();
    final fullnameController = TextEditingController();
    final genderController = TextEditingController();
    final birthdateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: EdgeInsets.all(25),
          // Adjust title padding
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          // Adjust content padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25), // Rounded corners
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
          content: SizedBox(
            width: 600, // Adjust dialog width
            height: 240, // Adjust dialog height
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                    // Text color for the input
                    decoration: InputDecoration(
                      labelText: 'Child Nick Name',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 12), // Label color
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white), // Border color when focused
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white), // Border color when enabled
                      ),
                    ),
                  ),
                  TextField(
                    controller: fullnameController,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                    // Text color for the input
                    decoration: InputDecoration(
                      labelText: 'Child Fullname',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 12), // Label color
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white), // Border color when focused
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white), // Border color when enabled
                      ),
                    ),
                  ),
              DropdownButtonFormField<String>(
                value: genderController.text.isNotEmpty ? genderController.text : null,
                onChanged: (value) {
                  genderController.text = value ?? ''; // Update the text controller with the selected value
                },
                style: TextStyle(color: Colors.white, fontSize: 12), // Text color for the dropdown items
                decoration: InputDecoration(
                  labelText: 'Child Gender',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 12), // Label color
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // Border color when focused
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // Border color when enabled
                  ),
                ),
                dropdownColor: Colors.blueGrey, // Background color for dropdown menu
                items: [
                  DropdownMenuItem(
                    value: 'Male',
                    child: Text('Male', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                  DropdownMenuItem(
                    value: 'Female',
                    child: Text('Female', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ],
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
                        "${pickedDate.month}/${pickedDate.day}/${pickedDate.year}";
                      }
                    },
                    style: TextStyle(color: Colors.white, fontSize: 12),
                    // Input text color
                    decoration: InputDecoration(
                      labelText: 'Child Birthday Date',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 12),
                      // Label text color
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white), // Border color when focused
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white), // Border color when enabled
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
                final name = nameController.text;
                final fullname = fullnameController.text;
                final gender = genderController.text;
                final birthdate = birthdateController.text;

                _addChild(context, name, fullname, gender, birthdate);
                Navigator.of(context).pop();
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
            TextButton(
              onPressed: () {
                // You can save the child information here
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
          ],
        );
      },
    );
  }
}

int calculateAge(String birthDateString) {
  // Parse the input string into a DateTime object
  DateTime birthDate = DateTime.parse(birthDateString);
  DateTime today = DateTime.now();

  // Calculate the difference in years
  int age = today.year - birthDate.year;

  // Check if the birthday has not occurred yet this year
  if (today.month < birthDate.month ||
      (today.month == birthDate.month && today.day < birthDate.day)) {
    age--;
  }

  return age;
}

