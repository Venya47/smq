class Question {
  final mid;
  final String ques;
  final List<String> options;
  final int correctOptionIndex;

  Question( {
    required this.mid,
    required this.ques,
    required this.options,
    required this.correctOptionIndex,
  });

  Map<String, dynamic> toMap() {
    return {
      'mid':mid,
      'ques': ques,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      mid: map['mid'],
      ques: map['ques'],
      options: List<String>.from(map['options']),
      correctOptionIndex: map['correctOptionIndex'],
    );
  }
}
