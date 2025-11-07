import 'package:flutter/foundation.dart';
import '../models/word_model.dart';
import '../services/demo_data_service.dart';

class WordProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Word> _allWords = [];
  List<Word> get allWords => _allWords;

  List<Word> _currentCategoryWords = [];
  List<Word> get currentCategoryWords => _currentCategoryWords;

  final List<Word> _favoriteWords = [];
  List<Word> get favoriteWords => _favoriteWords;

  int get totalWordsCount => _allWords.length;
  int get learnedWordsCount => 0; // Placeholder
  int get favoriteWordsCount => _favoriteWords.length;
  double get learningProgress => 0; // Placeholder

  void loadAllWords() {
    _isLoading = true;
    notifyListeners();
    _allWords = DemoDataService.getDemoWords();
    _isLoading = false;
    notifyListeners();
  }

  void loadWordsByCategory(String categoryId) {
    _isLoading = true;
    notifyListeners();
    _currentCategoryWords = DemoDataService.getDemoWords()
        .where((word) => word.categoryId == categoryId)
        .toList();
    _isLoading = false;
    notifyListeners();
  }

  void refresh() {
    loadAllWords();
  }

  void toggleFavorite(String wordId) {
    // Implement favorite toggle logic
    notifyListeners();
  }

  void toggleLearned(String wordId) {
    // Implement learned toggle logic
    notifyListeners();
  }
}
