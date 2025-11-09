import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Model/Question.dart';
import 'database_services.dart';

Future<List<Question>> generateQuestionsUsingAI(String topic) async {
  final url = Uri.parse("https://api.cohere.ai/v1/chat");

  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer Y6fcROUKwroJ2WIXExWCsvDX7DJFiZwfmDjYY1WO',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      "model": "command-r-08-2024", // ✅ updated, currently supported model
      "message": '''
Generate 10 multiple choice questions based on the topic "$topic".
Each question must have the structure:
{
  "ques": "question text",
  "options": ["A", "B", "C", "D"],
  "correctOptionIndex": 0
}
Return ONLY a JSON array of such questions.
'''
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    String? text;

    try {
      // New Cohere response format
      text = data['text'] ??
          data['message']?['content']?[0]?['text'] ??
          data['generations']?[0]?['text'];
    } catch (_) {
      text = null;
    }

    if (text == null || text.isEmpty) {
      throw Exception('No valid text returned from Cohere API.');
    }

    try {
      // Extract JSON array from response text
      final RegExp jsonArrayRegex = RegExp(r'(\[\s*\{.*?\}\s*\])', dotAll: true);
      final match = jsonArrayRegex.firstMatch(text);
      final extractedJson = match?.group(1);

      if (extractedJson == null) throw FormatException("JSON array not found in output.");

      final List<dynamic> decoded = jsonDecode(extractedJson);

      final dbService = DatabaseServices();
      final modid = await dbService.createModule(topic);

      List<Question> list = decoded.map((q) {
        return Question(
          mid: modid,
          ques: q['ques'] ?? '',
          options: List<String>.from(q['options'] ?? []),
          correctOptionIndex: q['correctOptionIndex'] ?? 0,
        );
      }).toList();

      return list;
    } catch (e) {
      print("Error parsing Cohere response: $e\n$text");
      throw Exception("Failed to parse MCQs from Cohere.");
    }
  } else {
    print("Cohere API Error: ${response.statusCode}\n${response.body}");
    throw Exception('Cohere request failed.');
  }
}
