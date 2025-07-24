

import 'Question.dart';

class TestQuestion extends Question {
  final int selectedIndex;

  TestQuestion({
    required mid,
    required String ques,
    required List<String> options,
    required int correctOptionIndex,
    required this.selectedIndex,
  }) : super(
    mid:mid,
    ques: ques,
    options: options,
    correctOptionIndex: correctOptionIndex,
  );
  Map<String, dynamic> toMap() {
    return {
      'mid':mid,
      'ques': ques,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
      'selectedIndex': selectedIndex,
    };
  }

  factory TestQuestion.fromMap(Map<String, dynamic> json) {
    return TestQuestion(
      mid:json['mid'],
      ques: json['ques'],
      options: List<String>.from(json['options']),
      correctOptionIndex: json['correctOptionIndex'],
      selectedIndex: json['selectedIndex'],
    );
  }

  factory TestQuestion.fromQuestion(Question q, int selectedIndex) {
    return TestQuestion(
      mid:q.mid,
      ques: q.ques,
      options: q.options,
      correctOptionIndex: q.correctOptionIndex,
      selectedIndex: selectedIndex,
    );
  }

}
