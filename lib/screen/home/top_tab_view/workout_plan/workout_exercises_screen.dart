import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class WorkoutExercisesDetailScreen extends StatefulWidget {
  final String exerciseId; // Nhận id của bài tập từ màn hình trước
  final String exerciseName;
  final String imagePath;
  final int defaultElapsedTime;

  const WorkoutExercisesDetailScreen({
    super.key,
    required this.exerciseId,
    required this.exerciseName,
    required this.imagePath,
    required this.defaultElapsedTime,
  });

  @override
  _WorkoutExercisesDetailScreenState createState() =>
      _WorkoutExercisesDetailScreenState();
}

class _WorkoutExercisesDetailScreenState
    extends State<WorkoutExercisesDetailScreen> {
  int elapsedTime = 1;
  bool isLoading = true;
  bool isTimerRunning = false; // Trạng thái của timer
  String? steps;
  String? gifUrl;
  Timer? timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    elapsedTime = widget.defaultElapsedTime;
    _fetchExerciseDetails(); // Lấy dữ liệu từ API
  }

  Future<void> _fetchExerciseDetails() async {
    final url = 'http://192.168.1.8:40001/exercise/${widget.exerciseId}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        setState(() {
          steps = data['steps'];
          gifUrl = data['gifUrl'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load exercise details');
      }
    } catch (e) {
      print("Error fetching details: $e");
      setState(() => isLoading = false);
    }
  }

  void playBeepSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/done.mp3'));
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  void toggleTimer() {
    if (isTimerRunning) {
      timer?.cancel();
    } else {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (elapsedTime > 0) {
            elapsedTime--;
          } else {
            playBeepSound();
            timer.cancel();
          }
        });
      });
    }
    setState(() {
      isTimerRunning = !isTimerRunning;
    });
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      elapsedTime = widget.defaultElapsedTime;
      isTimerRunning = false;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exerciseName, style: GoogleFonts.poppins()),
        backgroundColor: Colors.pinkAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              color: Colors.pinkAccent,
              padding: const EdgeInsets.all(10),
              child: Text(
                "Exercise Details",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Image.network(
              gifUrl ?? widget.imagePath,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Text(
              widget.exerciseName,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Recommended time: ${widget.defaultElapsedTime ~/ 60} min.",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              steps ?? "No steps provided",
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              "Time Remaining: ${elapsedTime}s",
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: toggleTimer,
                  child: Text(isTimerRunning ? "Pause" : "Start"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: resetTimer,
                  child: const Text("Reset"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
