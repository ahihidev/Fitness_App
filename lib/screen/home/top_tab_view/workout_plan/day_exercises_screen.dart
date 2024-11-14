import 'package:flutter/material.dart';
import 'package:specialized_project_2/common/color_extension.dart';
import 'package:specialized_project_2/common_widget/day_exercises_row.dart';
import 'package:specialized_project_2/screen/home/top_tab_view/workout_plan/workout_exercises_screen.dart';

class DayExercisesScreen extends StatefulWidget {
  const DayExercisesScreen({super.key});

  @override
  State<DayExercisesScreen> createState() => _DayExercisesScreenState();
}

class _DayExercisesScreenState extends State<DayExercisesScreen> {
  List listArr = [
    {
      "name": "Bench Press",
      "sets": "3",
      "reps": "12 - 10 - 0",
      "rest": "30 Sec",
      "image": "assets/img/d1.png",
      "is_complete": false,
    },
    {
      "name": "Deadlift",
      "sets": "3",
      "reps": "12 - 10 - 8",
      "rest": "60 Sec",
      "image": "assets/img/d2.jpg",
      "is_complete": true,
    },
    {
      "name": "Squats",
      "sets": "3",
      "reps": "15 - 12 - 10",
      "rest": "45 Sec",
      "image": "assets/img/d3.jpg",
      "is_complete": false,
    },
    {
      "name": "Pull Up",
      "sets": "3",
      "reps": "10 - 8 - 6",
      "rest": "30 Sec",
      "image": "assets/img/d4.jpg",
      "is_complete": false,
    },
    {
      "name": "Overhead Press",
      "sets": "3",
      "reps": "12 - 10 - 8",
      "rest": "30 Sec",
      "image": "assets/img/d5.jpg",
      "is_complete": false,
    },
    {
      "name": "Romanian Deadlift",
      "sets": "4",
      "reps": "12 - 10 - 8 - 6",
      "rest": "45 Sec",
      "image": "assets/img/d6.jpg",
      "is_complete": false,
    },
    {
      "name": "Barbell Row",
      "sets": "4",
      "reps": "10 - 8 - 6 - 4",
      "rest": "60 Sec",
      "image": "assets/img/d7.jpg",
      "is_complete": true,
    },
    {
      "name": "Bicep Curl",
      "sets": "3",
      "reps": "12 - 10 - 8",
      "rest": "30 Sec",
      "image": "assets/img/d8.jpg",
      "is_complete": false,
    },
    {
      "name": "Tricep Dips",
      "sets": "4",
      "reps": "10 - 8 - 6 - 5",
      "rest": "45 Sec",
      "image": "assets/img/d9.jpg",
      "is_complete": false,
    },
    {
      "name": "Lunges",
      "sets": "3",
      "reps": "12 - 10 - 8",
      "rest": "30 Sec",
      "image": "assets/img/d10.jpg",
      "is_complete": true,
    },
    {
      "name": "Chest Fly",
      "sets": "3",
      "reps": "12 - 10 - 8",
      "rest": "30 Sec",
      "image": "assets/img/d11.jpg",
      "is_complete": false,
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
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
          "Week",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "Reset",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          )
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        itemBuilder: (context, index) {
          var obj = listArr[index] as Map? ?? {};

          return DayExerciseRow(
              obj: obj,
              onPressed: () {
                // context.push(const WorkoutExercisesDetailScreen(exerciseName: '', imagePath: '', defaultElapsedTime: 1, details: '',));
              });
        },
        separatorBuilder: (context, index) => const SizedBox(
          height: 20,
        ),
        itemCount: listArr.length,
      ),
    );
  }
}
