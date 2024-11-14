import 'dart:convert';
import 'package:http/http.dart' as http;

// Thay địa chỉ IP của server
const String serverIp = 'http://192.168.1.7:5000/predict';

Future<String> fetchPrediction(Map<String, dynamic> inputData) async {
  final response = await http.post(
    Uri.parse('http://192.168.1.7:5000/predict'), // Địa chỉ IP của máy tính chạy server
    headers: {"Content-Type": "application/json"},
    body: json.encode(inputData),
  );

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return jsonResponse['prediction'];
  } else {
    throw Exception('Failed to load prediction');
  }
}
