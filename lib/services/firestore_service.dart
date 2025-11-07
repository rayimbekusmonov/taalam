import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/word_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Word>> getAllWords() async {
    try {
      final snapshot = await _db.collection('words').get();
      return snapshot.docs.map((doc) => Word(
        id: doc.id,
        categoryId: doc.data()['categoryId'] ?? '',
        arabic: doc.data()['arabic'] ?? '',
        transliteration: doc.data()['transliteration'] ?? '',
        uzbek: doc.data()['uzbek'] ?? '',
        audioUrl: doc.data()['audioUrl'] ?? '',
      )).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Word>> getWordsByCategory(String categoryId) async {
    try {
      final snapshot = await _db.collection('words').where('categoryId', isEqualTo: categoryId).get();
      return snapshot.docs.map((doc) => Word(
        id: doc.id,
        categoryId: doc.data()['categoryId'] ?? '',
        arabic: doc.data()['arabic'] ?? '',
        transliteration: doc.data()['transliteration'] ?? '',
        uzbek: doc.data()['uzbek'] ?? '',
        audioUrl: doc.data()['audioUrl'] ?? '',
      )).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
}
