import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/models/user_model.dart';

class QuizService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Save quiz score to Firebase
  Future<void> saveQuizScore({
    required String category,
    required String quizType,
    required int score,
    required int totalQuestions,
    required List<Question> questions,
    required Duration timeTaken,
  }) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    final quizScore = QuizScore(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      category: category,
      quizType: quizType,
      score: score,
      totalQuestions: totalQuestions,
      percentage: (score / totalQuestions) * 100,
      questions: questions,
      timeTaken: timeTaken,
      completedAt: DateTime.now(),
    );

    try {
      // Check if user document exists, if not create it
      final userDoc = await _firestore.collection('users').doc(currentUserId).get();
      
      if (!userDoc.exists) {
        // Create user document with initial data
        await _firestore.collection('users').doc(currentUserId).set({
          'uid': currentUserId,
          'email': _auth.currentUser?.email,
          'displayName': _auth.currentUser?.displayName,
          'createdAt': FieldValue.serverTimestamp(),
          'quizScores': [quizScore.toMap()],
          'totalQuizzes': 1,
          'totalScore': score,
          'totalQuestions': totalQuestions,
          'lastQuizDate': FieldValue.serverTimestamp(),
        });
      } else {
        // Update existing user document
        await _firestore
            .collection('users')
            .doc(currentUserId)
            .update({
          'quizScores': FieldValue.arrayUnion([quizScore.toMap()]),
          'totalQuizzes': FieldValue.increment(1),
          'totalScore': FieldValue.increment(score),
          'totalQuestions': FieldValue.increment(totalQuestions),
          'lastQuizDate': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      throw Exception('Failed to save quiz score: $e');
    }
  }

  // Get user's quiz history
  Stream<List<QuizScore>> getUserQuizHistory() {
    if (currentUserId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(currentUserId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return [];
      
      final data = snapshot.data() as Map<String, dynamic>;
      final scores = data['quizScores'] as List<dynamic>? ?? [];
      
      // Convert to QuizScore objects and sort by completion date
      final quizScores = scores
          .map((score) => QuizScore.fromMap(score))
          .toList();
      
      quizScores.sort((a, b) => b.completedAt.compareTo(a.completedAt));
      return quizScores;
    });
  }

  // Get user's quiz history by category
  Stream<List<QuizScore>> getUserQuizHistoryByCategory(String category) {
    if (currentUserId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(currentUserId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return [];
      
      final data = snapshot.data() as Map<String, dynamic>;
      final scores = data['quizScores'] as List<dynamic>? ?? [];
      
      // Filter by category and sort by completion date
      final quizScores = scores
          .map((score) => QuizScore.fromMap(score))
          .where((score) => score.category == category)
          .toList();
      
      quizScores.sort((a, b) => b.completedAt.compareTo(a.completedAt));
      return quizScores;
    });
  }

  // Get user's statistics
  Future<Map<String, dynamic>> getUserStats() async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    try {
      final userDoc = await _firestore
          .collection('users')
          .doc(currentUserId)
          .get();

      if (!userDoc.exists) {
        return {
          'totalQuizzes': 0,
          'totalScore': 0,
          'totalQuestions': 0,
          'averageScore': 0.0,
          'bestCategory': '',
          'bestScore': 0,
        };
      }

      final data = userDoc.data()!;
      final totalQuizzes = data['totalQuizzes'] ?? 0;
      final totalScore = data['totalScore'] ?? 0;
      final totalQuestions = data['totalQuestions'] ?? 0;

      // Get best category and score from the quizScores array
      final quizScores = data['quizScores'] as List<dynamic>? ?? [];
      String bestCategory = '';
      int bestScore = 0;
      double bestPercentage = 0.0;

      for (final score in quizScores) {
        final percentage = score['percentage']?.toDouble() ?? 0.0;
        if (percentage > bestPercentage) {
          bestPercentage = percentage;
          bestCategory = score['category'] ?? '';
          bestScore = score['score'] ?? 0;
        }
      }

      return {
        'totalQuizzes': totalQuizzes,
        'totalScore': totalScore,
        'totalQuestions': totalQuestions,
        'averageScore': totalQuizzes > 0 ? (totalScore / totalQuizzes).roundToDouble() : 0.0,
        'bestCategory': bestCategory,
        'bestScore': bestScore,
      };
    } catch (e) {
      throw Exception('Failed to get user stats: $e');
    }
  }

  // Get leaderboard for a specific category
  Future<List<Map<String, dynamic>>> getCategoryLeaderboard(String category) async {
    try {
      final querySnapshot = await _firestore
          .collectionGroup('quizScores')
          .where('category', isEqualTo: category)
          .orderBy('percentage', descending: true)
          .orderBy('timeTaken', descending: false)
          .limit(10)
          .get();

      final List<Map<String, dynamic>> leaderboard = [];

      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        final userId = doc.reference.parent.parent?.id;
        
        if (userId != null) {
          // Get user info
          final userDoc = await _firestore.collection('users').doc(userId).get();
          final userData = userDoc.data();
          
          leaderboard.add({
            'userId': userId,
            'displayName': userData?['displayName'] ?? 'Anonymous',
            'score': data['score'],
            'totalQuestions': data['totalQuestions'],
            'percentage': data['percentage'],
            'timeTaken': data['timeTaken'],
            'completedAt': data['completedAt'],
          });
        }
      }

      return leaderboard;
    } catch (e) {
      throw Exception('Failed to get leaderboard: $e');
    }
  }

  // Delete a quiz score
  Future<void> deleteQuizScore(String scoreId) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('quizScores')
          .doc(scoreId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete quiz score: $e');
    }
  }

  // Clear all quiz history
  Future<void> clearQuizHistory() async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    try {
      final batch = _firestore.batch();
      final scoresQuery = await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('quizScores')
          .get();

      for (final doc in scoresQuery.docs) {
        batch.delete(doc.reference);
      }

      // Reset user stats
      batch.update(
        _firestore.collection('users').doc(currentUserId),
        {
          'totalQuizzes': 0,
          'totalScore': 0,
          'totalQuestions': 0,
          'lastQuizDate': null,
        },
      );

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to clear quiz history: $e');
    }
  }
} 