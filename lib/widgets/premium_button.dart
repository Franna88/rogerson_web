import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/gold_foil_effect.dart';

class PremiumButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;
  final double width;
  final double height;
  final bool useGoldFoil;
  final bool enableIntroAnimation;
  final Duration introDuration;
  final Duration introDelay;

  const PremiumButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.width = 220,
    this.height = 56,
    this.useGoldFoil = false,
    this.enableIntroAnimation = false,
    this.introDuration = const Duration(milliseconds: 800),
    this.introDelay = const Duration(milliseconds: 200),
  });

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _slideAnimation;
  bool _isHovered = false;
  bool _hasIntroAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    
    _slideAnimation = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutQuint),
      ),
    );
    
    if (widget.enableIntroAnimation) {
      Future.delayed(widget.introDelay, () {
        if (mounted) {
          setState(() {
            _hasIntroAnimated = true;
          });
          _controller.forward();
        }
      });
    } else {
      _controller.value = 1.0;
      _hasIntroAnimated = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
        // Only run hover animation after intro animation is complete
        if (!widget.enableIntroAnimation || _hasIntroAnimated) {
          _controller.forward();
        }
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
        // Don't reverse if intro animation is still running
        if (!widget.enableIntroAnimation || _hasIntroAnimated) {
          _controller.reverse();
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final double opacity = widget.enableIntroAnimation ? _opacityAnimation.value : 1.0;
          final double offsetY = widget.enableIntroAnimation ? _slideAnimation.value : 0.0;
          
          return Opacity(
            opacity: opacity,
            child: Transform.translate(
              offset: Offset(0, offsetY),
              child: Transform.scale(
                scale: _isHovered ? _scaleAnimation.value : 1.0,
                child: Material(
                  elevation: _isHovered ? 4 : 2,
                  shadowColor: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.transparent,
                  child: Container(
                    width: widget.width,
                    height: widget.height,
                    decoration: BoxDecoration(
                      gradient: widget.isOutlined ? null : AppTheme.goldGradient,
                      border: widget.isOutlined 
                          ? Border.all(color: AppTheme.gold, width: 2) 
                          : null,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: _isHovered
                          ? [
                              BoxShadow(
                                color: AppTheme.gold.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              )
                            ]
                          : [],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        children: [
                          if (widget.useGoldFoil)
                            Positioned.fill(
                              child: GoldFoilEffect(
                                enabled: true,
                                child: Container(
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                          InkWell(
                            onTap: widget.onPressed,
                            splashColor: AppTheme.lightGold.withOpacity(0.3),
                            highlightColor: Colors.transparent,
                            child: Center(
                              child: Text(
                                widget.text,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.0,
                                  color: widget.isOutlined ? AppTheme.gold : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 