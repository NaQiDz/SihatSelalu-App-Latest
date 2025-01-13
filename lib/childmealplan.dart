import 'package:SihatSelaluApp/bottombar.dart';
import 'package:SihatSelaluApp/header.dart';
import 'package:SihatSelaluApp/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class MealPlan extends StatefulWidget {
  const MealPlan({Key? key}) : super(key: key);

  @override
  _MealPlanState createState() => _MealPlanState();
}

class _MealPlanState extends State<MealPlan> {
  int selectedDayIndex = 0;
  final List<Map<String, dynamic>> weekData = [];
  Map<int, Map<String, List<Map<String, dynamic>>>> mealsByDay = {};
  Map<String, List<Map<String, dynamic>>> selectedMealsByType = {
    "BREAKFAST": [],
    "LUNCH": [],
    "DINNER": []
  };

  @override
  void initState() {
    super.initState();
    generateWeekData();
    fetchMeals(); // Fetch meals for the week from the backend
  }

  void generateWeekData() {
    DateTime today = DateTime.now();
    DateTime startOfWeek = today.subtract(Duration(days: today.weekday % 7));
    List<String> daysOfWeek = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];
    List<Map<String, dynamic>> tempWeekData = [];

    for (int i = 0; i < 7; i++) {
      DateTime day = startOfWeek.add(Duration(days: i));
      tempWeekData.add({
        "day": daysOfWeek[i],
        "date": DateFormat('dd/MM/yyyy').format(day),
        "color": Colors.primaries[i % Colors.primaries.length],
      });
    }

    setState(() {
      weekData.clear();
      weekData.addAll(tempWeekData);
    });
  }

  Future<void> fetchMeals() async {
    await dotenv.load(fileName:'.env');
    String? serverIp;
    serverIp = dotenv.env['ENVIRONMENT']! == 'dev' ? dotenv.env['DB_HOST_EMU']! : dotenv.env['DB_HOST_IP'];
    try {
      final response = await http.get(Uri.parse(
          'http://$serverIp/SihatSelaluAppDatabase/ai_power/meal_recommendation.php'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey('error')) {
          print("Error from API: ${data['error']}");
          return;
        }

        final List<dynamic> mealData = data['meals_by_day'] ?? [];
        final Map<int, Map<String, List<Map<String, dynamic>>>> transformedMeals = {};

        for (int i = 0; i < mealData.length; i++) {
          final dailyMeals = mealData[i];
          transformedMeals[i] = {
            "breakfast": List<Map<String, dynamic>>.from(dailyMeals['Breakfast'] ?? []),
            "lunch": List<Map<String, dynamic>>.from(dailyMeals['Lunch'] ?? []),
            "dinner": List<Map<String, dynamic>>.from(dailyMeals['Dinner'] ?? []),
          };
        }

        setState(() {
          mealsByDay = transformedMeals;
        });
      } else {
        print("Failed to fetch meals. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Network error: $e");
    }
  }

  Future<void> saveSelectedMeals(String date, List<Map<String, dynamic>> selectedMeals) async {
    await dotenv.load(fileName:'.env');
    String? serverIp;
    serverIp = dotenv.env['ENVIRONMENT']! == 'dev' ? dotenv.env['DB_HOST_EMU']! : dotenv.env['DB_HOST_IP'];
    try {
      // Convert the date from dd/MM/yyyy to yyyy-MM-dd format
      DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(date);
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

      // Log the selected meals to debug
      print("Selected meals: $selectedMeals");

      // Ensure all selected meals have food_id
      for (var meal in selectedMeals) {
        if (!meal.containsKey('food_id')) {
          print("Error: Meal does not contain food_id: $meal");
        }
      }

      final response = await http.post(
        Uri.parse('http://$serverIp/SihatSelaluAppDatabase/ai_power/save_meals.php'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "date": formattedDate, // Pass the formatted date
          "child_id": 1, // Replace with dynamic child_id if needed
          "meals": selectedMeals.map((meal) {
            return {
              "food_id": meal['food_id'], // Ensure we pass the food_id
            };
          }).toList(),
        }),
      );

      // Log response for debugging
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          print("Meals saved successfully.");
        } else {
          print("Error saving meals: ${data['error']}");
        }
      } else {
        print("Failed to save meals. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Network error while saving meals: $e");
    }
  }


  String get todayDate {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blue.shade900,
        drawer: const SideBar(), // Add the drawer
        body: Stack(
          children: [
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
                      const Header(), // Add Header from the first method
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
                              // back button navigation logic here
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Center(
                        child: Text(
                          "Today, $todayDate",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      // Week navigation bar (days)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(7, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedDayIndex = index;
                                  selectedMealsByType = {
                                    "BREAKFAST": [],
                                    "LUNCH": [],
                                    "DINNER": []
                                  };
                                });
                              },
                              child: CircleAvatar(
                                radius: screenWidth * 0.06,
                                backgroundColor: selectedDayIndex == index
                                    ? weekData[index]['color']
                                    : Colors.grey[700],
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      weekData[index]['day'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.03,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      weekData[index]['date'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.02,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      // Meal Items
                      MealItem(
                        mealType: "BREAKFAST",
                        meals: mealsByDay[selectedDayIndex]?['breakfast'] ?? [],
                        size: size,
                        onTap: (meals) => _showFoodSelectionDialog(meals, "BREAKFAST"),
                        selectedMeals: selectedMealsByType["BREAKFAST"]!,
                      ),
                      MealItem(
                        mealType: "LUNCH",
                        meals: mealsByDay[selectedDayIndex]?['lunch'] ?? [],
                        size: size,
                        onTap: (meals) => _showFoodSelectionDialog(meals, "LUNCH"),
                        selectedMeals: selectedMealsByType["LUNCH"]!,
                      ),
                      MealItem(
                        mealType: "DINNER",
                        meals: mealsByDay[selectedDayIndex]?['dinner'] ?? [],
                        size: size,
                        onTap: (meals) => _showFoodSelectionDialog(meals, "DINNER"),
                        selectedMeals: selectedMealsByType["DINNER"]!,
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            final selectedMeals = [
                              ...selectedMealsByType["BREAKFAST"]!,
                              ...selectedMealsByType["LUNCH"]!,
                              ...selectedMealsByType["DINNER"]!,
                            ];
                            saveSelectedMeals(
                                weekData[selectedDayIndex]['date'],
                                selectedMeals
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlueAccent,
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2, vertical: screenWidth * 0.05),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Save Meals",
                            style: TextStyle(fontSize: screenWidth * 0.05),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.15), // Space for BottomBar
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: const BottomBar(), // BottomBar from the first method
            ),
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }


  Future<void> _showFoodSelectionDialog(
      List<Map<String, dynamic>> meals, String mealType) async {
    List<Map<String, dynamic>> selectedMeals = List.from(selectedMealsByType[mealType]!);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select $mealType"),
          content: SingleChildScrollView(
            child: Column(
              children: meals.map((meal) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    bool isSelected = selectedMeals.contains(meal);
                    return CheckboxListTile(
                      title: Text(meal['food_name']),
                      subtitle: Text(
                          '${meal['food_calories_100g']} kcal, ${meal['serving_size']} g serving'),
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedMeals.add(meal);
                          } else {
                            selectedMeals.remove(meal);
                          }
                        });
                      },
                    );
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  selectedMealsByType[mealType] = selectedMeals;
                });
                Navigator.of(context).pop();
              },
              child: Text("Done"),
            ),
          ],
        );
      },
    );
  }
}

class MealItem extends StatelessWidget {
  final String mealType;
  final List<Map<String, dynamic>> meals;
  final Size size;
  final Function(List<Map<String, dynamic>>) onTap;
  final List<Map<String, dynamic>> selectedMeals;

  const MealItem({
    Key? key,
    required this.mealType,
    required this.meals,
    required this.size,
    required this.onTap,
    required this.selectedMeals,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: size.width * 0.03),
      margin: EdgeInsets.only(bottom: size.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              mealType == "BREAKFAST"
                  ? Icons.breakfast_dining
                  : mealType == "LUNCH"
                  ? Icons.lunch_dining
                  : Icons.dinner_dining,
              size: size.width * 0.1,
              color: Colors.white,
            ),
            title: Text(
              mealType,
              style: TextStyle(
                color: Colors.white,
                fontSize: size.width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (selectedMeals.isNotEmpty)
            ...selectedMeals.map((meal) {
              return ListTile(
                title: Text(
                  meal['food_name'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.width * 0.04,
                  ),
                ),
                subtitle: Text(
                  '${meal['food_calories_100g']} kcal, ${meal['serving_size']} g serving',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: size.width * 0.03,
                  ),
                ),
              );
            }).toList(),
          if (selectedMeals.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "No meals selected yet",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: size.width * 0.04,
                ),
              ),
            ),
          if (meals.isNotEmpty)
            TextButton(
              onPressed: () => onTap(meals),
              child: Text(
                "Select $mealType",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: size.width * 0.04,
                ),
              ),
            ),
        ],
      ),
    );
  }
}