import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Model/Question.dart';
import 'database_services.dart'; // Your Question model

Future<List<Question>> generateQuestionsUsingAI(String topic) async {
  final url = Uri.parse("https://api.cohere.ai/v1/generate");

  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer coHSbbsYdByKKBPKv6S6X8pZ1nN5XgpC9HjMBedZ', // ✅ Make sure to hide this in production
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      "prompt": '''
Generate 10 multiple choice questions based on the topic "$topic". 
Each question must have:
- "ques": the question text
- "options": a list of 4 options
- "correctOptionIndex": index (0-3) of the correct answer

Return the result as a JSON array like:
[
  {
    "ques": "...",
    "options": ["A", "B", "C", "D"],
    "correctOptionIndex": 1
  },
  ...
]
''',
      "max_tokens": 800,
      "temperature": 0.7,
    }),
  );

  if (response.statusCode == 200) {
    final jsonBody = jsonDecode(response.body);
    final text = jsonBody['generations'][0]['text'].trim();
    final dbService = DatabaseServices();
    final modid = await dbService.createModule(topic);

    try {
      // Try to extract JSON array from the text
      final RegExp jsonArrayRegex = RegExp(r'(\[\s*\{.*?\}\s*\])', dotAll: true);
      final match = jsonArrayRegex.firstMatch(text);
      final extractedJson = match?.group(1);
      if (extractedJson == null) throw FormatException("JSON array not found in text.");

      final List<dynamic> decoded = jsonDecode(extractedJson);
      List<Question> list = decoded.map((q) => Question(
        mid: modid,
        ques: q['ques'],
        options: List<String>.from(q['options']),
        correctOptionIndex: q['correctOptionIndex'],
      )).toList();

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


