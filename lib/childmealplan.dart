import 'package:SihatSelaluApp/choosechildmealplan.dart';
import 'package:SihatSelaluApp/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:SihatSelaluApp/bottombar.dart';
import 'package:SihatSelaluApp/header.dart';
import 'package:SihatSelaluApp/sidebar.dart';

class MealPlan extends StatefulWidget {
  final int childId;
  const MealPlan({super.key, required this.childId});

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
    fetchMeals();
  }

  void generateWeekData() {
    DateTime today = DateTime.now();
    DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1)); // Start from Monday
    List<String> daysOfWeek = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"];
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
      selectedDayIndex = today.weekday - 1; // Highlight today initially
    });

    // Fetch saved meals for today initially
    fetchSavedMeals(weekData[selectedDayIndex]['date']);
  }

  Future<void> fetchMeals() async {
    await dotenv.load(fileName: '.env');
    String? serverIp = dotenv.env['ENVIRONMENT'] == 'dev'
        ? dotenv.env['DB_HOST_EMU']
        : dotenv.env['DB_HOST_IP'];
    try {
      final url = Uri.parse('http://$serverIp/SihatSelaluAppDatabase/ai_power/meal_recommendation.php');
      final response = await http.post(url, body: {'childid': widget.childId.toString()});
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey('meals_by_day')) {
          print("Fetched meals data: $data");
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
    await dotenv.load(fileName: '.env');
    String? serverIp = dotenv.env['ENVIRONMENT'] == 'dev'
        ? dotenv.env['DB_HOST_EMU']
        : dotenv.env['DB_HOST_IP'];
    try {
      DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(date);
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

      print("Selected meals: $selectedMeals");

      for (var meal in selectedMeals) {
        if (!meal.containsKey('food_id')) {
          print("Error: Meal does not contain food_id: $meal");
        }
      }

      final response = await http.post(
        Uri.parse('http://$serverIp/SihatSelaluAppDatabase/ai_power/save_meals.php'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "date": formattedDate,
          "child_id": widget.childId.toString(),
          "meals": selectedMeals.map((meal) {
            return {
              "food_id": meal['food_id'],
            };
          }).toList(),
        }),
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          print("Meals saved successfully.");
        } else {
          print("Error saving meals: ${data['error']}");
          _showErrorDialog(data['error']);
        }
      } else {
        print("Failed to save meals. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Network error while saving meals: $e");
    }
  }

  Future<void> fetchSavedMeals(String date) async {
    await dotenv.load(fileName: '.env');
    String? serverIp = dotenv.env['ENVIRONMENT'] == 'dev'
        ? dotenv.env['DB_HOST_EMU']
        : dotenv.env['DB_HOST_IP'];
    try {
      DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(date);
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

      final response = await http.get(
        Uri.parse(
            'http://$serverIp/SihatSelaluAppDatabase/ai_power/get_saved_meals.php?child_id=${widget.childId.toString()}&date=$formattedDate'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey('error')) {
          print("Error from API: ${data['error']}");
          return;
        }

        final savedMeals = data['meals'] ?? {};
        setState(() {
          selectedMealsByType = {
            "BREAKFAST": List<Map<String, dynamic>>.from(savedMeals['breakfast'] ?? []),
            "LUNCH": List<Map<String, dynamic>>.from(savedMeals['lunch'] ?? []),
            "DINNER": List<Map<String, dynamic>>.from(savedMeals['dinner'] ?? []),
          };
        });
      } else {
        print("Failed to fetch saved meals. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Network error while fetching saved meals: $e");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  String get todayDate {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(now);
  }

  bool isToday(int index) {
    DateTime today = DateTime.now();
    DateTime selectedDate = DateFormat('dd/MM/yyyy').parse(weekData[index]['date']);
    return selectedDate.year == today.year &&
        selectedDate.month == today.month &&
        selectedDate.day == today.day;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blue.shade900,
        drawer: const SideBar(),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.lightBlue.shade900],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(size.width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Header(),
                      SizedBox(height: screenHeight * 0.00),
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
                                MaterialPageRoute(builder: (context) => ChooseMealPage()),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.00),
                      Center(
                        child: Text(
                          "Today, $todayDate",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.00),
                      // Week navigation bar (days)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(7, (index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedDayIndex = index;
                                    // Clear the selected meals when day is changed
                                    selectedMealsByType = {
                                      "BREAKFAST": [],
                                      "LUNCH": [],
                                      "DINNER": []
                                    };
                                  });
                                  fetchSavedMeals(weekData[index]['date']);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                  child: CircleAvatar(
                                    radius: size.width * 0.06,
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
                                            fontSize: size.width * 0.04,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          weekData[index]['date'].toString().substring(0, 5),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: size.width * 0.025,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                      // Meal Item - Breakfast
                      MealItem(
                        mealType: "BREAKFAST",
                        meals: mealsByDay[selectedDayIndex]?['breakfast'] ?? [],
                        size: size,
                        onTap: isToday(selectedDayIndex) ? (meals) => _showFoodSelectionDialog(meals, "BREAKFAST") : null,
                        selectedMeals: selectedMealsByType["BREAKFAST"]!,
                      ),

                      // Meal Item - Lunch
                      MealItem(
                        mealType: "LUNCH",
                        meals: mealsByDay[selectedDayIndex]?['lunch'] ?? [],
                        size: size,
                        onTap: isToday(selectedDayIndex) ? (meals) => _showFoodSelectionDialog(meals, "LUNCH") : null,
                        selectedMeals: selectedMealsByType["LUNCH"]!,
                      ),

                      // Meal Item - Dinner
                      MealItem(
                        mealType: "DINNER",
                        meals: mealsByDay[selectedDayIndex]?['dinner'] ?? [],
                        size: size,
                        onTap: isToday(selectedDayIndex) ? (meals) => _showFoodSelectionDialog(meals, "DINNER") : null,
                        selectedMeals: selectedMealsByType["DINNER"]!,
                      ),
                      // Save Meal Button
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: isToday(selectedDayIndex)
                              ? () {
                            final selectedMeals = [
                              ...selectedMealsByType["BREAKFAST"]!,
                              ...selectedMealsByType["LUNCH"]!,
                              ...selectedMealsByType["DINNER"]!,
                            ];
                            saveSelectedMeals(weekData[selectedDayIndex]['date'], selectedMeals);
                          }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isToday(selectedDayIndex) ? Colors.lightBlueAccent : Colors.grey,
                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.2, vertical: size.width * 0.05),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Save Meals",
                            style: TextStyle(fontSize: size.width * 0.05),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.15), // Margin to allow space for BottomBar
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: const BottomBar(),
            ),
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  Future<void> _showFoodSelectionDialog(List<Map<String, dynamic>> meals, String mealType) async {
    List<Map<String, dynamic>> selectedMeals = List.from(selectedMealsByType[mealType]!);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("SELECT $mealType"),
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
  final Function(List<Map<String, dynamic>>)? onTap;
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
                  meal['food_name'] ?? 'No name available',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.width * 0.04,
                  ),
                ),
                subtitle: Text(
                  '${meal['food_calories_100g'] ?? 'N/A'} kcal, ${meal['serving_size'] ?? 'N/A'} g serving',
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
              onPressed: onTap != null ? () => onTap!(meals) : null,
              style: TextButton.styleFrom(
                foregroundColor: onTap != null ? Colors.blueAccent : Colors.grey,
              ),
              child: Text(
                "SELECT $mealType",
                style: TextStyle(
                  fontSize: size.width * 0.04,
                ),
              ),
            ),
        ],
      ),
    );
  }
}