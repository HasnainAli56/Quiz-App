import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/models/user_model.dart';
import 'package:quiz_app/services/quiz_service.dart';
import 'package:quiz_app/screens/category_screen.dart';
import 'package:quiz_app/screens/quiz_history_screen.dart';
import 'package:quiz_app/utils/colors.dart';
import 'package:quiz_app/utils/text_styles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final QuizService _quizService = QuizService();
  Map<String, dynamic> _userStats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserStats();
  }

  Future<void> _loadUserStats() async {
    try {
      final stats = await _quizService.getUserStats();
      setState(() {
        _userStats = stats;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user stats: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Profile',
                        style: TextStyles.headline.copyWith(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        onPressed: _signOut,
                      ),
                    ],
                  ),
                ),
                
                // User Info Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.dividerColor.withOpacity(0.3), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _auth.currentUser?.displayName ?? 'Quiz Master',
                              style: TextStyles.headline.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              _auth.currentUser?.email ?? '',
                              style: TextStyles.subtitle.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Statistics Cards
                if (!_isLoading) ...[
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Total Quizzes',
                                '${_userStats['totalQuizzes'] ?? 0}',
                                Icons.quiz,
                                AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildStatCard(
                                'Average Score',
                                '${_userStats['averageScore']?.toStringAsFixed(1) ?? '0.0'}%',
                                Icons.trending_up,
                                AppColors.successColor,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 15),
                        
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Total Score',
                                '${_userStats['totalScore'] ?? 0}',
                                Icons.star,
                                AppColors.secondaryColor,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildStatCard(
                                'Best Category',
                                _userStats['bestCategory']?.toString().split('.').last ?? 'N/A',
                                Icons.emoji_events,
                                AppColors.accentColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
                
                const SizedBox(height: 30),
                
                // Action Buttons
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildActionButton(
                        'Start Quiz',
                        'Begin a new quiz challenge',
                        Icons.play_arrow,
                        AppColors.successColor,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CategoryScreen(),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 15),
                      
                      _buildActionButton(
                        'View History',
                        'See your quiz performance history',
                        Icons.history,
                        AppColors.primaryColor,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const QuizHistoryScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Recent Activity
                if (!_isLoading && (_userStats['totalQuizzes'] ?? 0) > 0) ...[
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recent Activity',
                          style: TextStyles.headline.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 15),
                        StreamBuilder<List<QuizScore>>(
                          stream: _quizService.getUserQuizHistory(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                              final recentQuizzes = snapshot.data!.take(3).toList();
                              return Column(
                                children: recentQuizzes.map((quiz) => _buildRecentQuizTile(quiz)).toList(),
                              );
                            }
                            return const Center(
                              child: Text('No recent quizzes'),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.dividerColor.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 30,
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyles.headline.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: TextStyles.subtitle.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
        ),
        child: Row(
          children: [
            Icon(icon, size: 30),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.headline.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyles.subtitle.copyWith(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.6)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentQuizTile(QuizScore quiz) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.dividerColor, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.getCategoryColorByName(quiz.category),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.quiz,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${quiz.category} - ${quiz.quizType}',
                  style: TextStyles.subtitle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Score: ${quiz.score}/${quiz.totalQuestions} (${quiz.percentage.toStringAsFixed(1)}%)',
                  style: TextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  _formatDate(quiz.completedAt),
                  style: TextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.check_circle,
            color: quiz.percentage >= 60 ? AppColors.successColor : AppColors.errorColor,
            size: 24,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
} 