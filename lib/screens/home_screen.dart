import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';
import '../widgets/premium_button.dart';
import '../widgets/premium_card.dart';
import '../widgets/section_title.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onNavigate;

  const HomeScreen({
    super.key,
    required this.onNavigate,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  // Scroll controller for parallax effects
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;
  
  // List of testimonials for the carousel
  final List<Map<String, String>> _testimonials = [
    {
      'text': "Dr. Morgan's approach to executive psychology has been transformative for my leadership style. Her insights have helped me navigate complex business decisions with greater clarity and purpose.",
      'author': "Richard J. Hartman",
      'position': "CEO, Hartman Industries"
    },
    {
      'text': "The premium stress management program completely changed how I handle high-pressure situations. I've gained valuable techniques that have improved both my professional performance and personal wellbeing.",
      'author': "Elizabeth Chen",
      'position': "CFO, Global Ventures"
    },
    {
      'text': "Working with Dr. Morgan on relationship coaching has given me tools to balance my demanding career with meaningful personal connections. The results have been nothing short of extraordinary.",
      'author': "Jonathan Blackwell",
      'position': "Managing Director, Blackwell Partners"
    },
  ];
  
  int _currentTestimonial = 0;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
    ));
    
    _animationController.forward();
    
    // Initialize testimonial carousel
    _startTestimonialCarousel();
    
    // Setup scroll listener for parallax effects only
    _scrollController.addListener(_updateScrollPosition);
  }

  void _updateScrollPosition() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  void _startTestimonialCarousel() {
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        setState(() {
          _currentTestimonial = (_currentTestimonial + 1) % _testimonials.length;
        });
        _startTestimonialCarousel();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollPosition);
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          _buildHeroSection(),
          _buildServicesSection(),
          _buildTestimonialSection(),
          _buildCTASection(),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    // Calculate parallax effect based on scroll position
    final double parallaxOffset = _scrollOffset * 0.4;
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    final bool isTablet = MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 960;
    
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.white,
            AppTheme.lightSilver.withOpacity(0.5),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Parallax background pattern
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(0, parallaxOffset * 0.2),
              child: Opacity(
                opacity: 0.1,
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1558591710-4b4a1ae0f04d?q=80&w=500&auto=format&fit=crop'),
                      repeat: ImageRepeat.repeat,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Animated floating shapes - only show on tablet and desktop
          if (!isMobile) ..._buildFloatingElements(),
          
          // Gold accent lines with animation - only show on tablet and desktop
          if (!isMobile) Positioned(
            right: 0,
            top: MediaQuery.of(context).size.height * 0.3 - (parallaxOffset * 0.1),
            child: Container(
              width: 150,
              height: 2,
              color: AppTheme.gold.withOpacity(0.6),
            ),
          ),
          if (!isMobile) Positioned(
            left: 0,
            bottom: MediaQuery.of(context).size.height * 0.2 + (parallaxOffset * 0.1),
            child: Container(
              width: 100,
              height: 2,
              color: AppTheme.gold.withOpacity(0.6),
            ),
          ),
          
          // Main content with parallax effect
          SafeArea(
            child: Center(
              child: Transform.translate(
                offset: Offset(0, -parallaxOffset * 0.3),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 24,
                      vertical: isMobile ? 0 : 24,
                    ),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: isMobile ? 40 : 80), // Reduced space for mobile
                            Container(
                              width: 100,
                              height: 1,
                              color: AppTheme.gold,
                              margin: const EdgeInsets.only(bottom: 24),
                            ),
                            Text(
                              AppConstants.homeHeroTitle,
                              style: TextStyle(
                                fontFamily: 'Playfair Display',
                                fontSize: isMobile ? 32 : (isTablet ? 42 : 48), // Further reduced size for mobile
                                fontWeight: FontWeight.bold,
                                color: AppTheme.gold,
                                letterSpacing: 1.0,
                                height: 1.2, // Tighter line height to avoid overflow
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: isMobile ? 16 : 24), // Reduced space for mobile
                            Container(
                              constraints: const BoxConstraints(maxWidth: 800),
                              child: Text(
                                AppConstants.homeHeroSubtitle,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: isMobile ? 16 : (isTablet ? 18 : 22), // Further reduced size for mobile
                                  color: AppTheme.darkText.withOpacity(0.8),
                                  height: 1.4, // Tighter line height to avoid overflow
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: isMobile ? 24 : 40), // Reduced space for mobile
                            Container(
                              constraints: const BoxConstraints(maxWidth: 700),
                              child: Text(
                                AppConstants.homeIntroText,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: isMobile ? 14 : (isTablet ? 15 : 18), // Further reduced size for mobile
                                  color: AppTheme.darkText.withOpacity(0.7),
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: isMobile ? 32 : 60), // Reduced space for mobile
                            LayoutBuilder(
                              builder: (context, constraints) {
                                // Stack buttons vertically on mobile
                                if (MediaQuery.of(context).size.width < 480) {
                                  return Column(
                                    children: [
                                      PremiumButton(
                                        text: AppConstants.ctaButtonText,
                                        onPressed: () {
                                          widget.onNavigate(3); // Navigate to Contact
                                        },
                                        width: double.infinity, // Full width on mobile
                                      ),
                                      const SizedBox(height: 16),
                                      PremiumButton(
                                        text: "Discover Services",
                                        isOutlined: true,
                                        onPressed: () {
                                          widget.onNavigate(2); // Navigate to Services
                                        },
                                        width: double.infinity, // Full width on mobile
                                      ),
                                    ],
                                  );
                                } else {
                                  // Use row layout on larger screens
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      PremiumButton(
                                        text: AppConstants.ctaButtonText,
                                        onPressed: () {
                                          widget.onNavigate(3); // Navigate to Contact
                                        },
                                      ),
                                      const SizedBox(width: 24),
                                      PremiumButton(
                                        text: "Discover Services",
                                        isOutlined: true,
                                        onPressed: () {
                                          widget.onNavigate(2); // Navigate to Services
                                        },
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                            // Only show scroll indicator on tablet and desktop
                            if (!isMobile) ...[
                              const SizedBox(height: 60),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    widget.onNavigate(2); // Navigate to Services section
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppTheme.silver,
                                        width: 1,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: AppTheme.silver,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection() {
    // Ensure the section is always visible with a minimum opacity
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.3, end: 1.0),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)), // Reduced slide distance
          child: Opacity(
            opacity: value, // Will never be less than 0.3 due to tween start value
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
              color: AppTheme.white,
              child: Column(
                children: [
                  SectionTitle(
                    title: AppConstants.servicesTitle,
                    subtitle: AppConstants.servicesSubtitle,
                    centerAlign: true,
                  ),
                  const SizedBox(height: 40),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final screenWidth = constraints.maxWidth;
                      final isMobile = screenWidth < 768;
                      final isTablet = screenWidth >= 768 && screenWidth < 1200;
                      
                      if (isMobile) {
                        return Column(
                          children: _buildServiceCardsWithAnimation(
                            scrollable: false, 
                            maxCards: 3,
                          ),
                        );
                      } else if (isTablet) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _buildServiceCardsWithAnimation(
                                scrollable: false, 
                                maxCards: 2,
                              ),
                            ),
                            const SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildServiceCardWithAnimation(
                                  index: 2, 
                                  scrollable: false,
                                  delay: 0.4,
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _buildServiceCardsWithAnimation(
                            scrollable: false, 
                            maxCards: 3,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 60),
                  PremiumButton(
                    text: "View All Services",
                    onPressed: () {
                      widget.onNavigate(2); // Navigate to Services
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildServiceCardsWithAnimation({
    required bool scrollable,
    required int maxCards,
  }) {
    final services = [
      {
        'icon': Icons.psychology,
        'title': AppConstants.executiveTherapyTitle,
        'description': AppConstants.executiveTherapyDescription,
      },
      {
        'icon': Icons.handshake,
        'title': AppConstants.relationshipCoachingTitle,
        'description': AppConstants.relationshipCoachingDescription,
      },
      {
        'icon': Icons.spa,
        'title': AppConstants.stressManagementTitle,
        'description': AppConstants.stressManagementDescription,
      },
    ];

    return List.generate(
      maxCards > services.length ? services.length : maxCards,
      (index) => _buildServiceCardWithAnimation(
        index: index,
        scrollable: scrollable,
        delay: index * 0.2, // Staggered delay
      ),
    );
  }

  Widget _buildServiceCardWithAnimation({
    required int index,
    required bool scrollable,
    required double delay,
  }) {
    final services = [
      {
        'icon': Icons.psychology,
        'title': AppConstants.executiveTherapyTitle,
        'description': AppConstants.executiveTherapyDescription,
      },
      {
        'icon': Icons.handshake,
        'title': AppConstants.relationshipCoachingTitle,
        'description': AppConstants.relationshipCoachingDescription,
      },
      {
        'icon': Icons.spa,
        'title': AppConstants.stressManagementTitle,
        'description': AppConstants.stressManagementDescription,
      },
    ];

    final service = services[index];

    // Simplified animation that ensures cards are always visible
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        // Always start with a minimum opacity to ensure visibility
        final animationValue = (value - delay).clamp(0.3, 1.0);
            
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: scrollable ? 12 : 16,
            vertical: scrollable ? 8 : 16,
          ),
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - animationValue)),
            child: Opacity(
              opacity: animationValue,
              child: PremiumCard(
                icon: service['icon'] as IconData,
                title: service['title'] as String,
                description: service['description'] as String,
                onTap: () {
                  widget.onNavigate(2); // Navigate to Services
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTestimonialSection() {
    // Ensure the section is always visible with a minimum opacity
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.3, end: 1.0),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)), // Reduced slide distance
          child: Opacity(
            opacity: value, // Will never be less than 0.3 due to tween start value
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.width < 600 ? 60 : 100, // Less padding on mobile
                horizontal: 24,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.charcoal.withOpacity(0.9),
                    AppTheme.charcoal,
                  ],
                ),
              ),
              child: Column(
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.8, end: 1.0),
                    duration: const Duration(milliseconds: 3000),
                    curve: Curves.easeInOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: const Icon(
                          Icons.format_quote,
                          color: AppTheme.gold,
                          size: 60,
                        ),
                      );
                    },
                    onEnd: () => setState(() {}),
                  ),
                  const SizedBox(height: 40),
                  
                  // Testimonial carousel
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 800),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.25, 0.0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: _buildTestimonialContent(
                      _testimonials[_currentTestimonial],
                      key: ValueKey<int>(_currentTestimonial),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildTestimonialContent(Map<String, String> testimonial, {required Key key}) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    
    return Column(
      key: key,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 900),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            testimonial['text']!,
            style: TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: isMobile ? 22 : 28, // Smaller font on mobile
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
              color: AppTheme.white,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 40),
        // Animated line
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 60),
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeOut,
          builder: (context, width, child) {
            return Container(
              width: width,
              height: 2,
              color: AppTheme.silver,
            );
          },
        ),
        const SizedBox(height: 24),
        Text(
          testimonial['author']!,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.gold,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          testimonial['position']!,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            color: AppTheme.white.withOpacity(0.8),
          ),
        ),
        
        // Testimonial indicators
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _testimonials.length,
            (index) => _buildTestimonialIndicator(index),
          ),
        ),
      ],
    );
  }
  
  Widget _buildTestimonialIndicator(int index) {
    final bool isActive = index == _currentTestimonial;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentTestimonial = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: isActive ? 24 : 8,
        height: 8,
        decoration: BoxDecoration(
          color: isActive ? AppTheme.gold : AppTheme.silver.withOpacity(0.3),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _buildCTASection() {
    // Ensure the section is always visible with a minimum opacity
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.3, end: 1.0),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        final bool isMobile = MediaQuery.of(context).size.width < 600;
        
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)), // Reduced slide distance
          child: Opacity(
            opacity: value, // Will never be less than 0.3 due to tween start value
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 24, 
                vertical: isMobile ? 60 : 80, // Less padding on mobile
              ),
              decoration: BoxDecoration(
                color: AppTheme.white,
                border: Border(
                  top: BorderSide(
                    color: AppTheme.silver.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  // Animated gold divider
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 60),
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.easeOut,
                    builder: (context, width, child) {
                      return Container(
                        width: width,
                        height: 2,
                        margin: const EdgeInsets.only(bottom: 24),
                        color: AppTheme.gold,
                      );
                    },
                  ),
                  // Animated title with subtle hover effect
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 1.0, end: 1.02),
                    duration: const Duration(milliseconds: 3000),
                    curve: Curves.easeInOut,
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: 1.0 + (scale - 1.0) * 0.02,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Ready to Begin Your Journey?",
                            style: TextStyle(
                              fontFamily: 'Playfair Display',
                              fontSize: isMobile ? 30 : 36, // Smaller font on mobile
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkText,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                    onEnd: () => setState(() {}),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 700),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Schedule your confidential consultation to discover how Dr. Morgan's premium psychological services can help you achieve exceptional mental wellbeing and performance.",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: isMobile ? 16 : 18, // Smaller font on mobile
                        color: AppTheme.darkText.withOpacity(0.8),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Add hover animation to the button
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 10),
                    duration: const Duration(milliseconds: 2000),
                    curve: Curves.easeInOut,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, math.sin(value) * 1),
                        child: PremiumButton(
                          text: AppConstants.ctaButtonText,
                          width: isMobile ? double.infinity : 200, // Use concrete value instead of null
                          onPressed: () {
                            widget.onNavigate(3); // Navigate to Contact
                          },
                        ),
                      );
                    },
                    onEnd: () => setState(() {}),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Creates floating decorative elements for visual appeal
  List<Widget> _buildFloatingElements() {
    return [
      // Gold circle
      Positioned(
        top: MediaQuery.of(context).size.height * 0.2,
        right: MediaQuery.of(context).size.width * 0.15,
        child: _buildAnimatedShape(
          size: 10,
          color: AppTheme.gold.withOpacity(0.7),
          shape: BoxShape.circle,
          animationOffset: 20,
          animationDuration: 4,
        ),
      ),
      // Silver square
      Positioned(
        top: MediaQuery.of(context).size.height * 0.6,
        left: MediaQuery.of(context).size.width * 0.1,
        child: Transform.rotate(
          angle: math.pi / 4,
          child: _buildAnimatedShape(
            size: 15,
            color: AppTheme.silver.withOpacity(0.5),
            shape: BoxShape.rectangle,
            animationOffset: 15,
            animationDuration: 5,
          ),
        ),
      ),
      // Gold rectangle
      Positioned(
        bottom: MediaQuery.of(context).size.height * 0.25,
        right: MediaQuery.of(context).size.width * 0.2,
        child: _buildAnimatedShape(
          width: 40,
          height: 5,
          color: AppTheme.gold.withOpacity(0.4),
          shape: BoxShape.rectangle,
          animationOffset: 10,
          animationDuration: 6,
        ),
      ),
    ];
  }
  
  // Creates animated floating shapes with continuous motion
  Widget _buildAnimatedShape({
    double? size,
    double? width,
    double? height,
    required Color color,
    required BoxShape shape,
    required double animationOffset,
    required int animationDuration,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 2 * math.pi),
      duration: Duration(seconds: animationDuration),
      curve: Curves.linear,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(
            math.sin(value) * animationOffset,
            math.cos(value) * animationOffset,
          ),
          child: Container(
            width: size ?? width,
            height: size ?? height,
            decoration: BoxDecoration(
              color: color,
              shape: shape,
            ),
          ),
        );
      },
      // Makes the animation loop continuously
      onEnd: () => setState(() {}),
    );
  }
} 