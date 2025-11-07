import 'package:flutter/foundation.dart' hide Category;
import '../models/category_model.dart';
import '../services/demo_data_service.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasData => _categories.isNotEmpty;

  // Kategoriyalarni yuklash
  void loadCategories() {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _categories = DemoDataService.getDemoCategories();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Kategoriyalarni yuklashda xatolik: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Kategoriyani ID bo'yicha olish
  Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  void refresh() {
    loadCategories();
  }
}
