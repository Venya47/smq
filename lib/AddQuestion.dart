import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Model/Question.dart';
import 'database_services.dart';

class AddQuestionPage extends StatefulWidget {
  final String moduleId; // Use if you're saving by module
  const AddQuestionPage({super.key, required this.moduleId});

  @override
  State<AddQuestionPage> createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  final TextEditingController questionController = TextEditingController();
  List<TextEditingController> optionControllers =

  List.generate(4, (_) => TextEditingController());
  final dbService = DatabaseServices();
  int selectedOptionIndex = 0;

  void saveQuestion() async {
    String question = questionController.text.trim();
    List<String> options =
    optionControllers.map((e) => e.text.trim()).toList();

    if (question.isEmpty || options.any((o) => o.isEmpty)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please fill all fields")));
      return;
    }

    Question newQuestion = Question(
      mid:widget.moduleId,
      ques: question,
      options: options,
      correctOptionIndex: selectedOptionIndex,
    );
    dbService.addQuestion(widget.moduleId, newQuestion);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Question added")));

    questionController.clear();
    optionControllers.forEach((c) => c.clear());
    setState(() {
      selectedOptionIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 135, 135,1.0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: questionController,
              decoration: InputDecoration(labelText: "Question"),
            ),
            ...List.generate(4, (index) {
              return Row(
                children: [
                  Radio(
                    value: index,
                    groupValue: selectedOptionIndex,
                    onChanged: (val) {
                      setState(() => selectedOptionIndex = val!);
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: optionControllers[index],
                      decoration: InputDecoration(labelText: "Option ${index + 1}"),
                    ),
                  ),
                ],
              );
            }),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed:(){
                setState((){
                  saveQuestion();
                Navigator.pop(context);}
                );
              },
              child: Text("Save Question"),
            ),
          ],
        ),
      ),
    );
  }
}
