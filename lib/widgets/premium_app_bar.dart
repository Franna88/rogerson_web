import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../constants/app_constants.dart';
import 'animated_gold_underline.dart';
import '../utils/gold_text_effect.dart';

class PremiumAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isScrolled;
  final int selectedIndex;
  final Function(int) onTabSelected;

  const PremiumAppBar({
    super.key,
    this.isScrolled = false,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  State<PremiumAppBar> createState() => _PremiumAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _PremiumAppBarState extends State<PremiumAppBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _elevationAnimation;
  
  // Create a global key for the scaffold to control the drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _elevationAnimation = Tween<double>(begin: 0.0, end: 8.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isScrolled) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(PremiumAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isScrolled != oldWidget.isScrolled) {
      if (widget.isScrolled) {
        _controller.forward();
      } else {
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return AppBar(
          key: _scaffoldKey,
          elevation: _elevationAnimation.value,
          // Add a gradient background that's subtle but ensures visibility on any background
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(_opacityAnimation.value > 0.1 ? 0.0 : 0.4),
                  Colors.black.withOpacity(_opacityAnimation.value > 0.1 ? 0.0 : 0.0),
                ],
              ),
            ),
          ),
          backgroundColor: _opacityAnimation.value > 0.1 
            ? Colors.white.withOpacity(0.97) 
            : Colors.transparent,
          centerTitle: !isDesktop,
          title: Row(
            children: [
              GoldTextEffect(
                scale: 0.3,
                enabled: _opacityAnimation.value > 0.1, // Enable gold effect when scrolled
                child: Text(
                  AppConstants.appName,
                  style: TextStyle(
                    color: _opacityAnimation.value > 0.1 ? AppTheme.darkText : AppTheme.white,
                    fontFamily: 'Playfair Display',
                    fontWeight: FontWeight.bold,
                    fontSize: isDesktop ? 24 : 20,
                    letterSpacing: 1,
                    // Add text shadow to ensure visibility on light backgrounds when not scrolled
                    shadows: _opacityAnimation.value > 0.1 
                      ? [] 
                      : [
                          Shadow(
                            offset: const Offset(0, 1),
                            blurRadius: 3.0,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                  ),
                ),
              ),
              if (isDesktop) const SizedBox(width: 8),
              if (isDesktop)
                Container(
                  height: 24,
                  width: 1,
                  color: AppTheme.gold,
                ),
              if (isDesktop) const SizedBox(width: 8),
              if (isDesktop)
                Text(
                  AppConstants.appTagline,
                  style: TextStyle(
                    color: _opacityAnimation.value > 0.1 ? AppTheme.darkText.withOpacity(0.8) : AppTheme.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                    // Add text shadow to ensure visibility on light backgrounds when not scrolled
                    shadows: _opacityAnimation.value > 0.1 
                      ? [] 
                      : [
                          Shadow(
                            offset: const Offset(0, 1),
                            blurRadius: 3.0,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                  ),
                ),
            ],
          ),
          actions: isDesktop
              ? _buildDesktopMenu()
              : [
                  IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: _opacityAnimation.value > 0.1 ? AppTheme.darkText : AppTheme.white,
                      size: 28,
                      // Add shadow to ensure visibility on light backgrounds when not scrolled
                      shadows: _opacityAnimation.value > 0.1 
                        ? [] 
                        : [
                            Shadow(
                              offset: const Offset(0, 1),
                              blurRadius: 3.0,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ],
                    ),
                    onPressed: () {
                      // Show custom sliding drawer
                      _showCustomDrawer(context);
                    },
                  ),
                  const SizedBox(width: 8),
                ],
        );
      },
    );
  }

  // Show a custom sliding drawer for mobile and tablet
  void _showCustomDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Takes up full height
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drawer header with close button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppTheme.silver.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GoldTextEffect(
                      scale: 0.3,
                      child: Text(
                        "Menu",
                        style: TextStyle(
                          fontFamily: 'Playfair Display',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkText,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: AppTheme.darkText,
                        size: 24,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              
              // Menu items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  children: _buildDrawerItems(),
                ),
              ),
              
              // Contact info at bottom
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.lightSilver.withOpacity(0.2),
                  border: Border(
                    top: BorderSide(
                      color: AppTheme.silver.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GoldTextEffect(
                      scale: 0.3,
                      child: Text(
                        "Contact",
                        style: TextStyle(
                          fontFamily: 'Playfair Display',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkText,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.email_outlined,
                          size: 18,
                          color: AppTheme.gold,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "contact@nathanrogerson.com",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 15,
                            color: AppTheme.darkText.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 18,
                          color: AppTheme.gold,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "+1 (212) 555-7890",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 15,
                            color: AppTheme.darkText.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildDrawerItems() {
    final navItems = [
      AppConstants.homeLabel,
      AppConstants.aboutLabel,
      AppConstants.servicesLabel,
      AppConstants.blogLabel,
      AppConstants.contactLabel,
    ];
    
    final icons = [
      Icons.home_outlined,
      Icons.person_outline,
      Icons.psychology_outlined,
      Icons.article_outlined,
      Icons.email_outlined,
    ];

    return List.generate(navItems.length, (index) {
      final isSelected = widget.selectedIndex == index;
      return _buildDrawerItem(navItems[index], icons[index], index, isSelected);
    });
  }

  Widget _buildDrawerItem(String label, IconData icon, int index, bool isSelected) {
    return InkWell(
      onTap: () {
        widget.onTabSelected(index);
        Navigator.pop(context); // Close drawer
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.gold.withOpacity(0.1) : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isSelected ? AppTheme.gold : Colors.transparent,
              width: 4,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.gold : AppTheme.darkText.withOpacity(0.7),
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppTheme.gold : AppTheme.darkText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDesktopMenu() {
    return [
      _buildMenuItem('Home', 0),
      const SizedBox(width: 32),
      _buildMenuItem('About', 1),
      const SizedBox(width: 32),
      _buildMenuItem('Services', 2),
      const SizedBox(width: 32),
      _buildMenuItem('Blog', 3),
      const SizedBox(width: 32),
      _buildMenuItem('Contact', 4),
      const SizedBox(width: 24),
    ];
  }

  Widget _buildMenuItem(String title, int index) {
    final bool isSelected = widget.selectedIndex == index;
    final Color textColor = _opacityAnimation.value > 0.1 
        ? AppTheme.darkText 
        : AppTheme.white;
    
    return AnimatedGoldUnderline(
      isActive: isSelected,
      underlineColor: AppTheme.gold,
      child: InkWell(
        onTap: () => widget.onTabSelected(index),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: textColor,
              letterSpacing: 0.5,
              shadows: _opacityAnimation.value > 0.1 
                ? [] 
                : [
                    Shadow(
                      offset: const Offset(0, 1),
                      blurRadius: 3.0,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
            ),
          ),
        ),
      ),
    );
  }
} 