import 'dart:math';
import '../models/word_model.dart';
import '../models/quiz_question.dart';

class QuizService {
  static final QuizService _instance = QuizService._internal();
  factory QuizService() => _instance;
  QuizService._internal();

  final Random _random = Random();

  /// Flashcard uchun so'zlarni aralashtirish
  List<Word> generateFlashcards(List<Word> words) {
    final shuffled = List<Word>.from(words)..shuffle(_random);
    return shuffled;
  }

  /// Multiple choice test yaratish
  List<QuizQuestion> generateMultipleChoice(List<Word> words, int count) {
    if (words.length < 4) return []; // Kamida 4 ta so'z kerak

    final shuffledWords = List<Word>.from(words)..shuffle(_random);
    final selectedWords = shuffledWords.take(count).toList();

    return selectedWords.map((word) {
      // 3 ta noto'g'ri javob tanlash
      final wrongAnswers = words
          .where((w) => w.id != word.id)
          .toList()..shuffle(_random);

      final options = [
        word.uzbek, // To'g'ri javob
        ...wrongAnswers.take(3).map((w) => w.uzbek),
      ]..shuffle(_random);

      return QuizQuestion(
        word: word,
        type: QuizType.multipleChoice,
        options: options,
        correctAnswer: word.uzbek,
      );
    }).toList();
  }

  /// Kategoriya bo'yicha test yaratish
  List<QuizQuestion> generateCategoryQuiz(
      List<Word> categoryWords,
      int questionCount,
      ) {
    return generateMultipleChoice(categoryWords, questionCount);
  }

  /// Random test (barcha kategoriyalardan)
  List<QuizQuestion> generateRandomQuiz(
      List<Word> allWords,
      int questionCount,
      ) {
    return generateMultipleChoice(allWords, questionCount);
  }

  /// Qiyinlik darajasi bo'yicha test
  List<QuizQuestion> generateDifficultyQuiz(
      List<Word> allWords,
      String difficulty,
      int questionCount,
      ) {
    final filteredWords = allWords
        .where((w) => w.difficulty == difficulty)
        .toList();

    return generateMultipleChoice(filteredWords, questionCount);
  }
}