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
