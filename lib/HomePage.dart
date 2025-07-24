import 'GPT_generation.dart';
import 'database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Generate_Question.dart';
import 'ListQuestions.dart';
import 'Model/Question.dart';
import 'Quizz_Screen.dart';
import 'entry/auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbService = DatabaseServices();
  final TextEditingController taskController = TextEditingController();
  final TextEditingController qnumberController = TextEditingController();
  final String? userId = AuthMethods().getCurrentUserID();

  int RenderCount=-1;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: InputDecoration(
                      hintText: 'Enter Module...',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pinkAccent),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      dbService.addModule(taskController.text);
                    });},
                  child: Text('+',style: TextStyle(color: Colors.brown),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(255, 236, 158, 1.0),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    String topic=taskController.text;
                    List<Question> gptq=(await generateQuestionsUsingAI(topic)).cast<Question>();
                    int index = 1;
                    gptq.forEach((question) {
                      print("$index. ${question.ques}");
                      question.options.asMap().forEach((i, option) {
                        print("   ${String.fromCharCode(65 + i)}. $option");
                      });
                      index++;
                    });
                    setState(() {
                      dbService.addModuleByAI(topic,gptq);
                    });

                  },
                  child: Text('AI',style: TextStyle(color: Colors.brown),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(255, 236, 158, 1.0),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // button in a list module page
                  },
                  child: Text('del',style: TextStyle(color: Colors.brown),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(255, 236, 158, 1.0),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child:FutureBuilder(
                  future: FirebaseFirestore.instance.collection("finalUser").doc(userId).collection("modules").get(),
                  builder:(context,snapshot)
                  {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {

                        var modId=snapshot.data!.docs[index].id;
                        var mod=snapshot.data!.docs;
                        if (mod.isEmpty) {
                          return Center(child: Text("No module added..."));
                        }
                        return InkWell(
                          onTap: (){
                            setState(() {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context)=>Listquestions(moduleId:modId)));},
                            );
                          },
                          child: Container(
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
                            child: Text(
                              snapshot.data!.docs[index].data()['m_name'],
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.pink[800],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    );}
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: qnumberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "no. of questions",
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pinkAccent),
                      )
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal[400],fixedSize: Size(150, 50)),
                    onPressed: () async {
                      final gen=Generate();
                      final input=qnumberController.text;
                      final int? num = int.tryParse(input);
                      List<Question> list = await dbService.generating_process(num!);
                      setState(()  {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizzApp(result: list),
                          ),
                        );
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context)=>GenerateSet(result:list)));
                      });
                    },
                    child: Text("Generate",style: TextStyle(color:Colors.white,fontSize: 14),)),
                    SizedBox(height: 10,)
              ],
            ),
          ],
        ),
    );
  }
}
