import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ArabicText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ArabicText(
      this.text, {
        super.key,
        this.style,
        this.textAlign = TextAlign.right,
        this.maxLines,
        this.overflow,
      });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Text(
        text,
        style: style ?? AppTheme.arabicMedium,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}

// Size variants
class ArabicTextLarge extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign textAlign;

  const ArabicTextLarge(
      this.text, {
        super.key,
        this.color,
        this.textAlign = TextAlign.center,
      });

  @override
  Widget build(BuildContext context) {
    return ArabicText(
      text,
      style: AppTheme.arabicLarge.copyWith(color: color),
      textAlign: textAlign,
    );
  }
}

class ArabicTextMedium extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign textAlign;

  const ArabicTextMedium(
      this.text, {
        super.key,
        this.color,
        this.textAlign = TextAlign.center,
      });

  @override
  Widget build(BuildContext context) {
    return ArabicText(
      text,
      style: AppTheme.arabicMedium.copyWith(color: color),
      textAlign: textAlign,
    );
  }
}

class ArabicTextSmall extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign textAlign;

  const ArabicTextSmall(
      this.text, {
        super.key,
        this.color,
        this.textAlign = TextAlign.center,
      });

  @override
  Widget build(BuildContext context) {
    return ArabicText(
      text,
      style: AppTheme.arabicSmall.copyWith(color: color),
      textAlign: textAlign,
    );
  }
}