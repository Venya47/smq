import 'dart:core';
import 'Model/TestQuestion.dart';
import 'package:flutter/material.dart';
import 'Model/Question.dart';
import 'Question_Brain.dart';
import 'dummy.dart';

class QuizzApp extends StatefulWidget {
  final List<Question> result;

  const QuizzApp({Key? key, required this.result}) : super(key: key);

  @override
  State<QuizzApp> createState() => _QuizzAppState();
}

class _QuizzAppState extends State<QuizzApp> {
  late QuestionBrain qb;
  final List<Icon> scoreIcons = [];
  final List<TestQuestion> testedQuestions = [];
  int correctCount = 0;

  @override
  void initState() {
    super.initState();
    qb = QuestionBrain(ques: widget.result);
  }

  void handleAnswer(int selectedIndex) {
    testedQuestions.add(TestQuestion.fromQuestion(qb.getQuestion(), selectedIndex));

    if (qb.getCorrectOption() == selectedIndex) {
      correctCount++;
      scoreIcons.add(Icon(Icons.check, color: Colors.green[400]));
    } else {
      scoreIcons.add(Icon(Icons.close, color: Colors.red[400]));
    }

    bool isFinished = qb.isfinished() == 1;

    setState(() {
      if (!isFinished) {
        qb.nextq();
      }
    });

    if (isFinished) {
      print("Quiz finished");
      for (var q in testedQuestions) {
        print('Question: ${q.ques}');
        print('Answer: ${q.options[q.correctOptionIndex]}');
        print('Selected Answer: ${q.options[q.selectedIndex]}');
      }
      Navigator.push(context,MaterialPageRoute(builder: (context)=>dummy(testedQuestion: testedQuestions, crt: correctCount,)));

    }
  }

  @override
  Widget build(BuildContext context) {
    if (qb.totalCount() == 0) {
      // Show fallback if question list is empty
      return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text('Quiz with Question Set'),
          ),
          backgroundColor: Colors.greenAccent,
        ),
        body: const Center(
          child: Text(
            "No questions available.",
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 20),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                qb.getq(),
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(4, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: ElevatedButton(
                onPressed: () => handleAnswer(index),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[400],
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 5,
                  shadowColor: Colors.pinkAccent,
                ),
                child: Text(
                  qb.getOption(index),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
            child: Row(children: scoreIcons),
          ),
        ],
      ),
    );
  }
}

// import 'dart:core';
// import 'package:checking_firebase/TestQuestion.dart';
// import 'package:checking_firebase/database_services.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'Generate_Question.dart';
// import 'Generate_Question_Screen.dart';
// import 'ListQuestions.dart';
// import 'Question.dart';
// import 'Question_Brain.dart';
// import 'ResultPage.dart';
//
// class quizzapp extends StatefulWidget {
//   final List<Question> result;
//   const quizzapp({
//     Key? key,
//     required this.result,
//   }) : super(key: key);
//   @override
//   State<quizzapp> createState() => _quizzappState();
// }
//
// class _quizzappState extends State<quizzapp> {
//   late QuestionBrain qb;
//
//   @override
//   void initState() {
//     super.initState();
//     qb = QuestionBrain(ques: widget.result);
//   }
//   final List<Icon> Score = [];
//   final List<TestQuestion> tested_question = [];
//   int correctCount=0;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(child: Text('Quizz with Question Set',style: TextStyle(color: Colors.pink,fontWeight:FontWeight.bold),textAlign:TextAlign.center,)),
//         backgroundColor: Colors.greenAccent,
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           Expanded(
//             flex: 4,
//             child: Center(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: 32.0,
//                 ),
//                 child: Text(
//                   qb.getq(),
//                   //style: TextStyle(color: Colors.purple, fontSize: 30.0),
//                 ),
//               ),
//             ),
//           ),
//           Expanded( //for option 0
//             child: Padding(
//               padding: EdgeInsets.all(16.0),
//               child: TextButton(
//                 child: Text(
//                   qb.getOption(0),
//                   style: TextStyle(color: Colors.white, fontSize: 20.0),
//                 ),
//                 style: TextButton.styleFrom(backgroundColor: Colors.pink[300]),
//                 onPressed: () {
//                   tested_question.add(TestQuestion.fromQuestion(qb.getQuestion(), 0));
//                   setState(
//                         () {
//                       if (qb.isfinished() == 1) {
//                         print("Quizz finished");
//                         if (mounted) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ResultPage(
//                                 totalCount: qb.totalCount(),
//                                 correctCount: correctCount,
//                                 tested_ques: tested_question,
//                               ),
//                             ),
//                           );
//                         }
//                       } else {
//                         if (qb.getCorrectOption() == 0){
//                           correctCount++;
//                           Score.add(Icon(
//                             Icons.check,
//                             color: Colors.green[400],
//                           ));
//                         }
//                         else
//                           Score.add(Icon(
//                             Icons.close,
//                             color: Colors.red[400],
//                           ));
//                         qb.nextq();
//                       }
//                       ;
//                     },
//                   );
//                 },
//               ),
//             ),
//           ),
//           Expanded( //for option 1
//             child: Padding(
//               padding: EdgeInsets.all(16.0),
//               child: TextButton(
//                 child: Text(
//                   qb.getOption(1),
//                   style: TextStyle(color: Colors.white, fontSize: 20.0),
//                 ),
//                 style: TextButton.styleFrom(backgroundColor: Colors.pink[300]),
//                 onPressed: () {
//                   tested_question.add(TestQuestion.fromQuestion(qb.getQuestion(), 1));
//                   setState(
//                         () {
//                       if (qb.isfinished() == 1) {
//                         print("Quizz finished");
//                         if (mounted) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ResultPage(
//                                 totalCount: qb.totalCount(),
//                                 correctCount: correctCount,
//                                 tested_ques: tested_question,
//                               ),
//                             ),
//                           );
//                         }
//
//                       } else {
//                         if (qb.getCorrectOption() == 1){
//                           correctCount++;
//                           Score.add(Icon(
//                             Icons.check,
//                             color: Colors.green[400],
//                           ));
//                         }
//                         else
//                           Score.add(Icon(
//                             Icons.close,
//                             color: Colors.red[400],
//                           ));
//                         qb.nextq();
//                       }
//                       ;
//                     },
//                   );
//                 },
//               ),
//             ),
//           ),
//           Expanded( //for option 2
//             child: Padding(
//               padding: EdgeInsets.all(16.0),
//               child: TextButton(
//                 child: Text(
//                   qb.getOption(2),
//                   style: TextStyle(color: Colors.white, fontSize: 20.0),
//                 ),
//                 style: TextButton.styleFrom(backgroundColor: Colors.pink[300]),
//                 onPressed: () {
//                   tested_question.add(TestQuestion.fromQuestion(qb.getQuestion(), 2));
//                   setState(
//                         () {
//                       if (qb.isfinished() == 1) {
//                         if (mounted) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ResultPage(
//                                 totalCount: qb.totalCount(),
//                                 correctCount: correctCount,
//                                 tested_ques: tested_question,
//                               ),
//                             ),
//                           );
//                         }
//
//                       } else {
//                         if (qb.getCorrectOption() == 2){
//                           correctCount++;
//                           Score.add(Icon(
//                             Icons.check,
//                             color: Colors.green[400],
//                           ));
//                         }
//                         else
//                           Score.add(Icon(
//                             Icons.close,
//                             color: Colors.red[400],
//                           ));
//                         qb.nextq();
//                       }
//                       ;
//                     },
//                   );
//                 },
//               ),
//             ),
//           ),
//           Expanded( //for option 3
//             child: Padding(
//               padding: EdgeInsets.all(16.0),
//               child: TextButton(
//                 child: Text(
//                   qb.getOption(3),
//                   style: TextStyle(color: Colors.white, fontSize: 20.0),
//                 ),
//                 style: TextButton.styleFrom(backgroundColor: Colors.pink[300]),
//                 onPressed: () {
//                   tested_question.add(TestQuestion.fromQuestion(qb.getQuestion(), 3));
//                   setState(
//                         () {
//                       if (qb.isfinished() == 1) {
//                         print("Quizz finished");
//                         if (mounted) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ResultPage(
//                                 totalCount: qb.totalCount(),
//                                 correctCount: correctCount,
//                                 tested_ques: tested_question,
//                               ),
//                             ),
//                           );
//                         }
//
//                       } else {
//                         if (qb.getCorrectOption() == 3) {
//                           correctCount++;
//                           Score.add(Icon(
//                             Icons.check,
//                             color: Colors.green[400],
//                           ));
//                         }
//                         else
//                           Score.add(Icon(
//                             Icons.close,
//                             color: Colors.red[400],
//                           ));
//                         qb.nextq();
//                       };
//                     },
//                   );
//                 },
//               ),
//             ),
//           ),
//           Row(
//             children: Score,
//           )
//         ],
//       ),
//     );
//   }
// }
