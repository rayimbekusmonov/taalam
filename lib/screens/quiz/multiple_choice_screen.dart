import 'package:flutter/material.dart';
import '../../models/quiz_question.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/arabic_text.dart';
import 'quiz_result_screen.dart';

class MultipleChoiceScreen extends StatefulWidget {
  final List<QuizQuestion> questions;
  final String title;

  const MultipleChoiceScreen({
    super.key,
    required this.questions,
    required this.title,
  });

  @override
  State<MultipleChoiceScreen> createState() => _MultipleChoiceScreenState();
}

class _MultipleChoiceScreenState extends State<MultipleChoiceScreen> {
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  int _wrongAnswers = 0;
  String? _selectedAnswer;
  bool _isAnswered = false;
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
  }

  void _selectAnswer(String answer) {
    if (_isAnswered) return;

    setState(() {
      _selectedAnswer = answer;
      _isAnswered = true;

      if (answer == widget.questions[_currentQuestionIndex].correctAnswer) {
        _correctAnswers++;
      } else {
        _wrongAnswers++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _isAnswered = false;
      });
    } else {
      _showResults();
    }
  }

  void _showResults() {
    final duration = DateTime.now().difference(_startTime);
    final result = QuizResult(
      totalQuestions: widget.questions.length,
      correctAnswers: _correctAnswers,
      wrongAnswers: _wrongAnswers,
      timeTaken: duration,
      categoryId: '',
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultScreen(result: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: const Center(child: Text('Savollar yo\'q')),
      );
    }

    final currentQuestion = widget.questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / widget.questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '${_currentQuestionIndex + 1}/${widget.questions.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: AppColors.primary.withAlpha(51),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),

                  // Score
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildScoreBadge(
                        Icons.check_circle,
                        '$_correctAnswers',
                        AppColors.success,
                      ),
                      _buildScoreBadge(
                        Icons.cancel,
                        '$_wrongAnswers',
                        AppColors.error,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Question Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(77),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          currentQuestion.word.emoji ?? '📝',
                          style: const TextStyle(fontSize: 60),
                        ),
                        const SizedBox(height: 20),
                        ArabicTextLarge(
                          currentQuestion.word.arabic,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          currentQuestion.word.transliteration,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Question text
                  Text(
                    'Bu so\'zning ma\'nosini toping:',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  // Options
                  Expanded(
                    child: ListView.builder(
                      itemCount: currentQuestion.options.length,
                      itemBuilder: (context, index) {
                        final option = currentQuestion.options[index];
                        return _buildOptionButton(option, currentQuestion.correctAnswer);
                      },
                    ),
                  ),

                  // Next button
                  if (_isAnswered)
                    ElevatedButton(
                      onPressed: _nextQuestion,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.secondary,
                      ),
                      child: Text(
                        _currentQuestionIndex < widget.questions.length - 1
                            ? 'Keyingi savol'
                            : 'Natijalarni ko\'rish',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBadge(IconData icon, String count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Text(
            count,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(String option, String correctAnswer) {
    final isSelected = _selectedAnswer == option;
    final isCorrect = option == correctAnswer;

    Color getColor() {
      if (!_isAnswered) return AppColors.primary;
      if (isSelected && isCorrect) return AppColors.success;
      if (isSelected && !isCorrect) return AppColors.error;
      if (isCorrect) return AppColors.success;
      return Colors.grey;
    }

    final color = getColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        onPressed: _isAnswered ? null : () => _selectAnswer(option),
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withAlpha(26),
          foregroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: color, width: 2),
          ),
        ),
        child: Row(
          children: [
            if (_isAnswered && isCorrect)
              const Icon(Icons.check_circle, color: AppColors.success)
            else if (_isAnswered && isSelected && !isCorrect)
              const Icon(Icons.cancel, color: AppColors.error)
            else
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}