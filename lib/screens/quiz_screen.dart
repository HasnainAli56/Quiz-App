import 'package:flutter/material.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/screens/result_screen.dart';
import 'package:quiz_app/services/quiz_service.dart';
import 'package:quiz_app/utils/colors.dart';
import 'package:quiz_app/utils/text_styles.dart';
import 'package:quiz_app/screens/category_screen.dart';
import 'dart:async';

enum QuizType {
  mcqs,
  trueFalse,
}

class QuizScreen extends StatefulWidget {
  final Category category;
  final QuizType quizType;

  const QuizScreen({
    Key? key,
    required this.category,
    required this.quizType,
  }) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  final QuizService _quizService = QuizService();
  
  late AnimationController _questionAnimationController;
  late Animation<double> _questionFadeAnimation;
  late Animation<Offset> _questionSlideAnimation;
  
  late AnimationController _timerAnimationController;
  late Animation<double> _timerAnimation;
  
  List<Question> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  bool isAnswered = false;
  int? selectedAnswerIndex;
  Timer? _timer;
  int _timeLeft = 30; // 30 seconds per question
  DateTime _startTime = DateTime.now();
  Duration _totalTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadQuestions();
    _startTimer();
  }

  void _initializeAnimations() {
    _questionAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _questionFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _questionAnimationController,
      curve: Curves.easeIn,
    ));
    
    _questionSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _questionAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _timerAnimationController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    );
    
    _timerAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _timerAnimationController,
      curve: Curves.linear,
    ));
  }

  void _loadQuestions() {
    // Load questions based on category and quiz type
    if (widget.quizType == QuizType.trueFalse) {
      questions = _getTrueFalseQuestionsForCategory(widget.category.name);
    } else {
      questions = _getQuestionsForCategory(widget.category.name);
    }
    _questionAnimationController.forward();
    _timerAnimationController.forward();
  }

  List<Question> _getQuestionsForCategory(String categoryName) {
    // This would typically come from a database or API
    // For now, we'll create sample questions
    switch (categoryName) {
      case 'Math':
        return [
          Question(
            question: 'What is 15 + 27?',
            options: ['40', '42', '43', '41'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'What is 8 × 9?',
            options: ['72', '71', '73', '70'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'What is the square root of 64?',
            options: ['6', '7', '8', '9'],
            correctAnswerIndex: 2,
          ),
          Question(
            question: 'What is 100 ÷ 4?',
            options: ['20', '25', '30', '15'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'What is 3² + 4²?',
            options: ['25', '24', '26', '23'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'What is 50% of 80?',
            options: ['30', '40', '50', '60'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'What is the next number in the sequence: 2, 4, 8, 16, __?',
            options: ['24', '32', '30', '28'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'What is 7! (7 factorial)?',
            options: ['5040', '40320', '720', '120'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'What is the area of a circle with radius 5?',
            options: ['25π', '50π', '75π', '100π'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'What is log₁₀(100)?',
            options: ['1', '2', '10', '100'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'What is the slope of the line y = 2x + 3?',
            options: ['2', '3', '5', '1'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'What is the value of π (pi) to 2 decimal places?',
            options: ['3.12', '3.14', '3.16', '3.18'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'What is 2³ × 3²?',
            options: ['36', '72', '108', '144'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'What is the perimeter of a square with side length 6?',
            options: ['12', '18', '24', '36'],
            correctAnswerIndex: 2,
          ),
          Question(
            question: 'What is the sum of angles in a triangle?',
            options: ['90°', '180°', '270°', '360°'],
            correctAnswerIndex: 1,
          ),
        ];
      case 'General Knowledge':
        return [
          Question(
            question: 'What is the capital of France?',
            options: ['London', 'Berlin', 'Paris', 'Madrid'],
            correctAnswerIndex: 2,
          ),
          Question(
            question: 'Which planet is known as the Red Planet?',
            options: ['Venus', 'Mars', 'Jupiter', 'Saturn'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'Who painted the Mona Lisa?',
            options: ['Van Gogh', 'Da Vinci', 'Picasso', 'Rembrandt'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'What is the largest ocean on Earth?',
            options: ['Atlantic', 'Indian', 'Arctic', 'Pacific'],
            correctAnswerIndex: 3,
          ),
          Question(
            question: 'Which year did World War II end?',
            options: ['1943', '1944', '1945', '1946'],
            correctAnswerIndex: 2,
          ),
          Question(
            question: 'What is the currency of Japan?',
            options: ['Yuan', 'Won', 'Yen', 'Ringgit'],
            correctAnswerIndex: 2,
          ),
          Question(
            question: 'Who wrote "Romeo and Juliet"?',
            options: ['Charles Dickens', 'William Shakespeare', 'Jane Austen', 'Mark Twain'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'What is the largest mammal in the world?',
            options: ['African Elephant', 'Blue Whale', 'Giraffe', 'Hippopotamus'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'What is the main ingredient in guacamole?',
            options: ['Tomato', 'Avocado', 'Onion', 'Lime'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'Which country is home to the kangaroo?',
            options: ['New Zealand', 'South Africa', 'Australia', 'India'],
            correctAnswerIndex: 2,
          ),
          Question(
            question: 'What is the largest desert in the world?',
            options: ['Sahara', 'Arabian', 'Gobi', 'Antarctic'],
            correctAnswerIndex: 3,
          ),
          Question(
            question: 'Who is the current President of the United States?',
            options: ['Donald Trump', 'Joe Biden', 'Barack Obama', 'George W. Bush'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'What is the national flower of Japan?',
            options: ['Cherry Blossom', 'Rose', 'Lotus', 'Tulip'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'Which element has the chemical symbol "O"?',
            options: ['Osmium', 'Oxygen', 'Oganesson', 'Osmium'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'What is the largest island in the world?',
            options: ['Greenland', 'Australia', 'Borneo', 'Madagascar'],
            correctAnswerIndex: 0,
          ),
        ];
      case 'Science':
        return [
          Question(
            question: 'What is the chemical symbol for gold?',
            options: ['Ag', 'Au', 'Fe', 'Cu'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'What is the hardest natural substance on Earth?',
            options: ['Steel', 'Iron', 'Diamond', 'Platinum'],
            correctAnswerIndex: 2,
          ),
          Question(
            question: 'What is the largest organ in the human body?',
            options: ['Heart', 'Brain', 'Liver', 'Skin'],
            correctAnswerIndex: 3,
          ),
          Question(
            question: 'What is the speed of light?',
            options: ['299,792 km/s', '199,792 km/s', '399,792 km/s', '499,792 km/s'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'What is the atomic number of carbon?',
            options: ['4', '5', '6', '7'],
            correctAnswerIndex: 2,
          ),
          Question(
            question: 'What is the process by which plants make their own food?',
            options: ['Respiration', 'Photosynthesis', 'Digestion', 'Fermentation'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'What is the main gas that makes up Earth\'s atmosphere?',
            options: ['Oxygen', 'Carbon Dioxide', 'Nitrogen', 'Hydrogen'],
            correctAnswerIndex: 2,
          ),
          Question(
            question: 'What is the smallest unit of life?',
            options: ['Atom', 'Molecule', 'Cell', 'Tissue'],
            correctAnswerIndex: 2,
          ),
          Question(
            question: 'What is the force that pulls objects toward Earth?',
            options: ['Magnetism', 'Gravity', 'Friction', 'Tension'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'What is the study of fossils called?',
            options: ['Archaeology', 'Paleontology', 'Geology', 'Biology'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'What is the chemical formula for water?',
            options: ['H2O', 'CO2', 'O2', 'N2'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'What is the largest planet in our solar system?',
            options: ['Saturn', 'Jupiter', 'Neptune', 'Uranus'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'What is the process of cell division called?',
            options: ['Mitosis', 'Meiosis', 'Fission', 'Fusion'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'What is the unit of measurement for force?',
            options: ['Watt', 'Joule', 'Newton', 'Pascal'],
            correctAnswerIndex: 2,
          ),
          Question(
            question: 'What is the study of weather called?',
            options: ['Meteorology', 'Climatology', 'Atmospheric Science', 'Weather Science'],
            correctAnswerIndex: 0,
          ),
        ];
      case 'History':
        return [
          Question(
            question: 'Who was the first President of the United States?',
            options: ['John Adams', 'Thomas Jefferson', 'George Washington', 'Benjamin Franklin'],
            correctAnswerIndex: 2,
          ),
          Question(
            question: 'In which year did Columbus discover America?',
            options: ['1492', '1493', '1494', '1495'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'Which empire was ruled by the Aztecs?',
            options: ['Mexican', 'Incan', 'Mayan', 'Aztec'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'What year did World War I begin?',
            options: ['1914', '1915', '1916', '1917'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'Who was the first Emperor of Rome?',
            options: ['Julius Caesar', 'Augustus', 'Nero', 'Caligula'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'What year did the Berlin Wall fall?',
            options: ['1987', '1988', '1989', '1990'],
            correctAnswerIndex: 2,
          ),
          Question(
            question: 'Who was the first female Prime Minister of the UK?',
            options: ['Margaret Thatcher', 'Theresa May', 'Liz Truss', 'Queen Elizabeth'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'What year did the Titanic sink?',
            options: ['1910', '1911', '1912', '1913'],
            correctAnswerIndex: 2,
          ),
          Question(
            question: 'Who was the first Emperor of China?',
            options: ['Qin Shi Huang', 'Han Wudi', 'Tang Taizong', 'Song Taizu'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'What year did the French Revolution begin?',
            options: ['1787', '1788', '1789', '1790'],
            correctAnswerIndex: 2,
          ),
          Question(
            question: 'Who was the first female astronaut?',
            options: ['Sally Ride', 'Valentina Tereshkova', 'Mae Jemison', 'Eileen Collins'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'What year did India gain independence from Britain?',
            options: ['1945', '1946', '1947', '1948'],
            correctAnswerIndex: 2,
          ),
          Question(
            question: 'Who was the first person to walk on the moon?',
            options: ['Neil Armstrong', 'Buzz Aldrin', 'Yuri Gagarin', 'Alan Shepard'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'What year did the Cold War end?',
            options: ['1989', '1990', '1991', '1992'],
            correctAnswerIndex: 2,
          ),
          Question(
            question: 'Who was the first female Nobel Prize winner?',
            options: ['Marie Curie', 'Mother Teresa', 'Jane Addams', 'Pearl S. Buck'],
            correctAnswerIndex: 0,
          ),
        ];
      default:
        return [
          Question(
            question: 'Sample Question?',
            options: ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
            correctAnswerIndex: 0,
          ),
        ];
    }
  }

  List<Question> _getTrueFalseQuestionsForCategory(String categoryName) {
    // True/False questions for each category
    switch (categoryName) {
      case 'Math':
        return [
          Question(
            question: 'The square root of 16 is 4.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'Pi (π) is exactly equal to 3.14.',
            options: ['True', 'False'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'A triangle can have more than 180 degrees total.',
            options: ['True', 'False'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'Zero is an even number.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'The sum of two odd numbers is always even.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'All prime numbers are odd.',
            options: ['True', 'False'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'A circle has infinite sides.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'The area of a circle is πr².',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'Negative numbers can be square roots.',
            options: ['True', 'False'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'The number 1 is a prime number.',
            options: ['True', 'False'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'Fractions can be greater than 1.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'A rectangle is always a square.',
            options: ['True', 'False'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'The perimeter of a circle is called circumference.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'All even numbers are divisible by 2.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'The sum of angles in a quadrilateral is 360 degrees.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
        ];
      case 'General Knowledge':
        return [
          Question(
            question: 'The capital of Australia is Sydney.',
            options: ['True', 'False'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'The Great Wall of China is visible from space.',
            options: ['True', 'False'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'Bananas are berries.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'The human body has 206 bones.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'The Earth is the third planet from the Sun.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'The currency of Japan is the Yuan.',
            options: ['True', 'False'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'Shakespeare wrote Romeo and Juliet.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'The largest ocean on Earth is the Atlantic.',
            options: ['True', 'False'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'Penguins can fly.',
            options: ['True', 'False'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'The human heart has four chambers.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'The Sun is a star.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'Mount Everest is the tallest mountain in the world.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'The Nile is the longest river in the world.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'The Great Barrier Reef is in Australia.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'The human brain uses 10% of its capacity.',
            options: ['True', 'False'],
            correctAnswerIndex: 1,
          ),
        ];
      case 'Science':
        return [
          Question(
            question: 'Water boils at 100°C at sea level.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'The chemical symbol for gold is Au.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'Light travels faster than sound.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'The human body is made up of 70% water.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'Plants produce oxygen during photosynthesis.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'The Earth revolves around the Moon.',
            options: ['True', 'False'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'Atoms are the smallest unit of matter.',
            options: ['True', 'False'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'Gravity is a force that pulls objects toward Earth.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'The speed of light is 299,792 km/s.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'DNA stands for Deoxyribonucleic Acid.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'The human skeleton is made of 206 bones.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'The Sun is a planet.',
            options: ['True', 'False'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'Electricity flows from positive to negative.',
            options: ['True', 'False'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'The human eye can see ultraviolet light.',
            options: ['True', 'False'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'The Earth\'s core is made of molten iron.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
        ];
      case 'History':
        return [
          Question(
            question: 'World War II ended in 1945.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'Christopher Columbus discovered America in 1492.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'The first President of the United States was George Washington.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'The Titanic sank on its maiden voyage.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'The French Revolution began in 1789.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'The Berlin Wall fell in 1989.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'The first moon landing was in 1969.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'The Roman Empire fell in 476 AD.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'The Declaration of Independence was signed in 1776.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'The Cold War ended in 1991.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'The first female astronaut was Sally Ride.',
            options: ['True', 'False'],
            correctAnswerIndex: 1,
          ),
          Question(
            question: 'India gained independence from Britain in 1947.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'The first Emperor of China was Qin Shi Huang.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'The first female Prime Minister of the UK was Margaret Thatcher.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
          Question(
            question: 'The first Nobel Prize was awarded in 1901.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
        ];
      default:
        return [
          Question(
            question: 'Sample True/False Question?',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
          ),
        ];
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
      } else {
        _timer?.cancel();
          _nextQuestion();
        }
      });
    });
  }

  void _selectAnswer(int answerIndex) {
    if (isAnswered) return;

      setState(() {
      selectedAnswerIndex = answerIndex;
      isAnswered = true;
    });

    if (answerIndex == questions[currentQuestionIndex].correctAnswerIndex) {
      score++;
    }

    _timer?.cancel();
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
    setState(() {
        currentQuestionIndex++;
        isAnswered = false;
        selectedAnswerIndex = null;
        _timeLeft = 30;
      });
      
      _questionAnimationController.reset();
      _questionAnimationController.forward();
      
      _timerAnimationController.reset();
      _timerAnimationController.forward();
      
      _startTimer();
    } else {
      _finishQuiz();
    }
  }

  Future<void> _finishQuiz() async {
    _totalTime = DateTime.now().difference(_startTime);
    
    try {
      // Save quiz score to Firebase
      await _quizService.saveQuizScore(
        category: widget.category.name,
        quizType: widget.quizType == QuizType.mcqs ? 'MCQs' : 'True/False',
        score: score,
        totalQuestions: questions.length,
        questions: questions,
        timeTaken: _totalTime,
      );
    } catch (e) {
      // Handle error silently for now
      print('Failed to save quiz score: $e');
    }

    if (mounted) {
              Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
            score: score,
            totalQuestions: questions.length,
            category: widget.category.name,
            timeTaken: _totalTime,
          ),
          ),
        );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _questionAnimationController.dispose();
    _timerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final currentQuestion = questions[currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / questions.length;
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with Progress
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                              Text(
                          '${currentQuestionIndex + 1}/${questions.length}',
                                style: TextStyles.headline.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Score: $score',
                          style: TextStyles.headline.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
            ),
            const SizedBox(height: 20),
                    
                    // Progress Bar
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentColor),
                      minHeight: 8,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Timer
                    AnimatedBuilder(
                      animation: _timerAnimation,
                      builder: (context, child) {
                        return Container(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(
                            value: _timerAnimation.value,
                            backgroundColor: Colors.white.withOpacity(0.3),
                            valueColor: _timeLeft <= 10 
                                ? const AlwaysStoppedAnimation<Color>(Colors.red)
                                : const AlwaysStoppedAnimation<Color>(AppColors.accentColor),
                            strokeWidth: 6,
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 10),
                    
            Text(
                      '$_timeLeft s',
                      style: TextStyles.subtitle.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),

              // Question
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: FadeTransition(
                    opacity: _questionFadeAnimation,
                    child: SlideTransition(
                      position: _questionSlideAnimation,
                  child: Padding(
                        padding: const EdgeInsets.all(24),
                    child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                            Text(
                              'Question ${currentQuestionIndex + 1}',
                              style: TextStyles.subtitle.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              currentQuestion.question,
                            style: TextStyles.headline.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        const SizedBox(height: 30),

                            // Options
                        Expanded(
                          child: ListView.builder(
                                itemCount: currentQuestion.options.length,
                            itemBuilder: (context, index) {
                                  final option = currentQuestion.options[index];
                              final isCorrect = index == currentQuestion.correctAnswerIndex;
                                  final isSelected = selectedAnswerIndex == index;
                                  
                                  Color backgroundColor = AppColors.surfaceColor;
                                  Color borderColor = AppColors.dividerColor;
                              
                                  if (isAnswered) {
                                    if (isCorrect) {
                                      backgroundColor = AppColors.successColor.withOpacity(0.15);
                                      borderColor = AppColors.successColor;
                                    } else if (isSelected && !isCorrect) {
                                      backgroundColor = AppColors.errorColor.withOpacity(0.15);
                                      borderColor = AppColors.errorColor;
                                    }
                                  } else if (isSelected) {
                                    backgroundColor = AppColors.primaryColor.withOpacity(0.15);
                                    borderColor = AppColors.primaryColor;
                                  }

                                  return GestureDetector(
                                    onTap: () => _selectAnswer(index),
                                    child: Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: backgroundColor,
                                      borderRadius: BorderRadius.circular(15),
                                        border: Border.all(color: borderColor, width: 2),
                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: isSelected ? AppColors.primaryColor : AppColors.dividerColor,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: isSelected
                                            ? const Icon(Icons.check, color: Colors.white, size: 16)
                                            : null,
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Text(
                                              option,
                                          style: TextStyles.body.copyWith(
                                                color: AppColors.textPrimary,
                                            fontSize: 16,
                                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                          if (isAnswered && isCorrect)
                                            Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                              size: 24,
                                      ),
                                    ],
                                  ),
                ),
              );
            },
                              ),
                          ),
                      ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}