import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/about_screen.dart';
import 'screens/services_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/blog_screen.dart';
import 'theme/app_theme.dart';
import 'constants/app_constants.dart';
import 'widgets/premium_app_bar.dart';

void main() {
  runApp(const MyApp());
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

class _MainScreenState extends State<MainScreen> {
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
      } else if (_selectedIndex == 3) {
        // Reset blog screen
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
        return BlogScreen(onNavigate: _onTabSelected);
      case 4:
        return const ContactScreen();
      default:
        return HomeScreen(onNavigate: _onTabSelected);
    }
  }

  Widget _buildFooter() {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    final bool isTablet = MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 960;
    
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 30 : 40, 
        horizontal: isMobile ? 16 : 24,
      ),
      color: AppTheme.charcoal,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isMobile) 
            // Mobile layout - stacked columns
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo and description
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppConstants.appName,
                      style: const TextStyle(
                        fontFamily: 'Playfair Display',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Premium psychological services for discerning clients. Confidential, personalized, and results-oriented therapy.",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        color: AppTheme.white.withOpacity(0.7),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        _buildSocialIcon(Icons.facebook),
                        const SizedBox(width: 16),
                        _buildSocialIcon(Icons.work_outline),
                        const SizedBox(width: 16),
                        _buildSocialIcon(Icons.send),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                
                // Navigation section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Navigation",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: [
                        _buildFooterLinkMobile("Home", 0),
                        _buildFooterLinkMobile("About", 1),
                        _buildFooterLinkMobile("Services", 2),
                        _buildFooterLinkMobile("Blog", 3),
                        _buildFooterLinkMobile("Contact", 4),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                
                // Services section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Services",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: [
                        _buildFooterLinkMobile("Executive Therapy", 2),
                        _buildFooterLinkMobile("Relationship Coaching", 2),
                        _buildFooterLinkMobile("Stress Management", 2),
                      ],
                    ),
                  ],
                ),
              ],
            )
          else if (isTablet)
            // Tablet layout - two column grid
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First column - logo and description
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppConstants.appName,
                            style: const TextStyle(
                              fontFamily: 'Playfair Display',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Premium psychological services for discerning clients. Confidential, personalized, and results-oriented therapy.",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              color: AppTheme.white.withOpacity(0.7),
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              _buildSocialIcon(Icons.facebook),
                              const SizedBox(width: 16),
                              _buildSocialIcon(Icons.work_outline),
                              const SizedBox(width: 16),
                              _buildSocialIcon(Icons.send),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
                    // Second column - navigation links
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Navigation",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildFooterLink("Home", 0),
                          const SizedBox(height: 12),
                          _buildFooterLink("About", 1),
                          const SizedBox(height: 12),
                          _buildFooterLink("Services", 2),
                          const SizedBox(height: 12),
                          _buildFooterLink("Blog", 3),
                          const SizedBox(height: 12),
                          _buildFooterLink("Contact", 4),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Third column - services
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Services",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildFooterLink("Executive Therapy", 2),
                          const SizedBox(height: 12),
                          _buildFooterLink("Relationship Coaching", 2),
                          const SizedBox(height: 12),
                          _buildFooterLink("Stress Management", 2),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
                    // Fourth column - legal
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Legal",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildFooterLink("Privacy Policy", -1),
                          const SizedBox(height: 12),
                          _buildFooterLink("Terms of Service", -1),
                          const SizedBox(height: 12),
                          _buildFooterLink("Disclaimer", -1),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )
          else
            // Desktop layout - original four column grid
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppConstants.appName,
                        style: const TextStyle(
                          fontFamily: 'Playfair Display',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Premium psychological services for discerning clients. Confidential, personalized, and results-oriented therapy.",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          color: AppTheme.white.withOpacity(0.7),
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          _buildSocialIcon(Icons.facebook),
                          const SizedBox(width: 16),
                          _buildSocialIcon(Icons.work_outline),
                          const SizedBox(width: 16),
                          _buildSocialIcon(Icons.send),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Navigation",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildFooterLink("Home", 0),
                      const SizedBox(height: 12),
                      _buildFooterLink("About", 1),
                      const SizedBox(height: 12),
                      _buildFooterLink("Services", 2),
                      const SizedBox(height: 12),
                      _buildFooterLink("Blog", 3),
                      const SizedBox(height: 12),
                      _buildFooterLink("Contact", 4),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Services",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildFooterLink("Executive Therapy", 2),
                      const SizedBox(height: 12),
                      _buildFooterLink("Relationship Coaching", 2),
                      const SizedBox(height: 12),
                      _buildFooterLink("Stress Management", 2),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Legal",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildFooterLink("Privacy Policy", -1),
                      const SizedBox(height: 12),
                      _buildFooterLink("Terms of Service", -1),
                      const SizedBox(height: 12),
                      _buildFooterLink("Disclaimer", -1),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 40),
          Container(
            width: double.infinity,
            height: 1,
            color: AppTheme.white.withOpacity(0.1),
            margin: const EdgeInsets.only(bottom: 24),
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
                    color: AppTheme.white.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "All rights reserved.",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    color: AppTheme.white.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFooterSmallLink("Privacy"),
                    const SizedBox(width: 24),
                    _buildFooterSmallLink("Terms"),
                    const SizedBox(width: 24),
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
                    color: AppTheme.white.withOpacity(0.6),
                  ),
                ),
                Row(
                  children: [
                    _buildFooterSmallLink("Privacy"),
                    const SizedBox(width: 24),
                    _buildFooterSmallLink("Terms"),
                    const SizedBox(width: 24),
                    _buildFooterSmallLink("Cookies"),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppTheme.white.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: AppTheme.primarySilver,
        size: 20,
      ),
    );
  }

  Widget _buildFooterLink(String text, int index) {
    return InkWell(
      onTap: () {
        if (index >= 0) {
          _onTabSelected(index);
        }
      },
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 14,
          color: AppTheme.white.withOpacity(0.7),
        ),
      ),
    );
  }

  Widget _buildFooterSmallLink(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 14,
        color: AppTheme.white.withOpacity(0.6),
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
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.white.withOpacity(0.2),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            color: AppTheme.white.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
}

