import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:specialized_project_2/common/color_extension.dart';
import 'package:specialized_project_2/screen/home/top_tab_view/exercises/exercises_row.dart';
import 'package:specialized_project_2/screen/home/top_tab_view/workout_plan/workout_exercises_screen.dart';

class ExercisesNameScreen extends StatefulWidget {
  final String categoryId; // Nhận ID từ màn hình trước

  const ExercisesNameScreen({Key? key, required this.categoryId})
      : super(key: key);

  @override
  State<ExercisesNameScreen> createState() => _ExercisesNameScreenState();
}

class _ExercisesNameScreenState extends State<ExercisesNameScreen> {
  List<Map<String, dynamic>> listArr = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchExercisesData();
  }

  Future<void> _fetchExercisesData() async {
    final url = 'http://192.168.1.8:40001/category/${widget.categoryId}';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          listArr =
          List<Map<String, dynamic>>.from(data['data'].map((exercise) => {
            'title': exercise['name'] ?? "Untitled Exercise", // Giá trị mặc định cho title
            'image': exercise['gifUrl'] ?? exercise['thumbnail'] ?? 'default_image_url', // Giá trị mặc định cho image
            'steps': exercise['steps'] ?? "No steps available",
            '_id': exercise['_id'] ?? '',
          }));
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load exercises');
      }
    } catch (e) {
      print(e);
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.secondary,
        title: const Text("Exercises",
            style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : listArr.isEmpty
          ? const Center(child: Text("No exercises available"))
          : ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: listArr.length,
        itemBuilder: (context, index) {
          final obj = listArr[index];
          return ExercisesRow(
            obj: obj,
            onPressed: () {
              if (obj['_id'] != null) { // Kiểm tra nếu exerciseId không phải null
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WorkoutExercisesDetailScreen(
                      exerciseId: obj['_id'] ?? 'unknown', // Giá trị mặc định cho exerciseId nếu cần
                      exerciseName: obj['title'] ?? '',
                      imagePath: obj['image'] ?? '',
                      defaultElapsedTime: 300,
                    ),
                  ),
                );
              }
            },
          );
        },
        separatorBuilder: (context, index) =>
        const SizedBox(height: 20),
      ),
    );
  }
}
