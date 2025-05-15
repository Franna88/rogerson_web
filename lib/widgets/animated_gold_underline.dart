import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AnimatedGoldUnderline extends StatefulWidget {
  final Widget child;
  final bool isActive;
  final Color? underlineColor;
  final double underlineHeight;
  final Duration duration;
  final Curve curve;

  const AnimatedGoldUnderline({
    super.key,
    required this.child,
    this.isActive = false,
    this.underlineColor,
    this.underlineHeight = 2.0,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  @override
  State<AnimatedGoldUnderline> createState() => _AnimatedGoldUnderlineState();
}

class _AnimatedGoldUnderlineState extends State<AnimatedGoldUnderline> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _widthAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _widthAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
    
    if (widget.isActive) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(AnimatedGoldUnderline oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.forward();
      } else if (!_isHovered) {
        _controller.reverse();
      }
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
        _controller.forward();
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
        if (!widget.isActive) {
          _controller.reverse();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.child,
          const SizedBox(height: 4),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.05 * _widthAnimation.value,
                  height: widget.underlineHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        (widget.underlineColor ?? AppTheme.gold).withOpacity(0.3),
                        widget.underlineColor ?? AppTheme.gold,
                        (widget.underlineColor ?? AppTheme.gold).withOpacity(0.3),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(widget.underlineHeight / 2),
                    boxShadow: [
                      BoxShadow(
                        color: (widget.underlineColor ?? AppTheme.gold).withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
} 