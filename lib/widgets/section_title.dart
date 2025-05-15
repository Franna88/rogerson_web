import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/gold_text_effect.dart';

class SectionTitle extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool centerAlign;
  final bool showDivider;
  final Color? textColor;
  final Color? dividerColor;
  final bool animateDivider;
  final bool startVisible;
  final bool useGoldFoil;

  const SectionTitle({
    super.key,
    required this.title,
    required this.subtitle,
    this.centerAlign = true,
    this.showDivider = true,
    this.textColor,
    this.dividerColor,
    this.animateDivider = true,
    this.startVisible = true,
    this.useGoldFoil = true,
  });

  @override
  State<SectionTitle> createState() => _SectionTitleState();
}

class _SectionTitleState extends State<SectionTitle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _lineWidthAnimation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _lineWidthAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuart,
    ));
    
    if (widget.startVisible) {
      _controller.value = 1.0;
      _isVisible = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (!_isVisible && !widget.startVisible) {
          final RenderObject? renderObject = context.findRenderObject();
          if (renderObject != null) {
            final RenderBox box = renderObject as RenderBox;
            final Offset position = box.localToGlobal(Offset.zero);
            
            // Check if widget is visible in viewport
            if (position.dy < MediaQuery.of(context).size.height * 0.85) {
              setState(() {
                _isVisible = true;
              });
              
              if (widget.animateDivider && widget.showDivider) {
                _controller.forward();
              }
            }
          }
        }
        return false;
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          crossAxisAlignment: widget.centerAlign ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            if (widget.showDivider)
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Container(
                    width: widget.animateDivider 
                        ? 60 * _lineWidthAnimation.value 
                        : 60,
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          (widget.dividerColor ?? AppTheme.gold).withOpacity(0.6),
                          widget.dividerColor ?? AppTheme.gold,
                          (widget.dividerColor ?? AppTheme.gold).withOpacity(0.6),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (widget.dividerColor ?? AppTheme.gold).withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        )
                      ],
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                  );
                },
              ),
            widget.useGoldFoil
              ? GoldTextEffect(
                  scale: 0.4,
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 36, 
                      fontWeight: FontWeight.bold,
                      color: widget.textColor ?? AppTheme.darkText,
                      letterSpacing: 0.5,
                    ),
                    textAlign: widget.centerAlign ? TextAlign.center : TextAlign.start,
                  ),
                )
              : Text(
                  widget.title,
                  style: TextStyle(
                    fontFamily: 'Playfair Display',
                    fontSize: 36, 
                    fontWeight: FontWeight.bold,
                    color: widget.textColor ?? AppTheme.darkText,
                    letterSpacing: 0.5,
                  ),
                  textAlign: widget.centerAlign ? TextAlign.center : TextAlign.start,
                ),
            const SizedBox(height: 12),
            Container(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Text(
                widget.subtitle,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: (widget.textColor ?? AppTheme.darkText).withOpacity(0.8),
                  height: 1.5,
                ),
                textAlign: widget.centerAlign ? TextAlign.center : TextAlign.start,
              ),
            ),
            if (widget.showDivider)
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Container(
                    width: widget.animateDivider 
                        ? 120 * _lineWidthAnimation.value 
                        : 120,
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          (widget.dividerColor ?? AppTheme.silver).withOpacity(0.3),
                          widget.dividerColor ?? AppTheme.silver,
                          (widget.dividerColor ?? AppTheme.silver).withOpacity(0.3),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    margin: const EdgeInsets.only(top: 24),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
} 