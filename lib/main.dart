import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'quiz_brain.dart';
import 'package:audioplayers/src/audio_cache.dart';

QuizBrain quizBrain = QuizBrain();

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Quizzler',style: TextStyle(fontSize: 20,fontFamily: 'Aclonica'),),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.volume_up_outlined,color: Colors.white38,size: 35,),
            ),
          ],
          backgroundColor: Colors.teal,
          shadowColor: Colors.greenAccent,
          elevation: 10,
        ),
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];

  int correctAns = 0;
  int questionNum = 1;
  String imgString ;
  String sortDesc ;
  void checkAnswer(bool userPickedAnswer) {
    bool correctAnswer = quizBrain.getCorrectAnswer();
    setState(() {
      questionNum++;
      if (userPickedAnswer == correctAnswer) {
        final player = AudioCache();
        player.play('correct.wav');
        scoreKeeper.add(Icon(
          Icons.check,
          color: Colors.green,
          size: 25,
        ));
        correctAns++;
      } else {
        final player = AudioCache();
        player.play('wrong.wav');
        scoreKeeper.add(Icon(
          Icons.close,
          color: Colors.red,
          size: 25,
        ));
      }
      if (quizBrain.isFinished()) {
        if(correctAns>6) {
          imgString = 'images/correct.png';
          sortDesc = 'Yeah!! You answered $correctAns question Correctly';
        }else{
          imgString = 'images/wrong.png';
          sortDesc = 'Oops!! You answered only $correctAns question Correctly';
        }
        Alert(
          context: context,
          title: "Accuracy : ${((correctAns.toDouble()/13.00)*100.0).toStringAsFixed(2)}%",
          desc: sortDesc,
          image: Image.asset(imgString),
          buttons: [
            DialogButton(
              child: Text(
                "Play Again",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              color: Color.fromRGBO(0, 179, 134, 1.0),
              radius: BorderRadius.circular(0.0),
            ),
          ],
        ).show();
        quizBrain.reset();
        scoreKeeper.clear();
        correctAns=0;
        questionNum=1;
      }
      quizBrain.nextQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.only(top: 80),
            child: Center(
              child: Text(
                'Statement Number : $questionNum',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'Aclonica',
                  color: Colors.purple,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.only(left: 15,top: 0,right: 15,bottom: 40),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.green,),
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                //The user picked true.
                checkAnswer(true);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.red,),
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                //The user picked false.
                checkAnswer(false);
              },
            ),
          ),
        ),

        Container(
          height: 30,
          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
          child: Row(
            children: scoreKeeper,
          ),
        )
      ],
    );
  }
}

/*
question1: 'You can lead a cow down stairs but not up stairs.', false,
question2: 'Approximately one quarter of human bones are in the feet.', true,
question3: 'A slug\'s blood is green.', true,
*/