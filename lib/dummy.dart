
import 'package:flutter/material.dart';
import 'Model/Test.dart';
import 'Model/TestQuestion.dart';
import 'bottomnav.dart';
import 'database_services.dart';

class dummy extends StatefulWidget {
  final int crt;
  final List<TestQuestion> testedQuestion;
  const dummy({super.key, required this.testedQuestion, required this.crt});

  @override
  State<dummy> createState() => _dummyState();
}

class _dummyState extends State<dummy> {
  late int total_ques=0;
  late int crt_ques;
  late double score;
  final dbService = DatabaseServices();
  @override
  void initState()
  {
    total_ques=widget.testedQuestion.length;
    crt_ques=widget.crt;
    score=(crt_ques/total_ques)*100;
    DateTime date=DateTime.now();
    dbService.addTest(Test(createdAt: date, questions: widget.testedQuestion, total_ques: total_ques, crt_ques: crt_ques, score: score));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Questions',style: TextStyle(color: Colors.pink,fontWeight:FontWeight.bold),textAlign:TextAlign.center,)),
          backgroundColor: Colors.greenAccent,
        ),
      body:Column(
        children: [
          SizedBox(height: 10,),
          Center(child: Text("Your Score :  ${score}")),
          SizedBox(height: 10,),
          Text("You have successfully completed the quiz"),
          SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
              itemCount: widget.testedQuestion.length,
              itemBuilder: (context, index) {
                final question = widget.testedQuestion[index];
                return Container(
                  margin: EdgeInsets.all(12),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.pink[200],borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children:[
                      Text(question.ques,style: TextStyle(fontSize: 14),),
                      SizedBox(height: 10,),// Adjust field name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                               margin: EdgeInsets.all(16.0), // Outside space
                               padding: EdgeInsets.all(12.0),
                                              decoration: BoxDecoration(color: Colors.green[200],borderRadius: BorderRadius.circular(12)),
                              child: Text(question.options[question.correctOptionIndex])),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: Container(
                          margin: EdgeInsets.all(16.0), // Outside space
                           padding: EdgeInsets.all(12.0),
                                          decoration: BoxDecoration(color: Colors.green[200],borderRadius: BorderRadius.circular(12)),
                              child: Text(question.options[question.selectedIndex])),
                        ),

                      ],
                    ),] // Adjust field name
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 6,                         // Shadow elevation
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blueGrey,  // Button color
                ),
              onPressed:(){
              setState(() {
                dbService.updateProgress(score);
              });
              Navigator.push(context,MaterialPageRoute(builder: (context)=>BottomNav()));
              },
              child: Text("Finish",style: TextStyle(color: Colors.black),)
          ),
          SizedBox(height: 40,)
        ],
      )
    );
  }
}
