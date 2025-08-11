import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      if (result.user != null) {
        await _createUserDocument(result.user!, displayName);
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      print('Attempting to sign in with email: $email');
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Sign in successful for user: ${result.user?.uid}');
      
      // Try to get user data to test Firestore connection
      try {
        final userData = await getUserData(result.user!.uid);
        print('User data retrieved successfully: ${userData?.displayName}');
      } catch (firestoreError) {
        print('Firestore error after sign in: $firestoreError');
        // Don't rethrow this error - user is still signed in
      }
      
      return result;
    } catch (e) {
      print('Sign in error: $e');
      print('Error type: ${e.runtimeType}');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Create user document in Firestore
  Future<void> _createUserDocument(User user, String? displayName) async {
    final userModel = UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: displayName,
      createdAt: DateTime.now(),
      quizScores: [],
    );

    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(userModel.toMap());
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Update user display name
  Future<void> updateDisplayName(String uid, String displayName) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .update({'displayName': displayName});
    } catch (e) {
      print('Error updating display name: $e');
      rethrow;
    }
  }

  // Add quiz score to user's record
  Future<void> addQuizScore(String uid, QuizScore quizScore) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .update({
        'quizScores': FieldValue.arrayUnion([quizScore.toMap()])
      });
    } catch (e) {
      print('Error adding quiz score: $e');
      rethrow;
    }
  }

  // Get user's quiz scores
  Future<List<QuizScore>> getUserQuizScores(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final scores = data['quizScores'] as List<dynamic>? ?? [];
        return scores.map((score) => QuizScore.fromMap(score)).toList();
      }
      return [];
    } catch (e) {
      print('Error getting quiz scores: $e');
      return [];
    }
  }

  // Get user's quiz scores by category
  Future<List<QuizScore>> getUserQuizScoresByCategory(String uid, String category) async {
    final allScores = await getUserQuizScores(uid);
    return allScores.where((score) => score.category == category).toList();
  }



  // Get user's average score
  Future<double> getUserAverageScore(String uid) async {
    final scores = await getUserQuizScores(uid);
    if (scores.isEmpty) return 0.0;
    
    final totalPercentage = scores.fold(0.0, (sum, score) => sum + score.percentage);
    return totalPercentage / scores.length;
  }

  // Get user's best score
  Future<QuizScore?> getUserBestScore(String uid) async {
    final scores = await getUserQuizScores(uid);
    if (scores.isEmpty) return null;
    
    scores.sort((a, b) => b.percentage.compareTo(a.percentage));
    return scores.first;
  }

  // Get user's total quizzes taken
  Future<int> getUserTotalQuizzes(String uid) async {
    final scores = await getUserQuizScores(uid);
    return scores.length;
  }
} 