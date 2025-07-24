import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'Model/Question.dart';
import 'Model/Test.dart';
import 'Model/User.dart';
import 'entry/auth.dart';

class DatabaseServices  {
  final String? userId =  AuthMethods().getCurrentUserID();
  final instance =FirebaseFirestore.instance;
  Future<String> createModule(String title) async {
    try {
      DocumentReference docRef = await instance.collection("finalUser").doc(userId).collection('modules').add({
        'm_name': title,
        'm_ratio':0
      });
      return docRef.id;
    } catch (e) {
      print('Error creating module: $e');
      rethrow;
    }
  }

  Future<void> addModule(String n) async
  {
    try {

      await instance.collection("finalUser").doc(userId).collection("modules").add({
          "m_name":n,
          "m_ratio":0
      }
      );
    }catch (e) {
      print(e);
    }
  }
  Future<void> addTest(Test test)
  async {
    try {
      await instance.collection("finalUser").doc(userId).collection("tests").doc().set(test.toMap());
    }catch(e){
      print(e);
    }
  }
  Future<void> addModuleByAI(String n,List<Question> aiq)
  async {
    try {
      for (var q in aiq) {
        addQuestion(q.mid, q);
        print(q.mid+" --->  "+q.ques);
        };
    }catch (e) {
      print(e);
    }
  }

  Future<void> addQuestion(String mid,Question question) async
  {
    try {
      await instance.collection('finalUser').doc(userId).collection("modules")
          .doc(mid).collection('questions')
          .add(question.toMap());
    }catch (e) {
      print(e);
    }
  }
  Future<AppUser?> getUserDetails(String uid) async {
    try {
      DocumentSnapshot doc =
      await FirebaseFirestore.instance.collection('finalUser').doc(uid).get();

      if (doc.exists) {
        return AppUser.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  Future<void> deleteModule(String moduleId) async {
    try {
      await FirebaseFirestore.instance.collection('finalUser').doc(userId).collection("modules").doc(moduleId).delete();
      print('Module deleted successfully');
    } catch (e) {
      print('Failed to delete module: $e');
    }
  }


  updateModuleRatio(moduleId,r) async {
    try {
      await instance.collection("finalUser").doc(userId).collection("modules").doc(moduleId).update({
        "m_ratio": r
      });
    } catch (e) {
      print(e);
    }
    Future<int?> getModuleRatio(moduleId) async {
      try {
        final doc = await FirebaseFirestore.instance
            .collection("finalUser").doc(userId).collection("modules")
            .doc(moduleId)
            .get();

        if (doc.exists) {
          final data = doc.data();
          final ratio = data?['m_ratio'];
          return ratio;
        } else {
          return null;
        }
      } catch (e) {
        return null;
      }
    }
  }


  Future<int> calculateTotalRatio() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("finalUser").doc(userId).collection("modules")
        .get();
    int sum = 0;
    for (var doc in snapshot.docs) {
      final data = doc.data();
      // print("Module Name: ${data['m_name']}");
      sum += int.parse(data['m_ratio'].toString());
    }
    return sum;
  }

  Future<List<Question>> generating_process(int total_questions_inset) async{  //business logic
    int total_ratio=await calculateTotalRatio();
    List<Question> final_question_set=[];
    if(total_ratio==0)
      return final_question_set;
    final snapshot = await FirebaseFirestore.instance
        .collection("finalUser").doc(userId).collection("modules")
        .get();
    for (var doc in snapshot.docs) {
      final data = doc.data();
      int r=int.parse(data['m_ratio'].toString());
      String mid=doc.id.toString();
      int questionsToPick = ((r / total_ratio) * total_questions_inset).round();

      // Get all questions from Firestore
      final snapshot = await FirebaseFirestore.instance
          .collection("finalUser").doc(userId).collection("modules")
          .doc(mid)
          .collection('questions')
          .get();

      List<Question> allQuestions = await getAllQuestions(mid);
      allQuestions.shuffle(Random());
      // print("Module Name: ${data['m_name']}");
      // print("Module Ratio: ${data['m_ratio']}");
      // print("Module ID: ${mid}");
      final_question_set.addAll(allQuestions.take(questionsToPick));
      print(final_question_set);
    }
    final_question_set.forEach((q) {
      print(q.ques);
    });

    // print(final_question_set);
    return final_question_set;
  }

  Future<List<Question>> getAllQuestions(String moduleId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("finalUser").doc(userId).collection("modules")
          .doc(moduleId)
          .collection('questions')
          .get();

      if (snapshot.docs.isEmpty) {
        return []; // Return empty list if no documents found
      }

      return snapshot.docs.map((doc) {
        final data = doc.data();
        if (data == null) return null; // Skip null docs
        return Question.fromMap(data);
      }).whereType<Question>().toList(); // Filters out null values safely
    } catch (e) {
      print("Error fetching questions for module $moduleId: $e");
      return []; // Return empty list in case of error
    }
  }

  Future<List<Map<String, dynamic>>> getLast7DaysTestCount() async {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(Duration(days: 6));

    // Fetch all tests created in the last 7 days
    final snapshot = await FirebaseFirestore.instance
        .collection('finalUser').doc(userId)
        .collection('tests') // replace with your collection name
        .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(sevenDaysAgo.year, sevenDaysAgo.month, sevenDaysAgo.day)))
        .get();

    // Initialize map for counting (Monday = 0, Sunday = 6)
    Map<int, int> weekdayCounts = {for (int i = 0; i < 7; i++) i: 0};

    for (var doc in snapshot.docs) {
      final createdAt = (doc['createdAt'] as Timestamp).toDate();
      int weekday = (createdAt.weekday + 6) % 7; // Convert to Monday = 0
      weekdayCounts[weekday] = weekdayCounts[weekday]! + 1;
    }

    // Return in reverse order from today
    List<Map<String, dynamic>> result = [];
    for (int i = 0; i < 7; i++) {
      final day = (now.weekday + 6 - i) % 7; // Step back from today
      result.add({
        "weekday": day,
        "count": weekdayCounts[day] ?? 0,
      });
    }

    return result;
  }

  Future<void> updateProgress(double score) async {
    try {
      double oldProgress=await getProgress();
      double newProgress=(oldProgress+score)/2;
      await instance.collection('finalUser').doc(userId).update({
        'progress': newProgress,
      });
    }catch(e) {
      print(e);
    }
  }

  Future<double> getProgress() async {
    final userDoc = await instance.collection('finalUser').doc(userId).get();
    if (userDoc.exists) {
      return (userDoc.data()?['progress'] ?? 0.0).toDouble();
    } else {
      return 0.0;
    }
  }

}