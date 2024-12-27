import 'package:SihatSelaluApp/bottombar.dart';
import 'package:SihatSelaluApp/header.dart';
import 'package:SihatSelaluApp/iotsection.dart';
import 'package:SihatSelaluApp/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:SihatSelaluApp/session_manager.dart';



class childchoosePage extends StatelessWidget {
  const childchoosePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChildrenChoosePage(),
    );
  }
}

class ChildrenChoosePage extends StatefulWidget {
  const ChildrenChoosePage({super.key});

  @override
  _ChooseChildrenPageState createState() => _ChooseChildrenPageState();
}

class _ChooseChildrenPageState extends State<ChildrenChoosePage> {
  _ChooseChildrenPageState();
  String? username = SessionManager.username; // Hardcoded username
  String? userid = SessionManager.userid; // Hardcoded username
  bool isLoading = true;
  String? errorMessage;
  List<dynamic>? childData;

  @override
  void initState() {
    super.initState();
    fetchChild();// Fetch data automatically on app start
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const SideBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.blue.shade900],
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      const Header(),
                      const SizedBox(height: 20),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Choose Your Child',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.grey.shade300,
                              child: Icon(
                                Icons.scale,
                                size: 50,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      _buildChildList(), // Extracted list logic
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildRecentlyUsedSection(context),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }

  /// Handles child list rendering
  Widget _buildChildList() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Add retry logic
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (childData == null) {
      return const SizedBox(); // Empty state
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5, // Adjust height dynamically
      child: ListView.builder(
        itemCount: childData!.length,
        itemBuilder: (context, index) {
          var child = childData![index];
          int age = calculateAge(child['child_dateofbirth']); // Calculate age

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => IOTPage()), // Replace with your actual ProfilePage
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.005, // Adjust vertical margin
                horizontal: MediaQuery.of(context).size.width * 0.03, // Adjust horizontal margin
              ),
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.00001, // Adjust vertical padding
                horizontal: MediaQuery.of(context).size.width * 0.04, // Adjust horizontal padding
              ),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                leading: Text(
                  '${index + 1}.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.035, // Dynamic font size
                  ),
                ),
                title: Text(
                  child['child_fullname'] ?? 'No Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.035, // Dynamic font size
                  ),
                ),
                trailing: Text(
                  'Age: $age',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.035, // Dynamic font size
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }




  Widget _buildRecentlyUsedSection(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipPath(
        clipper: ProsteBezierCurve(
          position: ClipPosition.top,
          list: [
            BezierCurveSection(
              start: const Offset(0, 72),
              top: const Offset(90, 20),
              end: const Offset(0, 70),
            ),
          ],
        ),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(top: 45, bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E2E7D),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Text(
                  'Recently used',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              _buildRecentlyUsedItem('1. Child name', '34 Kg', '123 Cm'),
              const SizedBox(height: 10),
              _buildRecentlyUsedItem('2. Child name', '34 Kg', '123 Cm'),
              const SizedBox(height: 10),
              _buildRecentlyUsedItem('3. Child name', '34 Kg', '123 Cm'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentlyUsedItem(String name, String weight, String height) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(color: Colors.black, fontSize: 14)),
          Text(weight, style: const TextStyle(color: Colors.black, fontSize: 14)),
          Text(height, style: const TextStyle(color: Colors.black, fontSize: 14)),
        ],
      ),
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
