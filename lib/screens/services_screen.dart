import 'package:flutter/material.dart';
import 'package:rogerson/utils/gold_text_effect.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';
import '../widgets/premium_button.dart';
import '../widgets/section_title.dart';

class ServicesScreen extends StatefulWidget {
  final Function(int) onNavigate;

  const ServicesScreen({
    super.key,
    required this.onNavigate,
  });

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  
  // Animation controllers - one for each section
  late AnimationController _servicesAnimationController;
  late AnimationController _processAnimationController;
  late AnimationController _ctaAnimationController;
  
  // Track which sections have been animated
  bool _animatedServices = false;
  bool _animatedProcess = false;
  bool _animatedCta = false;
  
  // References to keep track of section positions
  final GlobalKey _servicesKey = GlobalKey();
  final GlobalKey _processKey = GlobalKey();
  final GlobalKey _ctaKey = GlobalKey();
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Initialize animation controllers
    _servicesAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    _processAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    _ctaAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Wait until rendering is complete before checking visibility
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initial check for visibility
      _checkVisibility();
      
      // Force a second check after a brief delay in case the first check fails
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!_animatedServices) {
          print("Forcing animations to play as fallback");
          _forceAllAnimations();
        }
      });
    });
  }
  
  @override
  void dispose() {
    _servicesAnimationController.dispose();
    _processAnimationController.dispose();
    _ctaAnimationController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
  
  void _onScroll() {
    // Check if sections are in view and trigger animations
    _checkVisibility();
  }

  void _checkVisibility() {
    // Log to verify method is being called
    print("Checking visibility for animations");
    
    if (_servicesKey.currentContext != null && !_animatedServices) {
      final RenderBox box = _servicesKey.currentContext!.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;
      
      // More aggressive trigger - activate if section is anywhere in viewport
      if (position.dy < screenHeight) {
        print("Services section visible, triggering animation");
        setState(() {
          _animatedServices = true;
        });
        _servicesAnimationController.forward();
      }
    }
    
    if (_processKey.currentContext != null && !_animatedProcess) {
      final RenderBox box = _processKey.currentContext!.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;
      
      if (position.dy < screenHeight) {
        print("Process section visible, triggering animation");
        setState(() {
          _animatedProcess = true;
        });
        _processAnimationController.forward();
      }
    }
    
    if (_ctaKey.currentContext != null && !_animatedCta) {
      final RenderBox box = _ctaKey.currentContext!.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;
      
      if (position.dy < screenHeight) {
        print("CTA section visible, triggering animation");
        setState(() {
          _animatedCta = true;
        });
        _ctaAnimationController.forward();
      }
    }
  }

  // Debug method to force all animations to play
  void _forceAllAnimations() {
    setState(() {
      _animatedServices = true;
      _animatedProcess = true;
      _animatedCta = true;
    });
    
    _servicesAnimationController.forward(from: 0.0);
    _processAnimationController.forward(from: 0.0);
    _ctaAnimationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Trigger animations on tap as a fallback
        if (!_animatedServices) {
          setState(() {
            _animatedServices = true;
          });
          _servicesAnimationController.forward(from: 0.0);
        }
        if (!_animatedProcess) {
          setState(() {
            _animatedProcess = true;
          });
          _processAnimationController.forward(from: 0.0);
        }
        if (!_animatedCta) {
          setState(() {
            _animatedCta = true;
          });
          _ctaAnimationController.forward(from: 0.0);
        }
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeroSection(context),
            _buildServiceDetailsSection(),
            _buildProcessSection(),
            _buildCTASection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width < 768 ? 300 : 400,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.charcoal,
        image: DecorationImage(
          image: const NetworkImage('https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            AppTheme.charcoal.withOpacity(0.6),
            BlendMode.darken,
          ),
          onError: (_, __) {
            // Fallback to solid color if image fails
          },
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            Container(
              width: 60,
              height: 2,
              color: AppTheme.gold,
              margin: const EdgeInsets.only(bottom: 24),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GoldTextEffect(
                scale: 0.4,
                child: Text(
                  AppConstants.servicesTitle,
                  style: TextStyle(
                    fontFamily: 'Playfair Display',
                    fontSize: MediaQuery.of(context).size.width < 600 ? 36 : 48,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.white,
                    letterSpacing: 1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                AppConstants.servicesSubtitle,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: MediaQuery.of(context).size.width < 600 ? 16 : 20,
                  color: AppTheme.white.withOpacity(0.9),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceDetailsSection() {
    return Container(
      key: _servicesKey,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      color: AppTheme.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              const SectionTitle(
                title: "Premium Psychological Services",
                subtitle: "Exclusive therapeutic approaches tailored for ambitious individuals and elite professionals",
                centerAlign: true,
              ),
              const SizedBox(height: 60),
              // First service with animation
              AnimatedBuilder(
                animation: _servicesAnimationController,
                builder: (context, child) {
                  // Only animate when section is in view
                  if (!_animatedServices) {
                    return child!;
                  }
                  return Transform.translate(
                    offset: Offset(
                      (-300 * (1 - _servicesAnimationController.value)),
                      0,
                    ),
                    child: Opacity(
                      opacity: _servicesAnimationController.value,
                      child: child,
                    ),
                  );
                },
                child: _buildServiceDetail(
                  title: AppConstants.executiveTherapyTitle,
                  description: AppConstants.executiveTherapyDescription,
                  image: 'https://plus.unsplash.com/premium_photo-1665990294874-36ff13d2b66d?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8Y291bnNlbGxpbmd8ZW58MHx8MHx8fDA%3D',
                  icon: Icons.psychology,
                  benefits: [
                    "Enhanced decision-making clarity under pressure",
                    "Improved emotional intelligence and leadership presence",
                    "Strategies for managing high-stakes professional situations",
                    "Work-life integration designed for the elite professional"
                  ],
                  isImageLeft: true,
                ),
              ),
              const SizedBox(height: 40),
              // Second service with animation
              AnimatedBuilder(
                animation: _servicesAnimationController,
                builder: (context, child) {
                  // Only animate when section is in view
                  if (!_animatedServices) {
                    return child!;
                  }
                  return Transform.translate(
                    offset: Offset(
                      (300 * (1 - _servicesAnimationController.value)),
                      0,
                    ),
                    child: Opacity(
                      opacity: _servicesAnimationController.value,
                      child: child,
                    ),
                  );
                },
                child: _buildServiceDetail(
                  title: AppConstants.relationshipCoachingTitle,
                  description: AppConstants.relationshipCoachingDescription,
                  image: 'https://images.unsplash.com/photo-1506014299253-3725319c0f69?q=80&w=2574&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  icon: Icons.handshake,
                  benefits: [
                    "Master advanced communication for complex relationships",
                    "Develop strategies for maintaining connections despite demanding schedules",
                    "Navigate high-profile relationships with discretion and intention",
                    "Balance professional success with personal fulfillment"
                  ],
                  isImageLeft: false,
                ),
              ),
              const SizedBox(height: 40),
              // Third service with animation
              AnimatedBuilder(
                animation: _servicesAnimationController,
                builder: (context, child) {
                  // Only animate when section is in view
                  if (!_animatedServices) {
                    return child!;
                  }
                  return Transform.translate(
                    offset: Offset(
                      (-300 * (1 - _servicesAnimationController.value)),
                      0,
                    ),
                    child: Opacity(
                      opacity: _servicesAnimationController.value,
                      child: child,
                    ),
                  );
                },
                child: _buildServiceDetail(
                  title: AppConstants.stressManagementTitle,
                  description: AppConstants.stressManagementDescription,
                  image: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
                  icon: Icons.spa,
                  benefits: [
                    "Personalized stress reduction protocols for high-pressure environments",
                    "Trauma-informed approaches for processing public scrutiny or professional setbacks",
                    "Cognitive techniques to transform pressure into optimal performance",
                    "Strategies for maintaining mental clarity during crisis situations"
                  ],
                  isImageLeft: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildServiceDetail({
    required String title,
    required String description,
    required String image,
    required IconData icon,
    required List<String> benefits,
    required bool isImageLeft,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isMobile = screenWidth < 768;
        final isTablet = screenWidth >= 768 && screenWidth < 1024;
        
        Widget imageWidget = Container(
          width: isMobile ? double.infinity : null,
          constraints: BoxConstraints(
            maxWidth: isMobile ? double.infinity : 500,
            maxHeight: isMobile ? 300 : double.infinity,
          ),
          child: AspectRatio(
            aspectRatio: isMobile ? 16 / 9 : 3 / 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                image,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: AppTheme.lightSilver,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.gold),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppTheme.lightSilver,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icon,
                            color: AppTheme.darkText.withOpacity(0.5),
                            size: 50,
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              title,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.darkText.withOpacity(0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
        
        Widget content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.lightGold.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: AppTheme.gold,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: isMobile ? 24 : 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkText,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              description,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: isMobile ? 15 : 16,
                color: AppTheme.darkText.withOpacity(0.8),
                height: 1.7,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Key Benefits",
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.darkText,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),
            ...benefits.map((benefit) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.gold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      benefit,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: isMobile ? 14 : 15,
                        color: AppTheme.darkText.withOpacity(0.8),
                        height: 1.5,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
            )).toList(),
            const SizedBox(height: 30),
            Center(
              child: PremiumButton(
                text: "Schedule a Consultation",
                onPressed: () {
                  widget.onNavigate(4);
                },
                width: isMobile ? double.infinity : 220,
              ),
            ),
          ],
        );
        
        if (isMobile) {
          return Container(
            margin: const EdgeInsets.only(bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                imageWidget,
                const SizedBox(height: 30),
                content,
              ],
            ),
          );
        } else if (isTablet) {
          return Container(
            margin: const EdgeInsets.only(bottom: 50),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, 5),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: isImageLeft
                ? [
                    Expanded(
                      flex: 4,
                      child: imageWidget,
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: content,
                      ),
                    ),
                  ]
                : [
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: content,
                      ),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      flex: 4,
                      child: imageWidget,
                    ),
                  ],
            ),
          );
        } else {
          return Container(
            margin: const EdgeInsets.only(bottom: 60),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, 8),
                  blurRadius: 20,
                  spreadRadius: 1,
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: isImageLeft
                ? [
                    Expanded(
                      flex: 5,
                      child: imageWidget,
                    ),
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: content,
                      ),
                    ),
                  ]
                : [
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: content,
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: imageWidget,
                    ),
                  ],
            ),
          );
        }
      },
    );
  }

  Widget _buildProcessSection() {
    return Container(
      key: _processKey,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
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
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              const SectionTitle(
                title: "The Exclusive Process",
                subtitle: "Experience a premium therapeutic journey designed for discerning clients who value excellence and results.",
                centerAlign: true,
                textColor: Colors.white,
                showDivider: true,
              ),
              const SizedBox(height: 60),
              _buildProcessStepsLayout(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProcessStepsLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isMobile = screenWidth < 768;
        final isTablet = screenWidth >= 768 && screenWidth < 1024;
        
        if (isMobile) {
          // Stack vertically on mobile
          return Column(
            children: [
              AnimatedBuilder(
                animation: _processAnimationController,
                builder: (context, child) {
                  // Only animate when section is in view
                  if (!_animatedProcess) {
                    return child!;
                  }
                  return Transform.translate(
                    offset: Offset(
                      0,
                      (50 * (1 - _processAnimationController.value)),
                    ),
                    child: Opacity(
                      opacity: _processAnimationController.value,
                      child: child,
                    ),
                  );
                },
                child: _buildProcessStep(0, isMobile: true),
              ),
              const SizedBox(height: 40),
              AnimatedBuilder(
                animation: _processAnimationController,
                builder: (context, child) {
                  // Only animate when section is in view
                  if (!_animatedProcess) {
                    return child!;
                  }
                  return Transform.translate(
                    offset: Offset(
                      0,
                      (100 * (1 - _processAnimationController.value)),
                    ),
                    child: Opacity(
                      opacity: _processAnimationController.value,
                      child: child,
                    ),
                  );
                },
                child: _buildProcessStep(1, isMobile: true),
              ),
              const SizedBox(height: 40),
              AnimatedBuilder(
                animation: _processAnimationController,
                builder: (context, child) {
                  // Only animate when section is in view
                  if (!_animatedProcess) {
                    return child!;
                  }
                  return Transform.translate(
                    offset: Offset(
                      0,
                      (150 * (1 - _processAnimationController.value)),
                    ),
                    child: Opacity(
                      opacity: _processAnimationController.value,
                      child: child,
                    ),
                  );
                },
                child: _buildProcessStep(2, isMobile: true),
              ),
            ],
          );
        } else if (isTablet) {
          // Two columns on tablet
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _processAnimationController,
                      builder: (context, child) {
                        // Only animate when section is in view
                        if (!_animatedProcess) {
                          return child!;
                        }
                        return Transform.translate(
                          offset: Offset(
                            (-100 * (1 - _processAnimationController.value)),
                            0,
                          ),
                          child: Opacity(
                            opacity: _processAnimationController.value,
                            child: child,
                          ),
                        );
                      },
                      child: _buildProcessStep(0, isMobile: false),
                    ),
                  ),
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _processAnimationController,
                      builder: (context, child) {
                        // Only animate when section is in view
                        if (!_animatedProcess) {
                          return child!;
                        }
                        return Transform.translate(
                          offset: Offset(
                            (100 * (1 - _processAnimationController.value)),
                            0,
                          ),
                          child: Opacity(
                            opacity: _processAnimationController.value,
                            child: child,
                          ),
                        );
                      },
                      child: _buildProcessStep(1, isMobile: false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: screenWidth / 2,
                child: AnimatedBuilder(
                  animation: _processAnimationController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                        0,
                        (100 * (1 - _processAnimationController.value)),
                      ),
                      child: Opacity(
                        opacity: _processAnimationController.value,
                        child: child,
                      ),
                    );
                  },
                  child: _buildProcessStep(2, isMobile: false),
                ),
              ),
            ],
          );
        } else {
          // Row on desktop
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AnimatedBuilder(
                  animation: _processAnimationController,
                  builder: (context, child) {
                    // Only animate when section is in view
                    if (!_animatedProcess) {
                      return child!;
                    }
                    return Transform.translate(
                      offset: Offset(
                        (-200 * (1 - _processAnimationController.value)),
                        0,
                      ),
                      child: Opacity(
                        opacity: _processAnimationController.value,
                        child: child,
                      ),
                    );
                  },
                  child: _buildProcessStep(0, isMobile: false),
                ),
              ),
              Expanded(
                child: AnimatedBuilder(
                  animation: _processAnimationController,
                  builder: (context, child) {
                    // Only animate when section is in view
                    if (!_animatedProcess) {
                      return child!;
                    }
                    return Transform.translate(
                      offset: Offset(
                        0,
                        (100 * (1 - _processAnimationController.value)),
                      ),
                      child: Opacity(
                        opacity: _processAnimationController.value,
                        child: child,
                      ),
                    );
                  },
                  child: _buildProcessStep(1, isMobile: false),
                ),
              ),
              Expanded(
                child: AnimatedBuilder(
                  animation: _processAnimationController,
                  builder: (context, child) {
                    // Only animate when section is in view
                    if (!_animatedProcess) {
                      return child!;
                    }
                    return Transform.translate(
                      offset: Offset(
                        (200 * (1 - _processAnimationController.value)),
                        0,
                      ),
                      child: Opacity(
                        opacity: _processAnimationController.value,
                        child: child,
                      ),
                    );
                  },
                  child: _buildProcessStep(2, isMobile: false),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildProcessStep(int index, {required bool isMobile}) {
    final steps = [
      {
        'icon': Icons.chat_outlined,
        'title': "Initial Consultation",
        'description': "A private, in-depth discussion to understand your unique needs and goals, ensuring a perfect client-therapist alignment.",
      },
      {
        'icon': Icons.article_outlined,
        'title': "Tailored Strategy",
        'description': "Development of a sophisticated, evidence-based plan customized specifically for your psychological profile and objectives.",
      },
      {
        'icon': Icons.trending_up,
        'title': "Premium Sessions",
        'description': "Regular, exclusive sessions utilizing advanced psychological techniques to create meaningful and lasting transformation.",
      },
    ];

    final step = steps[index];
    
    return Padding(
      padding: EdgeInsets.all(isMobile ? 8.0 : 16.0),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.gold.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.gold,
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(
                step['icon'] as IconData,
                color: AppTheme.gold,
                size: 36,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            step['title'] as String,
            style: TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            step['description'] as String,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: isMobile ? 14 : 16,
              color: AppTheme.white.withOpacity(0.8),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCTASection() {
    return Container(
      key: _ctaKey,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      color: AppTheme.white,
      child: Center(
        child: AnimatedBuilder(
          animation: _ctaAnimationController,
          builder: (context, child) {
            // Only animate when section is in view
            if (!_animatedCta) {
              return child!;
            }
            return Transform.translate(
              offset: Offset(
                0,
                (100 * (1 - _ctaAnimationController.value)),
              ),
              child: Opacity(
                opacity: _ctaAnimationController.value,
                child: child,
              ),
            );
          },
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 2,
                  color: AppTheme.gold,
                  margin: const EdgeInsets.only(bottom: 24),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final screenWidth = constraints.maxWidth;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Begin Your Premium Psychological Journey",
                        style: TextStyle(
                          fontFamily: 'Playfair Display',
                          fontSize: screenWidth < 600 ? 26 : 32,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkText,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Schedule your confidential consultation today and take the first step toward extraordinary mental wellbeing and elite performance.",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                      color: AppTheme.darkText.withOpacity(0.8),
                      height: 1.5,
                      letterSpacing: 0.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 600;
                    return PremiumButton(
                      text: AppConstants.ctaButtonText,
                      width: isMobile ? double.infinity : 240,
                      onPressed: () {
                        widget.onNavigate(4); // Navigate to Contact
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 