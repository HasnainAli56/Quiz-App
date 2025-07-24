import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/screens/result_screen.dart';
import 'package:quiz_app/utils/colors.dart';
import 'package:quiz_app/utils/text_styles.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _questionIndex = 0;
  int _totalScore = 0;
  int _secondsRemaining = 60;
  Timer? _timer;
  final List<Question> _questions = Question.getQuestions();
  bool _isAnswered = false;
  int? _selectedAnswerIndex;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0 && !_isAnswered) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
        if (!_isAnswered) {
          _nextQuestion(0);
        }
      }
    });
  }

  void _answerQuestion(int score, int selectedIndex) {
    if (!_isAnswered) {
      setState(() {
        _isAnswered = true;
        _selectedAnswerIndex = selectedIndex;
        _totalScore += score;
      });
      _timer?.cancel();
      Future.delayed(const Duration(seconds: 1), () {
        _nextQuestion(score);
      });
    }
  }

  void _nextQuestion(int score) {
    setState(() {
      _questionIndex++;
      _isAnswered = false;
      _selectedAnswerIndex = null;
      _secondsRemaining = 60;
    });
    if (_questionIndex < _questions.length) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz', style: TextStyles.headline),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryColor, AppColors.secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: _questionIndex < _questions.length
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: _secondsRemaining / 60,
              backgroundColor: Colors.grey[300],
              color: _secondsRemaining > 10
                  ? AppColors.accentColor
                  : Colors.red,
            ),
            const SizedBox(height: 20),
            Text(
              'Question ${_questionIndex + 1}/${_questions.length}',
              style: TextStyles.subtitle.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              _questions[_questionIndex].questionText,
              style: TextStyles.headline.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ..._questions[_questionIndex].answers.asMap().entries.map(
                  (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isAnswered
                        ? (entry.key ==
                        _questions[_questionIndex]
                            .correctAnswerIndex
                        ? Colors.green
                        : (_selectedAnswerIndex == entry.key
                        ? Colors.red
                        : AppColors.buttonColor))
                        : AppColors.buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: _isAnswered
                      ? null
                      : () => _answerQuestion(
                    entry.value['score'],
                    entry.key,
                  ),
                  child: Text(
                    entry.value['text'],
                    style: TextStyles.body.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Time: $_secondsRemaining seconds',
              style: TextStyles.body.copyWith(color: Colors.white),
            ),
          ],
        )
            : Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultScreen(score: _totalScore),
                ),
              );
            },
            child: Text(
              'View Results',
              style: TextStyles.body.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}