import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';
import '../widgets/premium_button.dart';
import '../widgets/section_title.dart';
import '../utils/gold_text_effect.dart';

class AboutScreen extends StatelessWidget {
  final Function(int) onNavigate;

  const AboutScreen({
    super.key,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          _buildHeroSection(context),
          _buildBioSection(),
          _buildQualificationsSection(),
          _buildApproachSection(context),
          _buildCTASection(),
        ],
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
          image: const NetworkImage('https://images.unsplash.com/photo-1551215717-3118af50955e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1770&q=80'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            AppTheme.charcoal.withOpacity(0.6),
            BlendMode.darken,
          ),
          onError: (_, __) {
            // Fallback to solid color if image fails to load
          },
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80), // Space for AppBar
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
                  AppConstants.aboutTitle,
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
                AppConstants.aboutSubtitle,
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

  Widget _buildBioSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      color: AppTheme.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final isMobile = screenWidth < 768;
              
              if (isMobile) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildProfileImage(),
                    const SizedBox(height: 40),
                    _buildBioContent(),
                  ],
                );
              } else {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: _buildProfileImage(),
                    ),
                    const SizedBox(width: 60),
                    Expanded(
                      flex: 6,
                      child: _buildBioContent(),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return HoverBorderCard(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 450),
        child: AspectRatio(
          aspectRatio: 3 / 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'images/clientImg.jpg',
              fit: BoxFit.cover,
              
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppTheme.lightSilver,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_outline,
                          color: AppTheme.darkText.withOpacity(0.5),
                          size: 60,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Professional Portrait",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.darkText.withOpacity(0.6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBioContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 50,
          height: 2,
          color: AppTheme.gold,
          margin: const EdgeInsets.only(bottom: 24),
        ),
        GoldTextEffect(
          scale: 0.4,
          child: HoverHighlightText(
            text: "About Me",
            style: const TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkText,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          AppConstants.aboutDescription,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            color: AppTheme.darkText.withOpacity(0.8),
            height: 1.8,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "My philosophy is centered on the understanding that exceptional individuals require exceptional care. I believe in a holistic approach that addresses both immediate challenges and long-term psychological resilience, tailored specifically for high-achieving professionals.",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            color: AppTheme.darkText.withOpacity(0.8),
            height: 1.8,
          ),
        ),
        const SizedBox(height: 40),
        HoverTextLink(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.gold,
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.mail_outline,
                  color: AppTheme.gold,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                "contact@nathanrogerson.com",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.accentBlue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQualificationsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      color: AppTheme.lightSilver.withOpacity(0.2),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              SectionTitle(
                title: AppConstants.qualificationsTitle,
                subtitle: "Nathan Rogerson brings world-class credentials and specialized expertise to his practice, ensuring clients receive the highest standard of psychological care.",
                centerAlign: true,
              ),
              const SizedBox(height: 60),
              LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = constraints.maxWidth;
                  
                  final double cardWidth = 350;
                  final int cardsPerRow = (screenWidth / cardWidth).floor();
                  
                  final int totalCards = AppConstants.qualifications.length;
                  final int rows = (totalCards / cardsPerRow).ceil();
                  
                  return Column(
                    children: List.generate(rows, (rowIndex) {
                      final int startIndex = rowIndex * cardsPerRow;
                      final int endIndex = (startIndex + cardsPerRow < totalCards) 
                          ? startIndex + cardsPerRow 
                          : totalCards;
                          
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          alignment: WrapAlignment.center,
                          children: List.generate(
                            endIndex - startIndex,
                            (index) => _buildQualificationCard(
                              AppConstants.qualifications[startIndex + index],
                              startIndex + index,
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQualificationCard(String qualification, int index) {
    final icons = [
      Icons.school,
      Icons.business,
      Icons.psychology,
      Icons.menu_book,
      Icons.public,
    ];

    return HoverScaleCard(
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: AppTheme.silver.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.lightGold.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icons[index % icons.length],
                color: AppTheme.gold,
                size: 26,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                qualification,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  color: AppTheme.darkText.withOpacity(0.9),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApproachSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 100),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.charcoal,
            AppTheme.charcoal.withOpacity(0.9),
          ],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
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
                    AppConstants.approachTitle,
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: MediaQuery.of(context).size.width < 600 ? 28 : 36,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.white,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  AppConstants.approachDescription,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: MediaQuery.of(context).size.width < 600 ? 16 : 18,
                    color: AppTheme.white,
                    height: 1.8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 60),
              LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = constraints.maxWidth;
                  
                  if (screenWidth < 480) {
                    return Column(
                      children: [
                        _buildApproachItem("Confidentiality", Icons.lock_outline),
                        const SizedBox(height: 20),
                        _buildApproachItem("Evidence-Based", Icons.science_outlined),
                        const SizedBox(height: 20),
                        _buildApproachItem("Personalized Care", Icons.person_outline),
                        const SizedBox(height: 20),
                        _buildApproachItem("Results-Focused", Icons.trending_up),
                      ],
                    );
                  } else {
                    return Wrap(
                      spacing: 30,
                      runSpacing: 30,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildApproachItem("Confidentiality", Icons.lock_outline),
                        _buildApproachItem("Evidence-Based", Icons.science_outlined),
                        _buildApproachItem("Personalized Care", Icons.person_outline),
                        _buildApproachItem("Results-Focused", Icons.trending_up),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildApproachItem(String text, IconData icon) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isInWrap = constraints.maxWidth > 300;
        
        return HoverGlowCard(
          color: AppTheme.gold.withOpacity(0.2),
          child: Container(
            width: isInWrap ? 200 : double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.gold.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: AppTheme.gold,
                  size: 36,
                ),
                const SizedBox(height: 16),
                Text(
                  text,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCTASection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      color: AppTheme.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final screenWidth = constraints.maxWidth;
                    
                    return GoldTextEffect(
                      scale: 0.4,
                      child: Text(
                        "Ready to experience transformative\npsychological care?",
                        style: TextStyle(
                          fontFamily: 'Playfair Display',
                          fontSize: screenWidth < 600 ? 26 : 32,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Schedule your private consultation to explore how Nathan Rogerson's expertise can support your psychological wellbeing and professional success.",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    color: AppTheme.darkText.withOpacity(0.8),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              HoverElevateCard(
                child: PremiumButton(
                  text: AppConstants.ctaButtonText,
                  onPressed: () {
                    onNavigate(4); // Navigate to Contact
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Hover effect widget for scale animation
class HoverScaleCard extends StatefulWidget {
  final Widget child;
  
  const HoverScaleCard({
    super.key,
    required this.child,
  });

  @override
  State<HoverScaleCard> createState() => _HoverScaleCardState();
}

class _HoverScaleCardState extends State<HoverScaleCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _isHovered ? (Matrix4.identity()..scale(1.03)) : Matrix4.identity(),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: _isHovered 
                  ? AppTheme.gold.withOpacity(0.15) 
                  : Colors.transparent,
              blurRadius: 20,
              spreadRadius: 1,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}

// Hover effect widget for glow animation
class HoverGlowCard extends StatefulWidget {
  final Widget child;
  final Color color;
  
  const HoverGlowCard({
    super.key,
    required this.child,
    required this.color,
  });

  @override
  State<HoverGlowCard> createState() => _HoverGlowCardState();
}

class _HoverGlowCardState extends State<HoverGlowCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: _isHovered ? (Matrix4.identity()..scale(1.05)) : Matrix4.identity(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: _isHovered 
                  ? widget.color 
                  : Colors.transparent,
              blurRadius: 16,
              spreadRadius: 0,
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}

// Hover effect widget for border animation
class HoverBorderCard extends StatefulWidget {
  final Widget child;
  
  const HoverBorderCard({
    super.key,
    required this.child,
  });

  @override
  State<HoverBorderCard> createState() => _HoverBorderCardState();
}

class _HoverBorderCardState extends State<HoverBorderCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _isHovered ? AppTheme.gold : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered 
                  ? AppTheme.gold.withOpacity(0.1)
                  : Colors.transparent,
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        padding: const EdgeInsets.all(2), // To accommodate the border
        child: widget.child,
      ),
    );
  }
}

// Hover effect widget for elevation animation
class HoverElevateCard extends StatefulWidget {
  final Widget child;
  
  const HoverElevateCard({
    super.key,
    required this.child,
  });

  @override
  State<HoverElevateCard> createState() => _HoverElevateCardState();
}

class _HoverElevateCardState extends State<HoverElevateCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _isHovered 
          ? (Matrix4.identity()..translate(0.0, -8.0, 0.0)) 
          : Matrix4.identity(),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: _isHovered 
                  ? AppTheme.gold.withOpacity(0.3)
                  : Colors.transparent,
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}

// Hover effect widget for text link
class HoverTextLink extends StatefulWidget {
  final Widget child;
  
  const HoverTextLink({
    super.key,
    required this.child,
  });

  @override
  State<HoverTextLink> createState() => _HoverTextLinkState();
}

class _HoverTextLinkState extends State<HoverTextLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _isHovered ? (Matrix4.identity()..scale(1.02)) : Matrix4.identity(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: _isHovered ? AppTheme.lightGold.withOpacity(0.1) : Colors.transparent,
        ),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: widget.child,
      ),
    );
  }
}

// Hover effect widget for text highlighting
class HoverHighlightText extends StatefulWidget {
  final String text;
  final TextStyle style;
  
  const HoverHighlightText({
    super.key,
    required this.text,
    required this.style,
  });

  @override
  State<HoverHighlightText> createState() => _HoverHighlightTextState();
}

class _HoverHighlightTextState extends State<HoverHighlightText> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: widget.style.copyWith(
          color: _isHovered ? AppTheme.gold : widget.style.color,
          shadows: _isHovered ? [
            Shadow(
              color: AppTheme.gold.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 0),
            ),
          ] : null,
        ),
        child: Text(widget.text),
      ),
    );
  }
} 