import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PremiumCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const PremiumCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  State<PremiumCard> createState() => _PremiumCardState();
}

class _PremiumCardState extends State<PremiumCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuint),
    );
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
        _controller.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: _isHovered 
                    ? AppTheme.gold.withOpacity(0.2) 
                    : Colors.black.withOpacity(0.08),
                  blurRadius: _isHovered ? 20 : 10,
                  spreadRadius: _isHovered ? 2 : 0,
                  offset: const Offset(0, 5),
                ),
              ],
              border: Border.all(
                color: _isHovered ? AppTheme.gold : AppTheme.silver.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.lightGold.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    widget.icon,
                    color: AppTheme.gold,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontFamily: 'Playfair Display',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkText,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.description,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 15,
                    color: AppTheme.darkText.withOpacity(0.8),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text(
                      "Learn More",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _isHovered ? AppTheme.gold : AppTheme.accentBlue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward,
                      size: 18,
                      color: _isHovered ? AppTheme.gold : AppTheme.accentBlue,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 