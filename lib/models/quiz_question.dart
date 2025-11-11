import 'word_model.dart';

enum QuizType {
  flashcard,
  multipleChoice,
  matching,
}

class QuizQuestion {
  final Word word;
  final QuizType type;
  final List<String> options; // Multiple choice uchun
  final String correctAnswer;

  QuizQuestion({
    required this.word,
    required this.type,
    this.options = const [],
    required this.correctAnswer,
  });
}

class QuizResult {
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final Duration timeTaken;
  final String categoryId;

  QuizResult({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.timeTaken,
    required this.categoryId,
  });

  double get scorePercentage =>
      totalQuestions > 0 ? (correctAnswers / totalQuestions) * 100 : 0;

  String get grade {
    if (scorePercentage >= 90) return 'A';
    if (scorePercentage >= 80) return 'B';
    if (scorePercentage >= 70) return 'C';
    if (scorePercentage >= 60) return 'D';
    return 'F';
  }
}