import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ex_workout_detail.dart'; // Import màn ExWorkoutDetail
import 'package:specialized_project_2/common/color_extension.dart';

class WeekDetailsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> weeklySchedule;

  const WeekDetailsScreen({super.key, required this.weeklySchedule});

  @override
  State<WeekDetailsScreen> createState() => _WeekDetailsScreenState();
}

class _WeekDetailsScreenState extends State<WeekDetailsScreen> {
  Map<String, bool> completionStatus = {}; // Lưu trạng thái hoàn thành của mỗi bài tập

  @override
  void initState() {
    super.initState();
    _loadCompletionStatus();
  }

  Future<void> _loadCompletionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    // Dùng setState để áp dụng khi lấy trạng thái từ SharedPreferences
    setState(() {
      for (var exercise in widget.weeklySchedule) {
        var exerciseId = exercise['exerciseId']?['id'] ?? ''; // đảm bảo không null
        if (exerciseId.isNotEmpty) {
          completionStatus[exerciseId] = prefs.getBool('${exerciseId}_done') ?? false;
        }
      }
    });
  }

  Future<void> _navigateToExerciseDetail(Map<String, dynamic> exercise) async {
    var exerciseInfo = exercise['exerciseId'];
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExWorkoutDetail(
          exerciseId: exerciseInfo?['id'] ?? '', // Chuyển đổi null thành chuỗi rỗng
          exerciseName: exerciseInfo?['name'] ?? 'Exercise',
          imagePath: exerciseInfo?['gifUrl'] ?? '',
          defaultElapsedTime: exercise['defaultElapsedTime'] ?? 300,
        ),
      ),
    );

    if (result == true) {
      await _loadCompletionStatus(); // Tải lại trạng thái hoàn thành sau khi quay lại
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
          "Weekly Exercises",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        itemBuilder: (context, index) {
          var exercise = widget.weeklySchedule[index];
          var exerciseInfo = exercise['exerciseId'];
          var exerciseId = exerciseInfo?['id'] ?? ''; // đảm bảo không null
          bool isDone = completionStatus[exerciseId] ?? false;

          return ListTile(
            leading: Stack(
              children: [
                Image.network(
                  exerciseInfo?['gifUrl'] ?? "https://via.placeholder.com/50",
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                if (isDone)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
              ],
            ),
            title: Text(
              exerciseInfo?['name'] ?? 'No Name',
              style: TextStyle(color: TColor.primaryText, fontSize: 15),
            ),
            subtitle: Text(
              'Reps: ${exercise["reps"] ?? "N/A"}, Sets: ${exercise["sets"] ?? "N/A"}',
              style: TextStyle(color: TColor.secondaryText, fontSize: 13),
            ),
            onTap: () => _navigateToExerciseDetail(exercise), // Điều hướng tới ExWorkoutDetail
          );
        },
        separatorBuilder: (context, index) => const Divider(),
        itemCount: widget.weeklySchedule.length,
      ),
    );
  }
}
