import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../services/audio_service.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String arabicText;
  final String wordId;
  final String? audioUrl;

  const AudioPlayerWidget({
    super.key,
    required this.arabicText,
    required this.wordId,
    this.audioUrl,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioService _audioService = AudioService();
  bool _isLoading = false;
  bool _hasError = false;

  Future<void> _playAudio() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      if (widget.audioUrl != null && widget.audioUrl!.isNotEmpty) {
        // Agar audio URL mavjud bo'lsa
        await _audioService.playFromUrl(widget.audioUrl!, widget.wordId);
      } else {
        // Aks holda Google TTS ishlatamiz
        await _audioService.playArabicText(widget.arabicText, widget.wordId);
      }
    } catch (e) {
      setState(() {
        _hasError = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Audio yuklanmadi. Iltimos qayta urinib ko\'ring.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCurrentlyPlaying = _audioService.isPlaying &&
        _audioService.currentWordId == widget.wordId;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            _hasError
                ? Icons.error_outline
                : (isCurrentlyPlaying ? Icons.volume_up : Icons.volume_up_outlined),
            color: Colors.white,
            size: 48,
          ),

          const SizedBox(height: 12),

          Text(
            isCurrentlyPlaying ? 'O\'ynayapti...' : 'Talaffuzni eshitish',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: _isLoading ? null : _playAudio,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            )
                : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isCurrentlyPlaying ? Icons.stop : Icons.play_arrow,
                ),
                const SizedBox(width: 8),
                Text(isCurrentlyPlaying ? 'To\'xtatish' : 'Eshitish'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Mini Audio Button (So'z kartalarida ishlatish uchun)
class MiniAudioButton extends StatefulWidget {
  final String arabicText;
  final String wordId;
  final String? audioUrl;
  final double size;

  const MiniAudioButton({
    super.key,
    required this.arabicText,
    required this.wordId,
    this.audioUrl,
    this.size = 32,
  });

  @override
  State<MiniAudioButton> createState() => _MiniAudioButtonState();
}

class _MiniAudioButtonState extends State<MiniAudioButton> {
  final AudioService _audioService = AudioService();
  bool _isLoading = false;

  Future<void> _playAudio() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.audioUrl != null && widget.audioUrl!.isNotEmpty) {
        await _audioService.playFromUrl(widget.audioUrl!, widget.wordId);
      } else {
        await _audioService.playArabicText(widget.arabicText, widget.wordId);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Audio yuklanmadi'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCurrentlyPlaying = _audioService.isPlaying &&
        _audioService.currentWordId == widget.wordId;

    return IconButton(
      onPressed: _isLoading ? null : _playAudio,
      icon: _isLoading
          ? SizedBox(
        width: widget.size * 0.6,
        height: widget.size * 0.6,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
        ),
      )
          : Icon(
        isCurrentlyPlaying ? Icons.volume_up : Icons.volume_up_outlined,
        size: widget.size,
        color: isCurrentlyPlaying ? AppColors.secondary : AppColors.primary,
      ),
    );
  }
}