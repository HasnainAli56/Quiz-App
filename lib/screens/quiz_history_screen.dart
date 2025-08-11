import 'package:flutter/material.dart';
import 'package:quiz_app/models/user_model.dart';
import 'package:quiz_app/services/quiz_service.dart';
import 'package:quiz_app/utils/colors.dart';
import 'package:quiz_app/utils/text_styles.dart';

class QuizHistoryScreen extends StatefulWidget {
  const QuizHistoryScreen({Key? key}) : super(key: key);

  @override
  _QuizHistoryScreenState createState() => _QuizHistoryScreenState();
}

class _QuizHistoryScreenState extends State<QuizHistoryScreen> {
  final QuizService _quizService = QuizService();
  String _selectedCategory = 'All';
  String _selectedQuizType = 'All';
  
  final List<String> _categories = ['All', 'Math', 'General Knowledge', 'Science', 'History'];
  final List<String> _quizTypes = ['All', 'MCQs', 'True/False'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Quiz History',
                      style: TextStyles.headline.copyWith(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Filters
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
                      'Filters',
                      style: TextStyles.headline.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: _buildFilterDropdown(
                            'Category',
                            _selectedCategory,
                            _categories,
                            (value) {
                              setState(() {
                                _selectedCategory = value!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildFilterDropdown(
                            'Quiz Type',
                            _selectedQuizType,
                            _quizTypes,
                            (value) {
                              setState(() {
                                _selectedQuizType = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Quiz History List
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: StreamBuilder<List<QuizScore>>(
                    stream: _getFilteredQuizHistory(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentColor),
                          ),
                        );
                      }
                      
                      if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.white,
                                size: 60,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Error loading quiz history',
                                style: TextStyles.headline.copyWith(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.history,
                                color: Colors.white.withOpacity(0.7),
                                size: 80,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'No quiz history found',
                                style: TextStyles.headline.copyWith(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Complete your first quiz to see your history here!',
                                style: TextStyles.subtitle.copyWith(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }
                      
                      final quizScores = snapshot.data!;
                      
                      return ListView.builder(
                        itemCount: quizScores.length,
                        itemBuilder: (context, index) {
                          final quiz = quizScores[index];
                          return _buildQuizHistoryCard(quiz, index);
                        },
                      );
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterDropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyles.subtitle.copyWith(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.dividerColor, width: 1.5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyles.subtitle.copyWith(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuizHistoryCard(QuizScore quiz, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
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
          // Header with category and score
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.getCategoryColorByName(quiz.category).withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.getCategoryColorByName(quiz.category),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    quiz.quizType == 'MCQs' ? Icons.quiz : Icons.check_circle,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quiz.category,
                        style: TextStyles.headline.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${quiz.quizType} Quiz',
                        style: TextStyles.subtitle.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${quiz.percentage.toStringAsFixed(1)}%',
                      style: TextStyles.headline.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _getScoreColor(quiz.percentage),
                      ),
                    ),
                    Text(
                      '${quiz.score}/${quiz.totalQuestions}',
                      style: TextStyles.subtitle.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Quiz details
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildDetailItem(
                      Icons.timer,
                      'Time Taken',
                      _formatDuration(quiz.timeTaken),
                    ),
                    const Spacer(),
                    _buildDetailItem(
                      Icons.calendar_today,
                      'Completed',
                      _formatDate(quiz.completedAt),
                    ),
                  ],
                ),
                
                const SizedBox(height: 15),
                
                // Performance indicator
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: _getScoreColor(quiz.percentage).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _getScoreColor(quiz.percentage).withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getPerformanceIcon(quiz.percentage),
                        color: _getScoreColor(quiz.percentage),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _getPerformanceMessage(quiz.percentage),
                          style: TextStyles.subtitle.copyWith(
                            color: _getScoreColor(quiz.percentage),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.textSecondary,
          size: 18,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyles.subtitle.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            Text(
              value,
              style: TextStyles.subtitle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return AppColors.successColor;
    if (percentage >= 60) return AppColors.warningColor;
    return AppColors.errorColor;
  }

  IconData _getPerformanceIcon(double percentage) {
    if (percentage >= 80) return Icons.emoji_events;
    if (percentage >= 60) return Icons.thumb_up;
    return Icons.trending_down;
  }

  String _getPerformanceMessage(double percentage) {
    if (percentage >= 80) return 'Excellent! Keep up the great work!';
    if (percentage >= 60) return 'Good job! You can do even better!';
    return 'Keep practicing to improve your score!';
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${seconds}s';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today at ${_formatTime(date)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday at ${_formatTime(date)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Stream<List<QuizScore>> _getFilteredQuizHistory() {
    if (_selectedCategory == 'All' && _selectedQuizType == 'All') {
      return _quizService.getUserQuizHistory();
    } else if (_selectedCategory != 'All' && _selectedQuizType == 'All') {
      return _quizService.getUserQuizHistoryByCategory(_selectedCategory);
    } else if (_selectedCategory == 'All' && _selectedQuizType != 'All') {
      return _quizService.getUserQuizHistory().map((quizzes) {
        return quizzes.where((quiz) => quiz.quizType == _selectedQuizType).toList();
      });
    } else {
      return _quizService.getUserQuizHistoryByCategory(_selectedCategory).map((quizzes) {
        return quizzes.where((quiz) => quiz.quizType == _selectedQuizType).toList();
      });
    }
  }
} 