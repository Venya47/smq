import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'database_services.dart';
import 'entry/auth.dart';

class Generate {
  final dbService = DatabaseServices();
  final String? userId = AuthMethods().getCurrentUserID();
  int total_ratio = 0;
  List<String> final_question_set=[];
  void calculateTotalRatio() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('finalUser').doc(userId).collection('modules')
        .get();
    int sum = 0;
    for (var doc in snapshot.docs) {
      final data = doc.data();
      // print("Module Name: ${data['m_name']}");
      sum += int.parse(data['m_ratio'].toString());
    }
    total_ratio = sum;
  }
    Future<List<String>> generating_process(int total_questions_inset) async{
      calculateTotalRatio();
      if(total_ratio==0)
        return final_question_set;
      final snapshot = await FirebaseFirestore.instance
          .collection('finalUser').doc(userId).collection('modules')
          .get();
      for (var doc in snapshot.docs) {
        final data = doc.data();
        int r=int.parse(data['m_ratio'].toString());
        String mid=doc.id.toString();
        int questionsToPick = ((r / total_ratio) * total_questions_inset).round();

        // Get all questions from Firestore
        final snapshot = await FirebaseFirestore.instance
            .collection('finalUser').doc(userId).collection('modules')
            .doc(mid)
            .collection('questions')
            .get();

        List<String> allQuestions = snapshot.docs.map((doc) => doc['ques'].toString()).toList();
        allQuestions.shuffle(Random());
        // print("Module Name: ${data['m_name']}");
        // print("Module Ratio: ${data['m_ratio']}");
        // print("Module ID: ${mid}");
        final_question_set.addAll(allQuestions.take(questionsToPick));
        // print(final_question_set);
      }
      print(final_question_set);
      return final_question_set;
  }
}