import 'Model/Question.dart';


class QuestionBrain {
  final List<Question> ques ;
  QuestionBrain({
    required this.ques
  });
  int _qcount=0;

  Question getQuestion()
  {
    return ques[_qcount];
  }
  void nextq(){
    if(_qcount<ques.length-1)
      _qcount++;
  }

  String getq() {
    return ques[_qcount].ques.toString();
  }

  String getOption(int ind)
  {
    return ques[_qcount].options[ind];
  }
  int getCorrectOption() {
    return ques[_qcount].correctOptionIndex;
  }

  int totalCount()
  {
    return ques.length;
  }
  int isfinished(){
    if(_qcount==ques.length-1)
      return 1;
    else
      return 0;
  }

}

