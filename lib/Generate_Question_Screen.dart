
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Model/Question.dart';

class GenerateSet extends StatefulWidget {
  final List<Question> result;
  const GenerateSet({
    Key? key,
    required this.result,
  }) : super(key: key);

  @override
  State<GenerateSet> createState() => _GenerateSetState();
}

class _GenerateSetState extends State<GenerateSet> {

  @override
  void initState() {
    print("*************************************************");
    for(var q in widget.result)
    print(q.ques);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Final Question Set',style: TextStyle(color: Colors.pink,fontWeight:FontWeight.bold),textAlign:TextAlign.center,)),
        backgroundColor: Colors.greenAccent,
      ),
      body:widget.result.isEmpty
          ? Center(child: Text("No module added."))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: widget.result.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.all(6.0),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.pink[50],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    widget.result[index].ques,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.pink[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        ),
      );
  }
}

