enum QuizCategory {
  math,
  generalKnowledge,
  science,
  history,
}

enum DifficultyLevel {
  easy,
  medium,
  hard,
}

enum QuestionType {
  mcq,
  trueFalse,
}

class Question {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      question: map['question'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctAnswerIndex: map['correctAnswerIndex'] ?? 0,
    );
  }
}