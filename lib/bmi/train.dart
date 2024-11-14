import 'package:flutter/material.dart';
import 'api_service.dart'; // Import file chứa fetchPrediction

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exercise Recommendation Predictor',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PredictionPage(),
    );
  }
}

class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key});

  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _gender = 'Female';
  String _prediction = '';

  Future<void> _getPrediction() async {
    try {
      // Dữ liệu đầu vào
      double weight = double.parse(_weightController.text);
      double height = double.parse(_heightController.text);
      int age = int.parse(_ageController.text);

      // Tính BMI và phân loại BMIcase
      double bmi = weight / (height * height);
      String bmiCase = _getBmiCase(bmi);

      Map<String, dynamic> inputData = {
        'Weight': weight,
        'Height': height,
        'BMI': bmi,
        'Gender_Female': _gender == 'Female' ? 1 : 0,
        'Gender_Male': _gender == 'Male' ? 1 : 0,
        'Age': age,
        'BMIcase_sever thinness': bmiCase == 'sever thinness' ? 1 : 0,
        'BMIcase_moderate thinness': bmiCase == 'moderate thinness' ? 1 : 0,
        'BMIcase_mild thinness': bmiCase == 'mild thinness' ? 1 : 0,
        'BMIcase_normal': bmiCase == 'normal' ? 1 : 0,
        'BMIcase_over weight': bmiCase == 'over weight' ? 1 : 0,
        'BMIcase_obese': bmiCase == 'obese' ? 1 : 0,
        'BMIcase_severe obese': bmiCase == 'severe obese' ? 1 : 0,
        'BMIcase_extremely obese': bmiCase == 'extremely obese' ? 1 : 0,
      };

      String prediction = await fetchPrediction(inputData);
      setState(() {
        _prediction = prediction;
      });
    } catch (e) {
      setState(() {
        _prediction = 'Error: $e';
      });
    }
  }

  String _getBmiCase(double bmi) {
    if (bmi < 16) return "sever thinness";
    if (bmi < 17) return "moderate thinness";
    if (bmi < 18.5) return "mild thinness";
    if (bmi < 25) return "normal";
    if (bmi < 30) return "over weight";
    if (bmi < 35) return "obese";
    if (bmi < 40) return "severe obese";
    return "extremely obese";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise Recommendation Predictor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _weightController,
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _heightController,
              decoration: const InputDecoration(labelText: 'Height (m)'),
              keyboardType: TextInputType.number,
            ),
            Row(
              children: [
                const Text('Gender:'),
                Radio(
                  value: 'Female',
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = value as String;
                    });
                  },
                ),
                const Text('Female'),
                Radio(
                  value: 'Male',
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = value as String;
                    });
                  },
                ),
                const Text('Male'),
              ],
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getPrediction,
              child: const Text('Predict'),
            ),
            const SizedBox(height: 20),
            Text('Prediction: $_prediction'),
          ],
        ),
      ),
    );
  }
}
