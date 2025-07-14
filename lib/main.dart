import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';
import 'screens/about_screen.dart';
import 'screens/services_screen.dart';
import 'screens/contact_screen.dart';
import 'theme/app_theme.dart';
import 'constants/app_constants.dart';
import 'widgets/premium_app_bar.dart';
import 'widgets/scroll_reveal_widget.dart';
import 'utils/gold_foil_effect.dart';
import 'utils/gold_text_effect.dart';

// Global variable to hold the preloaded gold foil image
ui.Image? goldFoilImage;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Preload the gold foil image
  await _preloadGoldFoilImage();
  
  runApp(const MyApp());
}

Future<void> _preloadGoldFoilImage() async {
  try {
    final ByteData data = await rootBundle.load('images/gold_foil.jpg');
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: 1024,
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    goldFoilImage = frameInfo.image;
    print('Gold foil image preloaded successfully');
  } catch (e) {
    print('Error preloading gold foil image: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isScrolled = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 20 && !_isScrolled) {
      setState(() {
        _isScrolled = true;
      });
    } else if (_scrollController.offset <= 20 && _isScrolled) {
      setState(() {
        _isScrolled = false;
      });
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    // Scroll to top when switching pages
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PremiumAppBar(
        isScrolled: _isScrolled,
        selectedIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.axis == Axis.vertical) {
            // Update _isScrolled based on scroll position for better responsiveness
            if (scrollInfo.metrics.pixels > 20 && !_isScrolled) {
              setState(() {
                _isScrolled = true;
              });
            } else if (scrollInfo.metrics.pixels <= 20 && _isScrolled) {
              setState(() {
                _isScrolled = false;
              });
            }
          }
          return true;
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              _buildCurrentScreen(),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    // Reset state of ScrollControllers before switching screens
    Future.microtask(() {
      if (_selectedIndex == 0) {
        // Reset home screen
      } else if (_selectedIndex == 1) {
        // Reset about screen
      } else if (_selectedIndex == 2) {
        // Reset services screen animations
        // The services screen animations will reset automatically due to the
        // implementation of its _checkVisibility method
      }
    });
    
    switch (_selectedIndex) {
      case 0:
        return HomeScreen(onNavigate: _onTabSelected);
      case 1:
        return AboutScreen(onNavigate: _onTabSelected);
      case 2:
        return ServicesScreen(onNavigate: _onTabSelected);
      case 3:
        return const ContactScreen();
      default:
        return HomeScreen(onNavigate: _onTabSelected);
    }
  }

  Widget _buildFooter() {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    final bool isTablet = MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 960;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 60, 
        horizontal: isMobile ? 16 : 24,
      ),
      color: AppTheme.charcoal,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Gold accent line at the top
          Container(
            width: 60,
            height: 2,
            color: AppTheme.gold,
            margin: const EdgeInsets.only(bottom: 40),
          ),
          if (isMobile) 
            // Mobile layout - stacked columns
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo and description
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GoldTextEffect(
                      scale: 0.3,
                      child: Text(
                        AppConstants.appName,
                        style: const TextStyle(
                          fontFamily: 'Playfair Display',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.gold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Clinical psychology services for all clients. Confidential, personalized, and results-oriented therapy.",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        color: AppTheme.white.withOpacity(0.8),
                        height: 1.6,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        _buildSocialIcon(Icons.facebook, "Facebook"),
                        const SizedBox(width: 20),
                        _buildSocialIcon(Icons.work_outline, "LinkedIn"),
                        const SizedBox(width: 20),
                        _buildSocialIcon(Icons.send, "Telegram"),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                
                // Member of section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFooterSectionTitle("Member of"),
                    const SizedBox(height: 20),
                    MediaQuery.of(context).size.width < 800 
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // HPCSA Logo and text
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'images/HPCSA.jpg',
                                height: 60,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Health Professions Council of South Africa",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 12,
                                  color: AppTheme.white.withOpacity(0.8),
                                ),
                              ),
                              Text(
                                "Reg No: PS0139874",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 12,
                                  color: AppTheme.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          // PsySSA Logo and text
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'images/PsySSA-Logo.png',
                                height: 60,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Psychological Society of South Africa",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 12,
                                  color: AppTheme.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          // HPCSA Logo and text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'images/HPCSA.jpg',
                                  height: 60,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Health Professions Council of South Africa",
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    color: AppTheme.white.withOpacity(0.8),
                                  ),
                                ),
                                Text(
                                  "Reg No: PS0139874",
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    color: AppTheme.white.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          // PsySSA Logo and text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'images/PsySSA-Logo.png',
                                  height: 60,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Psychological Society of South Africa",
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    color: AppTheme.white.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 50),

                // Navigation section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFooterSectionTitle("Navigation"),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: [
                        _buildFooterLinkMobile("Home", 0),
                        _buildFooterLinkMobile("About", 1),
                        _buildFooterLinkMobile("Services", 2),
                        _buildFooterLinkMobile("Contact", 3),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                
                // Services section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFooterSectionTitle("Services"),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: [
                        _buildFooterLinkMobile("Professional Counseling", 2),
                        _buildFooterLinkMobile("Relationship Support", 2),
                        _buildFooterLinkMobile("Stress Management", 2),
                      ],
                    ),
                  ],
                ),
              ],
            )
          else
            // Desktop and tablet layout
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo and description section
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GoldTextEffect(
                            scale: 0.3,
                            child: Text(
                              AppConstants.appName,
                              style: const TextStyle(
                                fontFamily: 'Playfair Display',
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.gold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Clinical psychology services for discerning clients. Confidential, personalized, and results-oriented therapy.",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              color: AppTheme.white.withOpacity(0.8),
                              height: 1.6,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              _buildSocialIcon(Icons.facebook, "Facebook"),
                              const SizedBox(width: 20),
                              _buildSocialIcon(Icons.work_outline, "LinkedIn"),
                              const SizedBox(width: 20),
                              _buildSocialIcon(Icons.send, "Telegram"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 60),
                    // Member of section with adjusted flex
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFooterSectionTitle("Member of"),
                          const SizedBox(height: 20),
                          MediaQuery.of(context).size.width < 1200
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // HPCSA Logo and text
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'images/HPCSA.jpg',
                                      height: 60,
                                      fit: BoxFit.contain,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Health Professions Council of South Africa",
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 12,
                                        color: AppTheme.white.withOpacity(0.8),
                                      ),
                                    ),
                                    Text(
                                      "Reg No: PS0139874",
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 12,
                                        color: AppTheme.white.withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                // PsySSA Logo and text
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'images/PsySSA-Logo.png',
                                      height: 60,
                                      fit: BoxFit.contain,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Psychological Society of South Africa",
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 12,
                                        color: AppTheme.white.withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // HPCSA Logo and text
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        'images/HPCSA.jpg',
                                        height: 60,
                                        fit: BoxFit.contain,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Health Professions Council of South Africa",
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 12,
                                          color: AppTheme.white.withOpacity(0.8),
                                        ),
                                      ),
                                      Text(
                                        "Reg No: PS0139874",
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 12,
                                          color: AppTheme.white.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                // PsySSA Logo and text
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        'images/PsySSA-Logo.png',
                                        height: 60,
                                        fit: BoxFit.contain,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Psychological Society of South Africa",
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 12,
                                          color: AppTheme.white.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 60),
                    // Navigation and Services in a column for better space management
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFooterSectionTitle("Navigation"),
                          const SizedBox(height: 20),
                          _buildFooterLink("Home", 0),
                          const SizedBox(height: 12),
                          _buildFooterLink("About", 1),
                          const SizedBox(height: 12),
                          _buildFooterLink("Services", 2),
                          const SizedBox(height: 12),
                          _buildFooterLink("Contact", 3),
                          const SizedBox(height: 40),
                          _buildFooterSectionTitle("Services"),
                          const SizedBox(height: 20),
                          _buildFooterLink("Professional Counseling", 2),
                          const SizedBox(height: 12),
                          _buildFooterLink("Relationship Support", 2),
                          const SizedBox(height: 12),
                          _buildFooterLink("Stress Management", 2),
                        ],
                      ),
                    ),
                    if (!isTablet) ...[
                      const SizedBox(width: 60),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFooterSectionTitle("Legal"),
                            const SizedBox(height: 20),
                            _buildFooterLink("Privacy Policy", -1),
                            const SizedBox(height: 12),
                            _buildFooterLink("Terms of Service", -1),
                            const SizedBox(height: 12),
                            _buildFooterLink("Disclaimer", -1),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                if (isTablet) ...[
                  const SizedBox(height: 50),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFooterSectionTitle("Legal"),
                            const SizedBox(height: 20),
                            _buildFooterLink("Privacy Policy", -1),
                            const SizedBox(height: 12),
                            _buildFooterLink("Terms of Service", -1),
                            const SizedBox(height: 12),
                            _buildFooterLink("Disclaimer", -1),
                          ],
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ],
              ],
            ),
          const SizedBox(height: 60),
          Container(
            width: double.infinity,
            height: 1,
            color: AppTheme.white.withOpacity(0.1),
            margin: const EdgeInsets.only(bottom: 30),
          ),
          // Copyright section
          if (isMobile) 
            // Stacked copyright for mobile
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "© ${DateTime.now().year} ${AppConstants.appName}",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    color: AppTheme.white.withOpacity(0.7),
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "All rights reserved.",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    color: AppTheme.white.withOpacity(0.7),
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFooterSmallLink("Privacy"),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                    _buildFooterSmallLink("Terms"),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                    _buildFooterSmallLink("Cookies"),
                  ],
                ),
              ],
            )
          else
            // Row for tablet and desktop
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "© ${DateTime.now().year} ${AppConstants.appName}. All rights reserved.",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    color: AppTheme.white.withOpacity(0.7),
                    letterSpacing: 0.5,
                  ),
                ),
                Row(
                  children: [
                    _buildFooterSmallLink("Privacy"),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                    _buildFooterSmallLink("Terms"),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                    _buildFooterSmallLink("Cookies"),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildFooterSectionTitle(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.gold,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 24,
          height: 2,
          color: AppTheme.gold.withOpacity(0.5),
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, String tooltip) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Tooltip(
        message: tooltip,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.gold.withOpacity(0.3),
              width: 1,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppTheme.gold,
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildFooterLink(String text, int index) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () {
          if (index >= 0) {
            _onTabSelected(index);
          }
        },
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 1,
              color: AppTheme.gold.withOpacity(0),
              margin: const EdgeInsets.only(right: 8),
            ),
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                color: AppTheme.white.withOpacity(0.8),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterSmallLink(String text) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 14,
          color: AppTheme.white.withOpacity(0.7),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildFooterLinkMobile(String text, int index) {
    return InkWell(
      onTap: () {
        if (index >= 0) {
          _onTabSelected(index);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.gold.withOpacity(0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            color: AppTheme.white.withOpacity(0.9),
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

