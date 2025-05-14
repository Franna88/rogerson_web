import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool centerAlign;
  final bool showDivider;
  final Color? textColor;
  final Color? dividerColor;

  const SectionTitle({
    super.key,
    required this.title,
    required this.subtitle,
    this.centerAlign = true,
    this.showDivider = true,
    this.textColor,
    this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        crossAxisAlignment: centerAlign ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          if (showDivider)
            Container(
              width: 60,
              height: 2,
              color: dividerColor ?? AppTheme.gold,
              margin: const EdgeInsets.only(bottom: 16),
            ),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 36, 
              fontWeight: FontWeight.bold,
              color: textColor ?? AppTheme.darkText,
              letterSpacing: 0.5,
            ),
            textAlign: centerAlign ? TextAlign.center : TextAlign.start,
          ),
          const SizedBox(height: 12),
          Container(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: (textColor ?? AppTheme.darkText).withOpacity(0.8),
                height: 1.5,
              ),
              textAlign: centerAlign ? TextAlign.center : TextAlign.start,
            ),
          ),
          if (showDivider)
            Container(
              width: 120,
              height: 1,
              color: (dividerColor ?? AppTheme.silver).withOpacity(0.5),
              margin: const EdgeInsets.only(top: 24),
            ),
        ],
      ),
    );
  }
} 