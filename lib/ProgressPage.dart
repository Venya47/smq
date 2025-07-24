import 'Barchart.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/material.dart';
import 'database_services.dart';
import 'entry/auth.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);
  final dbService = DatabaseServices();
  final String? userId = AuthMethods().getCurrentUserID();
  late double prog=0.0;
  void setProg() async {
    double result = await dbService.getProgress(); //Await the value
    setState(() {
      prog = result;
      _valueNotifier.value = prog; //Update the circular progress bar
    });
  }

  @override
  void initState()
  {
    super.initState();
    setProg();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(245, 232, 221, 1.0),
      child: Center(
        child: Column(
          children:[
            Text("Progress Page",style: TextStyle(fontSize: 18),),
            Expanded(
                child: BarChartSample1()
            ),
            Container(
              padding: EdgeInsets.all(18),
              margin: EdgeInsets.all(18),
              width: 250,
              height: 250,
              child: DashedCircularProgressBar.aspectRatio(
                aspectRatio: 1, // width ÷ height
                valueNotifier: _valueNotifier,
                progress:prog,
                startAngle: 225,
                sweepAngle: 270,
                foregroundColor: Color.fromRGBO(181, 130, 140, 1.0),
                backgroundColor: const Color(0xffeeeeee),
                foregroundStrokeWidth: 15,
                backgroundStrokeWidth: 15,
                animation: true,
                animationDuration: Duration(seconds: 2),
                seekSize: 6,
                seekColor: const Color(0xffeeeeee),
                child: Center(
                  child: ValueListenableBuilder(
                      valueListenable: _valueNotifier,
                      builder: (_, double value, __) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${prog}%',
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w200,
                                fontSize: 40
                            ),
                          ),
                          Text(
                            'Accuracy',
                            style: const TextStyle(
                                color: Color(0xffeeeeee),
                                fontWeight: FontWeight.w400,
                                fontSize: 16
                            ),
                          ),
                        ],
                      )
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// import 'package:checking_firebase/Barchart.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class ProgressPage extends StatefulWidget {
//   const ProgressPage({super.key});
//
//   @override
//   State<ProgressPage> createState() => _ProgressPageState();
// }
//
// class _ProgressPageState extends State<ProgressPage> {
//   final ValueNotifier<double> _valueNotifier = ValueNotifier(0);
//   List<double> dailyScores = List.filled(7, 0);
//   bool isLoading = true;
//   String? userId = FirebaseAuth.instance.currentUser?.uid;
//
//   @override
//   void initState() {
//     super.initState();
//     loadProgress();
//   }
//
//   Future<void> loadProgress() async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection("finalUser")
//         .doc(userId)
//         .collection("test")
//         .orderBy("createdAt", descending: true)
//         .get();
//
//     Map<String, List<double>> scoresByDay = {};
//     DateTime now = DateTime.now();
//     double totalScore = 0;
//     int totalCount = 0;
//
//     for (int i = 0; i < 7; i++) {
//       final dateKey = DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: i)));
//       scoresByDay[dateKey] = [];
//     }
//
//     for (var doc in snapshot.docs) {
//       final data = doc.data();
//       Timestamp? timestamp = data['createdAt'];
//       double score = data['score']?.toDouble() ?? 0;
//
//       if (timestamp != null) {
//         String dayKey = DateFormat('yyyy-MM-dd').format(timestamp.toDate());
//         if (scoresByDay.containsKey(dayKey)) {
//           scoresByDay[dayKey]!.add(score);
//           totalScore += score;
//           totalCount++;
//         }
//       }
//     }
//
//     for (int i = 0; i < 7; i++) {
//       final dateKey = DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: i)));
//       final scores = scoresByDay[dateKey]!;
//       dailyScores[6 - i] = scores.isNotEmpty
//           ? scores.reduce((a, b) => a + b) / scores.length
//           : 0;
//     }
//
//     double avg = totalCount == 0 ? 0 : totalScore / totalCount;
//     _valueNotifier.value = avg;
//
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     return Center(
//       child: Column(
//         children: [
//           const SizedBox(height: 20),
//           const Text("Progress Page",
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 12),
//
//           /// Chart
//           Expanded(child: BarChartSample1(scores: dailyScores)),
//
//           /// Circular Progress (Average Score)
//           Container(
//             padding: const EdgeInsets.all(18),
//             margin: const EdgeInsets.all(18),
//             width: 250,
//             height: 250,
//             child: DashedCircularProgressBar.aspectRatio(
//               aspectRatio: 1,
//               valueNotifier: _valueNotifier,
//               progress: _valueNotifier.value,
//               startAngle: 225,
//               sweepAngle: 270,
//               foregroundColor: Colors.green,
//               backgroundColor: const Color(0xffeeeeee),
//               foregroundStrokeWidth: 15,
//               backgroundStrokeWidth: 15,
//               animation: true,
//               animationDuration: const Duration(seconds: 2),
//               seekSize: 6,
//               seekColor: const Color(0xffeeeeee),
//               child: Center(
//                 child: ValueListenableBuilder(
//                   valueListenable: _valueNotifier,
//                   builder: (_, double value, __) => Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         '${value.toInt()}%',
//                         style: const TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.w200,
//                           fontSize: 40,
//                         ),
//                       ),
//
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
