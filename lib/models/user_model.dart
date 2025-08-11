import 'question.dart';

class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final DateTime createdAt;
  final List<QuizScore> quizScores;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    required this.createdAt,
    this.quizScores = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'createdAt': createdAt.toIso8601String(),
      'quizScores': quizScores.map((score) => score.toMap()).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'],
      createdAt: DateTime.parse(map['createdAt']),
      quizScores: List<QuizScore>.from(
        map['quizScores']?.map((x) => QuizScore.fromMap(x)) ?? [],
      ),
    );
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    DateTime? createdAt,
    List<QuizScore>? quizScores,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      quizScores: quizScores ?? this.quizScores,
    );
  }
}

class QuizScore {
  final String id;
  final String category;
  final String quizType;
  final int score;
  final int totalQuestions;
  final double percentage;
  final List<Question> questions;
  final Duration timeTaken;
  final DateTime completedAt;

  QuizScore({
    required this.id,
    required this.category,
    required this.quizType,
    required this.score,
    required this.totalQuestions,
    required this.percentage,
    required this.questions,
    required this.timeTaken,
    required this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'quizType': quizType,
      'score': score,
      'totalQuestions': totalQuestions,
      'percentage': percentage,
      'questions': questions.map((q) => q.toMap()).toList(),
      'timeTaken': timeTaken.inSeconds,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  factory QuizScore.fromMap(Map<String, dynamic> map) {
    return QuizScore(
      id: map['id'] ?? '',
      category: map['category'] ?? '',
      quizType: map['quizType'] ?? 'MCQs',
      score: map['score']?.toInt() ?? 0,
      totalQuestions: map['totalQuestions']?.toInt() ?? 0,
      percentage: map['percentage']?.toDouble() ?? 0.0,
      questions: List<Question>.from(
        map['questions']?.map((x) => Question.fromMap(x)) ?? [],
      ),
      timeTaken: Duration(seconds: map['timeTaken'] ?? 0),
      completedAt: DateTime.parse(map['completedAt']),
    );
  }
} 