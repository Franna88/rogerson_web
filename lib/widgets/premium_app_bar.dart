import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../constants/app_constants.dart';

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
        final bool isDarkBackground = _opacityAnimation.value <= 0.1;
        
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
                  Colors.black.withOpacity(isDarkBackground ? 0.4 : 0.0),
                  Colors.black.withOpacity(isDarkBackground ? 0.1 : 0.0),
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
              Text(
                AppConstants.appName,
                style: TextStyle(
                  color: isDarkBackground ? AppTheme.white : AppTheme.darkText,
                  fontFamily: 'Playfair Display',
                  fontWeight: FontWeight.bold,
                  fontSize: isDesktop ? 24 : 20,
                  // Add text shadow to ensure visibility on dark backgrounds
                  shadows: isDarkBackground
                    ? [
                        Shadow(
                          offset: const Offset(0, 1),
                          blurRadius: 3.0,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ]
                    : null,
                ),
              ),
              if (isDesktop) const SizedBox(width: 8),
              if (isDesktop)
                Container(
                  height: 24,
                  width: 1,
                  color: isDarkBackground ? AppTheme.white.withOpacity(0.6) : AppTheme.primarySilver,
                ),
              if (isDesktop) const SizedBox(width: 8),
              if (isDesktop)
                Text(
                  AppConstants.appTagline,
                  style: TextStyle(
                    color: isDarkBackground 
                      ? AppTheme.white.withOpacity(0.9) 
                      : AppTheme.darkText.withOpacity(0.8),
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                    // Add text shadow to ensure visibility on dark backgrounds
                    shadows: isDarkBackground
                      ? [
                          Shadow(
                            offset: const Offset(0, 1),
                            blurRadius: 3.0,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ]
                      : null,
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
                      color: isDarkBackground ? AppTheme.white : AppTheme.darkText,
                      size: 28,
                      // Add shadow to ensure visibility on light backgrounds when not scrolled
                      shadows: isDarkBackground
                        ? [
                            Shadow(
                              offset: const Offset(0, 1),
                              blurRadius: 3.0,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ]
                        : null,
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
                      color: AppTheme.primarySilver.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Menu",
                      style: TextStyle(
                        fontFamily: 'Playfair Display',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkText,
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
                  color: AppTheme.primarySilver.withOpacity(0.2),
                  border: Border(
                    top: BorderSide(
                      color: AppTheme.primarySilver.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Contact",
                      style: TextStyle(
                        fontFamily: 'Playfair Display',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.email_outlined,
                          size: 18,
                          color: AppTheme.primarySilver,
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
                          color: AppTheme.primarySilver,
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
          color: isSelected ? AppTheme.primarySilver.withOpacity(0.1) : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isSelected ? AppTheme.primarySilver : Colors.transparent,
              width: 4,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primarySilver : AppTheme.darkText.withOpacity(0.7),
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppTheme.primarySilver : AppTheme.darkText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDesktopMenu() {
    return [
      ..._buildNavigationItems(),
      const SizedBox(width: 24),
    ];
  }

  List<Widget> _buildNavigationItems() {
    final navItems = [
      AppConstants.homeLabel,
      AppConstants.aboutLabel,
      AppConstants.servicesLabel,
      AppConstants.blogLabel,
      AppConstants.contactLabel,
    ];

    return List.generate(navItems.length, (index) {
      final isSelected = widget.selectedIndex == index;
      return _buildNavItem(navItems[index], index, isSelected);
    });
  }

  Widget _buildNavItem(String title, int index, bool isSelected) {
    // Get current background state
    final bool isDarkBackground = _opacityAnimation.value <= 0.1;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          widget.onTabSelected(index);
        },
        splashColor: Colors.transparent,
        hoverColor: AppTheme.primarySilver.withOpacity(0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primarySilver.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? AppTheme.primarySilver : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isDarkBackground 
                    ? AppTheme.white 
                    : (isSelected 
                        ? AppTheme.primarySilver 
                        : AppTheme.darkText.withOpacity(0.7)),
                  letterSpacing: 0.3,
                  shadows: isDarkBackground
                    ? [
                        Shadow(
                          offset: const Offset(0, 1),
                          blurRadius: 2.0,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ]
                    : null,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Container(
              height: 2,
              width: 20,
              color: isSelected ? AppTheme.primarySilver : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: IconButton(
        iconSize: 24,
        icon: Icon(
          icon,
          color: AppTheme.primarySilver,
        ),
        onPressed: onPressed,
        splashRadius: 20,
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: IconButton(
        iconSize: 20,
        icon: Icon(
          icon,
          color: AppTheme.primarySilver,
        ),
        onPressed: onPressed,
        splashRadius: 18,
      ),
    );
  }

  Widget _buildMobileNavItem(String title, int index, bool isSelected) {
    return ListTile(
      dense: true,
      onTap: () {
        widget.onTabSelected(index);
        Navigator.pop(context); // Close drawer after selection
      },
      selected: isSelected,
      selectedTileColor: AppTheme.primarySilver.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isSelected ? AppTheme.primarySilver : AppTheme.darkText,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
} 