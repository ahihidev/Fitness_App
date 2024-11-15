import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExWorkoutDetail extends StatefulWidget {
  final String exerciseId;
  final String exerciseName;
  final String imagePath;
  final int defaultElapsedTime;

  const ExWorkoutDetail({
    super.key,
    required this.exerciseId,
    required this.exerciseName,
    required this.imagePath,
    this.defaultElapsedTime = 300, // Default time set to 300 seconds
  });

  @override
  _ExWorkoutDetailState createState() => _ExWorkoutDetailState();
}

class _ExWorkoutDetailState extends State<ExWorkoutDetail> {
  late int elapsedTime;
  int restTime = 0; // thời gian nghỉ giữa các set
  int remainingSets = 3; // mặc định số set còn lại
  bool isLoading = true;
  bool isTimerRunning = false;
  bool isResting = false; // trạng thái nghỉ giữa set
  String? steps;
  String? gifUrl;
  Timer? timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  TextEditingController setTimeController = TextEditingController();
  TextEditingController restTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    elapsedTime = widget.defaultElapsedTime;
    setTimeController.text = widget.defaultElapsedTime.toString();
    _fetchExerciseDetails();
    _loadExerciseTime(); // Load thời gian đã lưu từ local (nếu có)
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

  // Load thời gian mặc định từ local nếu có
  Future<void> _loadExerciseTime() async {
    final prefs = await SharedPreferences.getInstance();
    int savedTime = prefs.getInt('${widget.exerciseId}_time') ?? widget.defaultElapsedTime;
    setState(() {
      elapsedTime = savedTime;
      setTimeController.text = savedTime.toString();
    });
  }

  // Lưu thời gian mặc định xuống local sau khi user chọn
  Future<void> _saveExerciseTime(int time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${widget.exerciseId}_time', time);
  }

  // Lưu trạng thái done của bài tập xuống local
  Future<void> saveExerciseAsDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${widget.exerciseId}_done', true);
    Navigator.pop(context, true); // Trở lại và báo cho màn hình trước cập nhật
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
            if (isResting) {
              // Hoàn thành thời gian nghỉ giữa các set
              elapsedTime = int.parse(setTimeController.text);
              isResting = false;
              if (remainingSets > 0) remainingSets--;
            } else {
              // Hoàn thành một set
              playBeepSound();
              if (remainingSets > 1) {
                elapsedTime = restTime;
                isResting = true;
              } else {
                timer.cancel(); // Hoàn thành tất cả set
              }
            }
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
      elapsedTime = int.parse(setTimeController.text);
      remainingSets = 3; // Reset số set
      isTimerRunning = false;
      isResting = false;
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
              steps ?? "No steps provided",
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: setTimeController,
                    decoration: InputDecoration(labelText: "Set Time (s)"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      int newTime = int.tryParse(value) ?? widget.defaultElapsedTime;
                      elapsedTime = newTime;
                      _saveExerciseTime(newTime); // Lưu thời gian đã set xuống local
                    },
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: restTimeController,
                    decoration: InputDecoration(labelText: "Rest Time (s)"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      restTime = int.tryParse(value) ?? 0;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "Time Remaining: ${elapsedTime}s",
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            Text(
              "Sets Remaining: $remainingSets",
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveExerciseAsDone,
              child: const Text("Done"),
            ),
          ],
        ),
      ),
    );
  }
}
