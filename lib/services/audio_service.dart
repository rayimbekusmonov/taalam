import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isPlaying = false;
  bool _isLoading = false;
  String? _currentWordId;

  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  String? get currentWordId => _currentWordId;

  // Audio player instance
  AudioPlayer get player => _audioPlayer;

  /// Audio faylni URL orqali o'ynash
  Future<void> playFromUrl(String url, String wordId) async {
    try {
      _isLoading = true;
      _currentWordId = wordId;

      // Agar boshqa audio o'ynayotgan bo'lsa, to'xtatish
      if (_isPlaying) {
        await stop();
      }

      // Audio faylni yuklash
      await _audioPlayer.setUrl(url);

      _isLoading = false;

      // Audio o'ynash
      await _audioPlayer.play();
      _isPlaying = true;

      // Audio tugaganda
      _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          _isPlaying = false;
          _currentWordId = null;
        }
      });
    } catch (e) {
      _isLoading = false;
      _isPlaying = false;
      _currentWordId = null;
      if (kDebugMode) {
        print('Audio play error: $e');
      }
      rethrow;
    }
  }

  /// Local asset'dan audio o'ynash
  Future<void> playFromAsset(String assetPath, String wordId) async {
    try {
      _isLoading = true;
      _currentWordId = wordId;

      if (_isPlaying) {
        await stop();
      }

      await _audioPlayer.setAsset(assetPath);

      _isLoading = false;

      await _audioPlayer.play();
      _isPlaying = true;

      _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          _isPlaying = false;
          _currentWordId = null;
        }
      });
    } catch (e) {
      _isLoading = false;
      _isPlaying = false;
      _currentWordId = null;
      if (kDebugMode) {
        print('Audio play error: $e');
      }
      rethrow;
    }
  }

  /// Audio to'xtatish
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      _isPlaying = false;
      _currentWordId = null;
    } catch (e) {
      if (kDebugMode) {
        print('Audio stop error: $e');
      }
    }
  }

  /// Audio pauza
  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
      _isPlaying = false;
    } catch (e) {
      if (kDebugMode) {
        print('Audio pause error: $e');
      }
    }
  }

  /// Audio davom ettirish
  Future<void> resume() async {
    try {
      await _audioPlayer.play();
      _isPlaying = true;
    } catch (e) {
      if (kDebugMode) {
        print('Audio resume error: $e');
      }
    }
  }

  /// Dispose
  void dispose() {
    _audioPlayer.dispose();
  }

  /// Text-to-Speech (TTS) - Google Translate API orqali
  /// Bu demo versiya, production'da boshqa TTS service ishlatish kerak
  String getGoogleTtsUrl(String text, String language) {
    // Google Translate TTS API (unofficial)
    final encodedText = Uri.encodeComponent(text);
    return 'https://translate.google.com/translate_tts?ie=UTF-8&tl=$language&client=tw-ob&q=$encodedText';
  }

  /// Arab tilida audio olish
  Future<void> playArabicText(String arabicText, String wordId) async {
    final url = getGoogleTtsUrl(arabicText, 'ar');
    await playFromUrl(url, wordId);
  }
}