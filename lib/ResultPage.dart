// import 'Model/Test.dart';
// import 'package:flutter/material.dart';
// import 'Model/TestQuestion.dart';
//
//
// class ResultPage extends StatefulWidget {
//   final List<TestQuestion> tested_ques;
//   final totalCount;
//   final correctCount;
//   const ResultPage({
//     Key? key,
//     required this.totalCount,
//     required this.correctCount,
//     required this.tested_ques,
//   }) : super(key: key);
//
//   @override
//   State<ResultPage> createState() => _ResultPageState();
// }
//
// class _ResultPageState extends State<ResultPage> {
//
//   late double score;
//
//   @override
//   void initState() {
//     super.initState();
//     print("*************************");
//     print(widget.tested_ques);
//     score = (widget.correctCount / widget.totalCount) * 100;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(child: Text('Questions',style: TextStyle(color: Colors.pink,fontWeight:FontWeight.bold),textAlign:TextAlign.center,)),
//         backgroundColor: Colors.greenAccent,
//       ),
//       body: Column(
//           children: [
//             Text("${score}"),
//             ListView.builder(
//               itemCount: widget.tested_ques.length,
//               itemBuilder: (context, index) {
//                 final q=widget.tested_ques.length;
//                 return Container(
//                   margin: EdgeInsets.all(12),
//                   padding: EdgeInsets.all(10),
//                   decoration: BoxDecoration(color: Colors.pink[200],borderRadius: BorderRadius.circular(12)),
//                   child: Column(
//
//                     children: [
//                       Text(
//                         "Q${index + 1}: ${widget.tested_ques[index].ques}",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 10,),
//                       ...List.generate(
//                           widget.tested_ques[index].options.length, (i) {
//                         final isCorrect = i ==
//                             widget.tested_ques[index].correctOptionIndex;
//                         final isSelected = i ==
//                             widget.tested_ques[index].selectedIndex;
//
//                         Color color;
//                         if (isCorrect) {
//                           color = Colors.green;
//                         } else if (isSelected) {
//                           color = Colors.red;
//                         } else {
//                           color = Colors.grey.shade200;
//                         }
//
//                         return Container(
//                           margin: const EdgeInsets.symmetric(vertical: 2),
//                           padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: color,
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           child: Text(widget.tested_ques[index].options[i]),
//                         );
//                       }),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ]
//       ),
//     );
//   }
// }