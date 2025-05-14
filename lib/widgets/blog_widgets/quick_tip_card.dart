import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class QuickTipCard extends StatelessWidget {
  final Map<String, dynamic> tip;

  const QuickTipCard({
    super.key,
    required this.tip,
  });

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'sunrise':
        return Icons.wb_sunny_outlined;
      case 'calendar':
        return Icons.event_note_outlined;
      case 'home':
        return Icons.home_outlined;
      case 'lightbulb':
        return Icons.lightbulb_outline;
      case 'clock':
        return Icons.access_time_outlined;
      default:
        return Icons.tips_and_updates_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.charcoal.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.gold.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppTheme.gold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getIconData(tip['icon']),
              color: AppTheme.gold,
              size: 28,
            ),
          ),
          const SizedBox(height: 20),
          
          // Title
          Text(
            tip['title'],
            style: const TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          
          // Description
          Text(
            tip['description'],
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 15,
              color: AppTheme.white.withOpacity(0.8),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          
          // Apply tip button
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                // Handle apply tip
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Save Tip",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.gold,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.bookmark_border_rounded,
                    color: AppTheme.gold,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 