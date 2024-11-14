import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:specialized_project_2/screen/home/top_tab_view/exercises/exercises_cell.dart';
import 'package:specialized_project_2/screen/home/top_tab_view/exercises/exercises_name_screen.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  List listArr = []; // Danh sách bài tập

  // Hàm gọi API để lấy dữ liệu
  Future<void> fetchData() async {
    final url = Uri.parse('http://192.168.1.8:40001/category');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        setState(() {
          // Cập nhật listArr với dữ liệu từ API
          listArr = data;
        });
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Failed to load data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Gọi API khi màn hình khởi động
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listArr.isEmpty
          ? const Center(
              child:
                  CircularProgressIndicator()) // Hiển thị loading nếu dữ liệu chưa tải
          : GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15),
              itemBuilder: (context, index) {
                var obj = listArr[index] as Map? ?? {};

                return ExercisesCell(
                  obj: {
                    "title": obj["name"],
                    "subtitle": "exercises", // Subtitle giả lập
                    "image": obj["image"],
                    "_id": obj["_id"],
                  },
                  onPressed: () {
                    // Chuyển đến ExercisesNameScreen và truyền ID của bài tập
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExercisesNameScreen(categoryId:  obj["_id"],),
                      ),
                    );
                  },
                );
              },
              itemCount: listArr.length,
            ),
    );
  }
}
