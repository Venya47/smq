import 'Question.dart';

class Module{
  final String m_name;
  final int m_ratio;
  final List<Question> questions;

  Module({
    required this.m_name,
    required this.m_ratio,
    required this.questions,
  });

  Map<String, dynamic> toMap() {
    return {
      'm_name': m_name,
      'm_ratio': m_ratio,
      'questions': questions,
    };
  }

  factory Module.fromMap(Map<String, dynamic> map) {
    return Module(
      m_name: map['m_name'],
      m_ratio: map['m_ratio'],
      questions: List<Question>.from(map['questions']),
    );
  }
}
