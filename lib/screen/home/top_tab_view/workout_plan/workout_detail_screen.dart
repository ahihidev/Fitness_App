import 'package:flutter/material.dart';
import 'package:specialized_project_2/common/color_extension.dart';
import 'package:specialized_project_2/common_widget/number_title_subtitle_button.dart';
import 'package:specialized_project_2/screen/home/top_tab_view/workout_plan/week_detail_screen.dart';
import 'package:specialized_project_2/screen/home/top_tab_view/workout_plan/workout_introductions_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WorkoutDetailScreen extends StatefulWidget {
  final String workoutId;

  const WorkoutDetailScreen({super.key, required this.workoutId});

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  late Map<String, dynamic> workoutData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWorkoutData();
  }

  // Fetch workout data from API
  Future<void> _fetchWorkoutData() async {
    final response = await http.get(Uri.parse('http://192.168.1.8:40001/workout/${widget.workoutId}'));

    if (response.statusCode == 200) {
      setState(() {
        workoutData = json.decode(response.body)['data'];
        isLoading = false;
      });
    } else {
      // Handle error
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: TColor.secondary,
          title: const Text("Loading..."),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

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
        title: Text(
          workoutData["title"] ?? "Workout Plan",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Image.network(
                    workoutData["image"] ?? "https://via.placeholder.com/150",
                    width: double.maxFinite,
                    height: context.width * 0.5,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: TColor.primary,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Goal",
                                style: TextStyle(color: TColor.primaryText, fontSize: 12),
                              ),
                              Text(
                                workoutData["goal"] ?? "Unknown",
                                style: TextStyle(color: TColor.primaryText, fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Duration",
                                style: TextStyle(color: TColor.primaryText, fontSize: 12),
                              ),
                              Text(
                                "${workoutData["totalDayOfPlan"] ?? 0} Days",
                                style: TextStyle(color: TColor.primaryText, fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Level",
                                style: TextStyle(color: TColor.primaryText, fontSize: 12),
                              ),
                              Text(
                                workoutData["difficulty"] ?? "Unknown",
                                style: TextStyle(color: TColor.primaryText, fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  context.push(const WorkoutIntroductionScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Introduction",
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Image.asset("assets/img/next.png", width: 15, height: 15)
                  ],
                ),
              ),
              Text(
                workoutData["description"] ?? "No description available.",
                style: TextStyle(color: TColor.primaryText, fontSize: 13),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        height: 8,
                        width: context.width - 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: TColor.secondaryText.withOpacity(0.15),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 8,
                          width: (context.width - 40) * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "30% Complete",
                      style: TextStyle(color: TColor.primaryText, fontSize: 10),
                    ),
                  ],
                ),
              ),
              // Pass workoutData['weeklySchedule'] to the WeekDetailsScreen
              ...workoutData['weeklySchedule'].map<Widget>((week) {
                return NumberTitleSubtitleButton(
                  title: week["title"],
                  subtitle: "This is a beginner quick start.....",
                  number: week["day"].toString(),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WeekDetailsScreen(weeklySchedule: List<Map<String, dynamic>>.from(week['exercises']),),
                      ),
                    );
                  },
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
