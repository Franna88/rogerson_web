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
                title: "Our Services",
                subtitle: "Professional therapy and counseling services to support your mental health and wellbeing",
                centerAlign: true,
              ),
              const SizedBox(height: 60),
              // Anxiety & Stress
              AnimatedBuilder(
                animation: _servicesAnimationController,
                builder: (context, child) {
                  if (!_animatedServices) return child!;
                  return Transform.translate(
                    offset: Offset((-300 * (1 - _servicesAnimationController.value)), 0),
                    child: Opacity(opacity: _servicesAnimationController.value, child: child),
                  );
                },
                child: _buildServiceDetail(
                  title: "Anxiety & Stress",
                  description: "Professional support and evidence-based techniques to help you manage anxiety and stress effectively. Learn practical coping strategies and develop resilience for daily challenges.",
                  image: 'https://images.unsplash.com/photo-1474418397713-7ede21d49118?q=80&w=2053&auto=format&fit=crop',
                  icon: Icons.healing,
                  benefits: [
                    "Learn effective anxiety management techniques",
                    "Develop stress coping strategies",
                    "Build emotional resilience",
                    "Improve work-life balance"
                  ],
                  isImageLeft: true,
                ),
              ),
              const SizedBox(height: 40),
              // Depression
              AnimatedBuilder(
                animation: _servicesAnimationController,
                builder: (context, child) {
                  if (!_animatedServices) return child!;
                  return Transform.translate(
                    offset: Offset((300 * (1 - _servicesAnimationController.value)), 0),
                    child: Opacity(opacity: _servicesAnimationController.value, child: child),
                  );
                },
                child: _buildServiceDetail(
                  title: "Depression",
                  description: "Compassionate therapy to help you understand and work through depression. We'll work together to find hope, restore energy, and rebuild a meaningful life.",
                  image: 'https://images.unsplash.com/photo-1541199249251-f713e6145474?q=80&w=1974&auto=format&fit=crop',
                  icon: Icons.psychology,
                  benefits: [
                    "Understand and manage depressive symptoms",
                    "Develop healthy coping mechanisms",
                    "Rebuild motivation and energy",
                    "Create a support system"
                  ],
                  isImageLeft: false,
                ),
              ),
              const SizedBox(height: 40),
              // Burnout
              AnimatedBuilder(
                animation: _servicesAnimationController,
                builder: (context, child) {
                  if (!_animatedServices) return child!;
                  return Transform.translate(
                    offset: Offset((-300 * (1 - _servicesAnimationController.value)), 0),
                    child: Opacity(opacity: _servicesAnimationController.value, child: child),
                  );
                },
                child: _buildServiceDetail(
                  title: "Burnout",
                  description: "Support for professionals experiencing burnout. Learn to recognize early warning signs, restore your energy, and create sustainable work-life practices.",
                  image: 'https://plus.unsplash.com/premium_photo-1661699202058-9c5c36a4fe32?q=80&w=774&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  icon: Icons.battery_alert,
                  benefits: [
                    "Identify burnout triggers and warning signs",
                    "Develop energy management strategies",
                    "Create healthy boundaries",
                    "Restore work-life balance"
                  ],
                  isImageLeft: true,
                ),
              ),
              const SizedBox(height: 40),
              // Trauma
              AnimatedBuilder(
                animation: _servicesAnimationController,
                builder: (context, child) {
                  if (!_animatedServices) return child!;
                  return Transform.translate(
                    offset: Offset((300 * (1 - _servicesAnimationController.value)), 0),
                    child: Opacity(opacity: _servicesAnimationController.value, child: child),
                  );
                },
                child: _buildServiceDetail(
                  title: "Trauma",
                  description: "Gentle, trauma-informed therapy to help you process and heal from past experiences. We'll work at your pace to build safety, stability, and resilience.",
                  image: 'https://images.unsplash.com/photo-1469571486292-0ba58a3f068b?q=80&w=2070&auto=format&fit=crop',
                  icon: Icons.health_and_safety,
                  benefits: [
                    "Process traumatic experiences safely",
                    "Develop coping strategies",
                    "Build emotional safety",
                    "Restore sense of control"
                  ],
                  isImageLeft: false,
                ),
              ),
              const SizedBox(height: 40),
              // Grief & Bereavement
              AnimatedBuilder(
                animation: _servicesAnimationController,
                builder: (context, child) {
                  if (!_animatedServices) return child!;
                  return Transform.translate(
                    offset: Offset((-300 * (1 - _servicesAnimationController.value)), 0),
                    child: Opacity(opacity: _servicesAnimationController.value, child: child),
                  );
                },
                child: _buildServiceDetail(
                  title: "Grief & Bereavement",
                  description: "Supportive counseling to help you navigate the complex journey of loss and grief. Find ways to honor your experience while moving forward with hope.",
                  image: 'https://images.unsplash.com/photo-1492176273113-2d51f47b23b0?q=80&w=2070&auto=format&fit=crop',
                  icon: Icons.favorite_border,
                  benefits: [
                    "Process grief in a safe environment",
                    "Learn to cope with loss",
                    "Find meaning and purpose",
                    "Build a support network"
                  ],
                  isImageLeft: true,
                ),
              ),
              const SizedBox(height: 40),
              // Couples Counselling
              AnimatedBuilder(
                animation: _servicesAnimationController,
                builder: (context, child) {
                  if (!_animatedServices) return child!;
                  return Transform.translate(
                    offset: Offset((300 * (1 - _servicesAnimationController.value)), 0),
                    child: Opacity(opacity: _servicesAnimationController.value, child: child),
                  );
                },
                child: _buildServiceDetail(
                  title: "Couples Counselling",
                  description: "Professional support for couples seeking to strengthen their relationship. Improve communication, resolve conflicts, and build a deeper connection.",
                  image: 'https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?q=80&w=1974&auto=format&fit=crop',
                  icon: Icons.people_outline,
                  benefits: [
                    "Enhance communication skills",
                    "Resolve relationship conflicts",
                    "Rebuild trust and intimacy",
                    "Strengthen emotional bonds"
                  ],
                  isImageLeft: false,
                ),
              ),
              const SizedBox(height: 40),
              // Family Problems
              AnimatedBuilder(
                animation: _servicesAnimationController,
                builder: (context, child) {
                  if (!_animatedServices) return child!;
                  return Transform.translate(
                    offset: Offset((-300 * (1 - _servicesAnimationController.value)), 0),
                    child: Opacity(opacity: _servicesAnimationController.value, child: child),
                  );
                },
                child: _buildServiceDetail(
                  title: "Family Problems",
                  description: "Support for families facing challenges and transitions. Improve understanding, communication, and relationships between family members.",
                  image: 'https://images.unsplash.com/photo-1511895426328-dc8714191300?q=80&w=2070&auto=format&fit=crop',
                  icon: Icons.family_restroom,
                  benefits: [
                    "Improve family communication",
                    "Resolve family conflicts",
                    "Strengthen family bonds",
                    "Navigate family transitions"
                  ],
                  isImageLeft: true,
                ),
              ),
              const SizedBox(height: 40),
              // Adolescent Distress
              AnimatedBuilder(
                animation: _servicesAnimationController,
                builder: (context, child) {
                  if (!_animatedServices) return child!;
                  return Transform.translate(
                    offset: Offset((300 * (1 - _servicesAnimationController.value)), 0),
                    child: Opacity(opacity: _servicesAnimationController.value, child: child),
                  );
                },
                child: _buildServiceDetail(
                  title: "Adolescent Distress",
                  description: "Specialized support for young people navigating emotional challenges. Help with identity, relationships, school stress, and life transitions.",
                  image: 'https://images.unsplash.com/photo-1527236438218-d82077ae1f85?q=80&w=774&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  icon: Icons.person_outline,
                  benefits: [
                    "Address emotional challenges",
                    "Build self-esteem and confidence",
                    "Improve peer relationships",
                    "Develop coping skills"
                  ],
                  isImageLeft: false,
                ),
              ),
              const SizedBox(height: 40),
              // Life Changes
              AnimatedBuilder(
                animation: _servicesAnimationController,
                builder: (context, child) {
                  if (!_animatedServices) return child!;
                  return Transform.translate(
                    offset: Offset((-300 * (1 - _servicesAnimationController.value)), 0),
                    child: Opacity(opacity: _servicesAnimationController.value, child: child),
                  );
                },
                child: _buildServiceDetail(
                  title: "Life Changes & Adjustment",
                  description: "Support during major life transitions and adjustments. Navigate changes with confidence and find new direction and purpose.",
                  image: 'https://images.unsplash.com/photo-1504150558240-0b4fd8946624?q=80&w=928&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  icon: Icons.change_circle_outlined,
                  benefits: [
                    "Navigate life transitions",
                    "Build adaptability skills",
                    "Find new purpose and direction",
                    "Develop resilience"
                  ],
                  isImageLeft: true,
                ),
              ),
              const SizedBox(height: 40),
              // Bipolar Mood Disorder
              AnimatedBuilder(
                animation: _servicesAnimationController,
                builder: (context, child) {
                  if (!_animatedServices) return child!;
                  return Transform.translate(
                    offset: Offset((300 * (1 - _servicesAnimationController.value)), 0),
                    child: Opacity(opacity: _servicesAnimationController.value, child: child),
                  );
                },
                child: _buildServiceDetail(
                  title: "Bipolar Mood Disorder",
                  description: "Professional support for managing bipolar disorder. Learn to understand your symptoms, maintain stability, and improve quality of life.",
                  image: 'https://images.unsplash.com/photo-1474418397713-7ede21d49118?q=80&w=2053&auto=format&fit=crop',
                  icon: Icons.balance,
                  benefits: [
                    "Understand and manage symptoms",
                    "Develop stability strategies",
                    "Create support systems",
                    "Improve daily functioning"
                  ],
                  isImageLeft: false,
                ),
              ),
              const SizedBox(height: 40),
              // Disability & Aging
              AnimatedBuilder(
                animation: _servicesAnimationController,
                builder: (context, child) {
                  if (!_animatedServices) return child!;
                  return Transform.translate(
                    offset: Offset((-300 * (1 - _servicesAnimationController.value)), 0),
                    child: Opacity(opacity: _servicesAnimationController.value, child: child),
                  );
                },
                child: _buildServiceDetail(
                  title: "Disability & Aging",
                  description: "Compassionate support for adapting to changes in ability and the aging process. Focus on maintaining independence and quality of life.",
                  image: 'https://images.unsplash.com/photo-1454418747937-bd95bb945625?q=80&w=2070&auto=format&fit=crop',
                  icon: Icons.accessibility_new,
                  
                  benefits: [
                    "Adapt to physical changes",
                    "Maintain independence",
                    "Build coping strategies",
                    "Enhance quality of life"
                  ],
                  isImageLeft: true,
                ),
              ),
              const SizedBox(height: 40),
              // Chronic Pain
              AnimatedBuilder(
                animation: _servicesAnimationController,
                builder: (context, child) {
                  if (!_animatedServices) return child!;
                  return Transform.translate(
                    offset: Offset((300 * (1 - _servicesAnimationController.value)), 0),
                    child: Opacity(opacity: _servicesAnimationController.value, child: child),
                  );
                },
                child: _buildServiceDetail(
                  title: "Chronic Pain",
                  description: "Psychological support for managing chronic pain. Learn strategies to cope with pain, improve daily functioning, and enhance quality of life.",
                  image: 'https://images.unsplash.com/photo-1633158832532-f71e9c7ac6d6?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  icon: Icons.medical_services_outlined,
                  benefits: [
                    "Develop pain management strategies",
                    "Improve daily functioning",
                    "Build emotional resilience",
                    "Enhance overall wellbeing"
                  ],
                  isImageLeft: false,
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
                title: "Our Process",
                subtitle: "A supportive therapeutic journey focused on your growth and wellbeing.",
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
        'description': "A friendly discussion to understand your needs and goals, ensuring we can work well together.",
      },
      {
        'icon': Icons.article_outlined,
        'title': "Personalized Plan",
        'description': "Development of an evidence-based plan that fits your specific situation and objectives.",
      },
      {
        'icon': Icons.trending_up,
        'title': "Regular Sessions",
        'description': "Consistent therapy sessions using proven psychological techniques to help you achieve positive change.",
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
                        "Begin Your Psychological Journey",
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
                    "Schedule your confidential consultation today and take the first step toward improved mental wellbeing and enhanced performance.",
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