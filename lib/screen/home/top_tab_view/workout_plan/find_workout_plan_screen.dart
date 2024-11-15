import 'package:flutter/material.dart';
import 'package:specialized_project_2/common/color_extension.dart';
import 'package:specialized_project_2/common_widget/round_button.dart';
import 'package:specialized_project_2/common_widget/round_dropdown.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'workout_detail_screen.dart';

class FindWorkoutPlanScreen extends StatefulWidget {
  const FindWorkoutPlanScreen({super.key});

  @override
  State<FindWorkoutPlanScreen> createState() => _FindWorkoutPlanScreenState();
}

class _FindWorkoutPlanScreenState extends State<FindWorkoutPlanScreen> {
  String? selectedGoal;
  String? selectedLevel;

  List<Map<String, String>> goals = [
    {"name": "Tang co", "id": "67355aef308dac0121bb1b6b"},
    {"name": "Build Muscle", "id": "67355aef308dac0121bb1b6b"},
    {"name": "Lose Weight", "id": "67355aef308dac0121bb1b6b"},
    // Add other goal data here
  ];

  List<Map<String, String>> levels = [
    {"name": "Beginner", "id": "BEGINNER"},
    {"name": "Intermediate", "id": "INTERMEDIATE"},
    {"name": "Advanced", "id": "ADVANCED"},
  ];

  // Function to call the API to get workout plans
  Future<void> _findWorkoutPlans() async {
    print("Selected Goal: $selectedGoal"); // Debugging print
    print("Selected Level: $selectedLevel"); // Debugging print

    if (selectedGoal != null && selectedLevel != null) {
      // Use selectedGoal and selectedLevel to make the API call dynamically
      final url =
          'http://192.168.1.8:40001/workout/find?goal=67355aef308dac0121bb1b6b&difficulty=BEGINNER';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        if (data != null && data.isNotEmpty) {
          // Pass the workout ID to the next screen (WorkoutDetailScreen)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkoutDetailScreen(
                workoutId: data[0]["_id"], // Fix: Ensure you're accessing the first item of the list
              ),
            ),
          );
        }
      } else {
        // Handle error (if any)
        print('Failed to load workout plans');
      }
    } else {
      // Show error if goal or level is not selected
      print('Please select both goal and level'); // Debugging print
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both goal and level')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset(
            "assets/img/back.png",
            width: 20,
            height: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: TColor.secondary,
        centerTitle: false,
        title: const Text(
          "Find a Workout Plan",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: RoundDropDown(
                hintText: "Choose Goal",
                list: goals,  // Pass the full map
                didChange: (value) {
                  setState(() {
                    // Ensure the value is properly set for selectedGoal
                    selectedGoal = value["id"];  // Get the 'id' from the map
                    print("Selected Goal: $selectedGoal");  // Debugging print
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: RoundDropDown(
                hintText: "Choose Level",
                list: levels,  // Pass the full map
                didChange: (value) {
                  setState(() {
                    // Ensure the value is properly set for selectedLevel
                    selectedLevel = value["id"];  // Get the 'id' from the map
                    print("Selected Level: $selectedLevel");  // Debugging print
                  });
                },
              ),
            ),
            // Display selected Goal and Level
            if (selectedGoal != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  "Selected Goal: ${goals.firstWhere((goal) => goal["id"] == selectedGoal)["name"]}",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            if (selectedLevel != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  "Selected Level: ${levels.firstWhere((level) => level["id"] == selectedLevel)["name"]}",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: RoundButton(
                title: "Find Workout Plan",
                onPressed: _findWorkoutPlans,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
