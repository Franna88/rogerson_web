import 'package:flutter/material.dart';

enum RevealDirection {
  fromBottom,
  fromLeft,
  fromRight,
  fromTop,
  fade,
}

class ScrollRevealWidget extends StatefulWidget {
  final Widget child;
  final RevealDirection direction;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final double offset;
  final bool startVisible;
  
  const ScrollRevealWidget({
    super.key,
    required this.child,
    this.direction = RevealDirection.fromBottom,
    this.duration = const Duration(milliseconds: 800),
    this.delay = Duration.zero,
    this.curve = Curves.easeOutQuint,
    this.offset = 60.0,
    this.startVisible = true,
  });

  @override
  State<ScrollRevealWidget> createState() => _ScrollRevealWidgetState();
}

class _ScrollRevealWidgetState extends State<ScrollRevealWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
    
    // Define the starting offset based on the reveal direction
    Offset beginOffset;
    switch (widget.direction) {
      case RevealDirection.fromBottom:
        beginOffset = Offset(0, widget.offset / 100);
        break;
      case RevealDirection.fromTop:
        beginOffset = Offset(0, -widget.offset / 100);
        break;
      case RevealDirection.fromLeft:
        beginOffset = Offset(-widget.offset / 100, 0);
        break;
      case RevealDirection.fromRight:
        beginOffset = Offset(widget.offset / 100, 0);
        break;
      case RevealDirection.fade:
        beginOffset = Offset.zero;
        break;
    }
    
    _slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
    
    // If startVisible is true, immediately set the animation to its end state
    if (widget.startVisible) {
      _controller.value = 1.0;
      _hasAnimated = true;
    } else {
      // Add a post-frame callback to check visibility initially
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkVisibility();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void _checkVisibility() {
    if (!mounted || _hasAnimated) return;
    
    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject == null || !renderObject.attached) return;
    
    final RenderBox box = renderObject as RenderBox;
    final Offset position = box.localToGlobal(Offset.zero);
    
    final Size screenSize = MediaQuery.of(context).size;
    
    // Check if the widget is in the viewport
    if (position.dy < screenSize.height * 0.85 && 
        position.dy + box.size.height > 0 &&
        position.dx < screenSize.width &&
        position.dx + box.size.width > 0) {
      
      setState(() {
        _hasAnimated = true;
      });
      
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (!widget.startVisible) {
          _checkVisibility();
        }
        return false;
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.translate(
              offset: widget.direction == RevealDirection.fade 
                  ? Offset.zero 
                  : Offset(
                      _slideAnimation.value.dx * 100,
                      _slideAnimation.value.dy * 100,
                    ),
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
} 