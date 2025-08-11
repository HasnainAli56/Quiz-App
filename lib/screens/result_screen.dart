import 'package:flutter/material.dart';
import 'package:quiz_app/screens/profile_screen.dart';
import 'package:quiz_app/utils/colors.dart';
import 'package:quiz_app/utils/text_styles.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final String category;
  final Duration timeTaken;

  const ResultScreen({
    Key? key,
    required this.score,
    required this.totalQuestions,
    required this.category,
    required this.timeTaken,
  }) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scoreAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _scoreAnimation = Tween<double>(
      begin: 0,
      end: widget.score.toDouble(),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _progressAnimation = Tween<double>(
      begin: 0,
      end: widget.score / widget.totalQuestions,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String get resultPhrase {
    final percentage = (widget.score / widget.totalQuestions) * 100;
    if (percentage >= 90) {
      return 'Outstanding!';
    } else if (percentage >= 80) {
      return 'Excellent!';
    } else if (percentage >= 70) {
      return 'Great Job!';
    } else if (percentage >= 60) {
      return 'Good Work!';
    } else if (percentage >= 50) {
      return 'Not Bad!';
    } else if (percentage >= 40) {
      return 'Keep Practicing!';
    } else {
      return 'Need More Practice!';
    }
  }

  Color get resultColor {
    final percentage = (widget.score / widget.totalQuestions) * 100;
    if (percentage >= 80) {
      return AppColors.success;
    } else if (percentage >= 60) {
      return AppColors.warning;
    } else {
      return AppColors.error;
    }
  }

  String _getCategoryName(String category) {
    return category;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.getCategoryColorByName(widget.category),
              AppColors.getCategoryColorByName(widget.category).withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
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
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Quiz Results',
                            style: TextStyles.headline.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${_getCategoryName(widget.category)}',
                            style: TextStyles.subtitle.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          Text(
                            'Time: ${widget.timeTaken.inMinutes}:${(widget.timeTaken.inSeconds % 60).toString().padLeft(2, '0')}',
                            style: TextStyles.subtitle.copyWith(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Results Content
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Score Display
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  resultColor,
                                  resultColor.withOpacity(0.7),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: resultColor.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                AnimatedBuilder(
                                  animation: _scoreAnimation,
                                  builder: (context, child) {
                                    return Text(
                                      '${_scoreAnimation.value.toInt()}',
                                      style: TextStyles.headline.copyWith(
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ),
                                Text(
                                  'out of ${widget.totalQuestions}',
                                  style: TextStyles.subtitle.copyWith(
                                    fontSize: 18,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                AnimatedBuilder(
                                  animation: _progressAnimation,
                                  builder: (context, child) {
                                    return Text(
                                      '${(_progressAnimation.value * 100).toInt()}%',
                                      style: TextStyles.headline.copyWith(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Result Message
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.cardColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.dividerColor.withOpacity(0.3), width: 1),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  _getResultIcon(),
                                  size: 50,
                                  color: resultColor,
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  resultPhrase,
                                  style: TextStyles.headline.copyWith(
                                    color: AppColors.textPrimary,
                                    fontSize: 24,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  _getResultMessage(),
                                  style: TextStyles.body.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Statistics
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  'Correct',
                                  widget.score,
                                  AppColors.success,
                                  Icons.check_circle,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: _buildStatCard(
                                  'Incorrect',
                                  widget.totalQuestions - widget.score,
                                  AppColors.error,
                                  Icons.cancel,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.cardColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                  ),
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const ProfileScreen(),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  child: Text(
                                    'New Quiz',
                                    style: TextStyles.body.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: resultColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Try Again',
                                    style: TextStyles.body.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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

  Widget _buildStatCard(String title, int value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.dividerColor.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 10),
          Text(
            value.toString(),
            style: TextStyles.headline.copyWith(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getResultIcon() {
    final percentage = (widget.score / widget.totalQuestions) * 100;
    if (percentage >= 80) {
      return Icons.emoji_events;
    } else if (percentage >= 60) {
      return Icons.thumb_up;
    } else {
      return Icons.school;
    }
  }

  String _getResultMessage() {
    final percentage = (widget.score / widget.totalQuestions) * 100;
    if (percentage >= 90) {
      return 'You are a master of this topic!';
    } else if (percentage >= 80) {
      return 'Excellent performance! Keep it up!';
    } else if (percentage >= 70) {
      return 'Great job! You have a solid understanding.';
    } else if (percentage >= 60) {
      return 'Good work! A bit more practice will help.';
    } else if (percentage >= 50) {
      return 'Not bad! Review the material and try again.';
    } else if (percentage >= 40) {
      return 'Keep practicing! You\'ll improve with time.';
    } else {
      return 'Don\'t give up! Practice makes perfect.';
    }
  }
}