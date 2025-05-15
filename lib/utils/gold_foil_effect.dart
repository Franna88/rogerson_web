import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';

class GoldFoilEffect extends StatelessWidget {
  final Widget child;
  final bool enabled;
  
  const GoldFoilEffect({
    super.key, 
    required this.child,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.3, 0.6, 0.9, 1.0],
          colors: [
            AppTheme.gold.withOpacity(0.8),
            AppTheme.gold,
            AppTheme.lightGold.withOpacity(0.95),
            AppTheme.gold.withOpacity(0.8),
            AppTheme.gold,
          ],
          transform: GradientRotation(math.pi / 8),
        ).createShader(bounds);
      },
      child: child,
    );
  }
} 