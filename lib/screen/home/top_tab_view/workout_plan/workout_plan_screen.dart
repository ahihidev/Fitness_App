import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:specialized_project_2/common/color_extension.dart';
import 'package:specialized_project_2/common_widget/icon_title_subtitle_button.dart';
import 'package:specialized_project_2/common_widget/round_button.dart';
import 'package:specialized_project_2/screen/home/top_tab_view/workout_plan/create_add_plan_screen.dart';
import 'package:specialized_project_2/screen/home/top_tab_view/workout_plan/find_workout_plan_screen.dart';
import 'package:specialized_project_2/screen/home/top_tab_view/workout_plan/workout_detail_screen.dart';

class WorkoutPlanScreen extends StatefulWidget {
  const WorkoutPlanScreen({super.key});

  @override
  State<WorkoutPlanScreen> createState() => _WorkoutPlanScreenState();
}

class _WorkoutPlanScreenState extends State<WorkoutPlanScreen> {
  List muscleArr = [];
  List gainArr = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWorkoutData();
  }

  Future<void> fetchWorkoutData() async {
    final url = 'http://192.168.1.8:40001/workout';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List;
        setState(() {
          muscleArr =
              data.where((item) => item['difficulty'] == 'BEGINNER').toList();
          gainArr =
              data.where((item) => item['difficulty'] == 'MEDIUM').toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load workout data');
      }
    } catch (e) {
      print("Error fetching workout data: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Combine muscleArr and gainArr into one list
    List combinedArr = [...muscleArr, ...gainArr];

    return Scaffold(
      resizeToAvoidBottomInset: false,  // Ensure the layout does not resize when keyboard appears
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(  // Wrap the entire body in SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Find a Workout Plan Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: IconTitleSubtitleButton(
                  title: "Find a Workout Plan",
                  subtitle: "Perfect Workout plan that fulfills your fitness goal",
                  icon: "assets/img/search_circle.png",
                  onPressed: () {
                    context.push(const FindWorkoutPlanScreen());
                  },
                ),
              ),

              // My Plan Button Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: RoundButton(
                  title: "My Plan",
                  onPressed: () {}, // Keep "My Plan" button
                ),
              ),

              // Header for workout list
              if (combinedArr.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Recommended Plans",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: TColor.primary,
                    ),
                  ),
                ),

              // Combined Muscle & Gain Plans
              if (combinedArr.isNotEmpty)
                SizedBox(
                  height: context.height * 0.4,  // Dynamically calculate height
                  child: ListView.separated(
                    shrinkWrap: true,  // Allow ListView to take only necessary space
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    itemBuilder: (context, index) {
                      var obj = combinedArr[index] as Map? ?? {};
                      String titleWithDifficulty =
                          "${obj["title"]} (${obj["difficulty"]})";

                      return InkWell(
                        onTap: () {
                          context.push(WorkoutDetailScreen(
                            workoutId: obj["_id"],
                          ));
                        },
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Workout image
                                Image.network(
                                  obj["image"] ?? '',
                                  width: context.width * 0.6,
                                  height: context.width * 0.3,
                                  fit: BoxFit.cover,
                                ),
                                // Workout title and difficulty
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    titleWithDifficulty,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: TColor.primary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                    const SizedBox(width: 20),
                    itemCount: combinedArr.length,
                  ),
                ),
              const SizedBox(height: 20),  // Add space at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
