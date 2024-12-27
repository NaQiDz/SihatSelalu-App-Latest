import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter XAMPP Example',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _usernameController = TextEditingController();
  List<dynamic>? childData; // Store fetched users data
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchUser(String userid) async {
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
            childData = data['data']; // Assign the list of users to userData
            isLoading = false;
          });
        } else {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetch User by Username'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_usernameController.text.isNotEmpty) {
                  fetchUser(_usernameController.text);
                }
              },
              child: const Text('Fetch User'),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : errorMessage != null
                ? Text(errorMessage!, style: const TextStyle(color: Colors.red))
                : childData != null
                ? Expanded(
              child: ListView.builder(
                itemCount: childData!.length,
                itemBuilder: (context, index) {
                  var child = childData![index];
                  return ListTile(
                    title: Text(child['child_fullname'] ?? 'No Name'),
                    subtitle: Text('Age: ${child['child_dateofbirth']}'),
                  );
                },
              ),
            )
                : const SizedBox(), // Empty when no user data or error
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}
