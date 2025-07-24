import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'TestQuestion.dart';

class Test {
  final DateTime createdAt;
  final List<TestQuestion> questions;
  final int total_ques;
  final int crt_ques;
  final double score;

  Test( {
    required this.createdAt,
    required this.questions,
    required this.total_ques,
    required this.crt_ques,
    required this.score,
  });

  //object to Map(document)
  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt,
      'questions': questions.map((q) => q.toMap()).toList(),
      'total_ques': total_ques,
      'crt_ques': crt_ques,
      'score': score,
    };
  }

  //object from Map(document)
  factory Test.fromMap(Map<String, dynamic> map) {
    return Test(
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      questions: (map['questions'] as List)
          .map((q) => TestQuestion.fromMap(q))
          .toList(),
      total_ques: map['total_ques'],
      crt_ques: map['crt_ques'],
      score: (map['score'] as num).toDouble(),
    );
  }

}
