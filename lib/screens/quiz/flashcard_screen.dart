import 'package:flutter/material.dart';
import '../../models/word_model.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/arabic_text.dart';
import '../../widgets/audio_player_widget.dart';

class FlashcardScreen extends StatefulWidget {
  final List<Word> words;
  final String title;

  const FlashcardScreen({
    super.key,
    required this.words,
    required this.title,
  });

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  int _currentIndex = 0;
  bool _showAnswer = false;

  void _nextCard() {
    if (_currentIndex < widget.words.length - 1) {
      setState(() {
        _currentIndex++;
        _showAnswer = false;
      });
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _showAnswer = false;
      });
    }
  }

  void _toggleAnswer() {
    setState(() {
      _showAnswer = !_showAnswer;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.words.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: const Center(
          child: Text('So\'zlar yo\'q'),
        ),
      );
    }

    final currentWord = widget.words[_currentIndex];
    final progress = (_currentIndex + 1) / widget.words.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '${_currentIndex + 1}/${widget.words.length}',
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
                children: [
                  const SizedBox(height: 20),

                  // Flashcard
                  Expanded(
                    child: GestureDetector(
                      onTap: _toggleAnswer,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _showAnswer
                            ? _buildAnswerCard(currentWord)
                            : _buildQuestionCard(currentWord),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Hint
                  Text(
                    _showAnswer
                        ? 'Javobni ko\'ryapsiz'
                        : 'Kartani bosing',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Navigation buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _currentIndex > 0 ? _previousCard : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Avvalgi'),
                      ),
                      ElevatedButton.icon(
                        onPressed: _currentIndex < widget.words.length - 1
                            ? _nextCard
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Keyingi'),
                      ),
                    ],
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

  Widget _buildQuestionCard(Word word) {
    return Container(
      key: const ValueKey('question'),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Emoji
          Text(
            word.emoji ?? '📝',
            style: const TextStyle(fontSize: 80),
          ),
          const SizedBox(height: 30),

          // Arabic text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ArabicTextLarge(
              word.arabic,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 20),

          // Audio button
          MiniAudioButton(
            arabicText: word.arabic,
            wordId: word.id,
            audioUrl: word.audioUrl,
            size: 40,
          ),

          const SizedBox(height: 20),

          // Transliteration
          Text(
            word.transliteration,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerCard(Word word) {
    return Container(
      key: const ValueKey('answer'),
      decoration: BoxDecoration(
        gradient: AppColors.secondaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withAlpha(77),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 60,
          ),
          const SizedBox(height: 30),

          // O'zbek tarjimasi
          Text(
            word.uzbek,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // English tarjimasi
          Text(
            word.english,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 24,
            ),
          ),

          const SizedBox(height: 30),

          // Difficulty badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              word.difficulty == 'easy'
                  ? 'Oson'
                  : word.difficulty == 'medium'
                  ? 'O\'rta'
                  : 'Qiyin',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}