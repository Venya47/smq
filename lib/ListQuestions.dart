import 'AddQuestion.dart';
import 'database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'entry/auth.dart';


 class Listquestions extends StatefulWidget {
   final moduleId;
   const Listquestions({
     Key? key,
     required this.moduleId,
   }) : super(key: key);

   @override
   State<Listquestions> createState() => _ListquestionsState();
 }

 class _ListquestionsState extends State<Listquestions> {

   final dbService = DatabaseServices();
   // final TextEditingController taskController = TextEditingController();
   final TextEditingController numberController = TextEditingController();
   final String? userId = AuthMethods().getCurrentUserID();
   var moduleRatio=0;
   @override
   void initState()  {
     super.initState();
      getModuleRatio(widget.moduleId).then((value) {
       if (value != null) {
         setState(() {
           moduleRatio = value;
         });
       }
     });
   }


   Future<int?> getModuleRatio(String moduleId) async {
     try {
       final docSnapshot = await FirebaseFirestore.instance
           .collection("finalUser").doc(userId).collection("modules")
           .doc(moduleId)
           .get();

       if (docSnapshot.exists) {
         final data = docSnapshot.data();
         return data?['m_ratio']; // returns ratio value
       } else {
         print("Module not found");
         return null;
       }
     } catch (e) {
       print("Error fetching ratio: $e");
       return null;
     }
   }
   @override
   Widget build(BuildContext context) {
     return  Scaffold(
       appBar: AppBar(
         //title: Center(child: Text('Questions',style: TextStyle(color: Colors.pink,fontWeight:FontWeight.bold),textAlign:TextAlign.center,)),
         backgroundColor: Color.fromRGBO(255, 135, 135,1.0),
       ),
       body: Padding(
         padding: const EdgeInsets.all(16.0),
         child: Column(
           children: [
             Row(
               children: [
                 // Expanded(
                 //   child: TextField(
                 //     controller: taskController,
                 //     decoration: InputDecoration(
                 //       hintText: 'Enter Questions...',
                 //       border: OutlineInputBorder(),
                 //       focusedBorder: OutlineInputBorder(
                 //         borderSide: BorderSide(color: Colors.pinkAccent),
                 //       ),
                 //     ),
                 //   ),
                 // ),
                 SizedBox(width: 10),
                 ElevatedButton(
                   onPressed: () {
                     setState(() {
                       Navigator.push(context,
                       MaterialPageRoute(builder:(context)=>AddQuestionPage(moduleId: widget.moduleId))
                     );});},
                   child: Text('+',style: TextStyle(color: Colors.brown),),
                   style: ElevatedButton.styleFrom(
                     backgroundColor: Color.fromRGBO(255, 236, 158, 1.0),
                     fixedSize: Size(80, 80),
                   ),
                 ),
                 SizedBox(width: 10),
                 ElevatedButton(
                   onPressed: () {
                     setState(() {dbService.deleteModule(widget.moduleId);});
                     Navigator.pop(context);
                   },
                   child: Text('Delete Module',style: TextStyle(color: Colors.brown),),
                   style: ElevatedButton.styleFrom(
                     backgroundColor: Color.fromRGBO(255, 236, 158, 1.0),
                   ),
                 ),
               ],
             ),
             SizedBox(height: 20),
             Expanded(
               child:FutureBuilder(
                 future: FirebaseFirestore.instance.collection("finalUser").doc(userId).collection("modules").doc(widget.moduleId).collection('questions').get(),
                 builder:(context,snapshot){
                   if (snapshot.connectionState == ConnectionState.waiting) {
                     return Center(child: CircularProgressIndicator());
                   }
                   return Expanded(
                   child: ListView.builder(
                     itemCount: snapshot.data!.docs.length,
                     itemBuilder: (context, index) {
                       var q=snapshot.data!.docs;
                       if (q.isEmpty) {
                         return Center(child: Text("No questions added."));
                       }
                       return InkWell(
                         onTap: () {
                         },
                         child: Container(
                           margin: EdgeInsets.symmetric(vertical: 6),
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
                           child: Text(
                             snapshot.data!.docs[index].data()['ques'],
                             style: TextStyle(
                               fontSize: 16,
                               color: Colors.pink[800],
                               fontWeight: FontWeight.w500,
                             ),
                           ),
                         ),
                       );
                     },
                   ),
                 );},
               ),
             ),

             Column(
               crossAxisAlignment: CrossAxisAlignment.end,
               children: [
                 ElevatedButton(
                     onPressed: (){
                       setState(() {
                         final input=numberController.text;
                         final int? num = int.tryParse(input);
                         dbService.updateModuleRatio(widget.moduleId,num);
                         moduleRatio=num!;
                       });
                     },
                     style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                     child: Text("Update",style: TextStyle(color: Colors.white),)),
                 TextField(
                   controller: numberController,
                   keyboardType: TextInputType.number,
                   decoration: InputDecoration(
                     labelText: "current ratio: $moduleRatio",
                     border: OutlineInputBorder(),

                   ),
                 ),

               ],
             ),

           ],
         ),
       ),
     );
   }
 }
