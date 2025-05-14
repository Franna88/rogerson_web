import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';
import '../widgets/premium_button.dart';
import '../widgets/section_title.dart';
import '../widgets/blog_widgets/featured_resource_card.dart';
import '../widgets/blog_widgets/article_card.dart';
import '../widgets/blog_widgets/video_card.dart';
import '../widgets/blog_widgets/quick_tip_card.dart';

class HoverCard extends StatefulWidget {
  final Widget child;
  
  const HoverCard({
    super.key,
    required this.child,
  });

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: _isHovered 
            ? (Matrix4.identity()..scale(1.03))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.15 : 0.1),
              blurRadius: _isHovered ? 12 : 8,
              spreadRadius: _isHovered ? 2 : 1,
              offset: _isHovered ? const Offset(0, 6) : const Offset(0, 4),
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}

class BlogScreen extends StatefulWidget {
  final Function(int) onNavigate;

  const BlogScreen({
    super.key,
    required this.onNavigate,
  });

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Articles', 'Videos', 'Tips'];
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          _buildHeroSection(context),
          _buildCategoryFilter(),
          _buildFeaturedSection(),
          _buildArticlesSection(),
          _buildVideosSection(),
          _buildQuickTipsSection(),
          _buildNewsletterSection(),
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
          image: const NetworkImage('https://images.unsplash.com/photo-1507842217343-583bb7270b66?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2090&q=80'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            AppTheme.charcoal.withOpacity(0.6),
            BlendMode.darken,
          ),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80), // Space for AppBar
            Container(
              width: 40,
              height: 2,
              color: AppTheme.primarySilver,
              margin: const EdgeInsets.only(bottom: 8),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                AppConstants.blogTitle,
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
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                AppConstants.blogSubtitle,
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

  Widget _buildCategoryFilter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Center(
        child: Wrap(
          spacing: 20,
          runSpacing: 15,
          children: _categories.map((category) {
            bool isSelected = _selectedCategory == category;
            return InkWell(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
                _scrollToTop();
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primarySilver.withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppTheme.primarySilver : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFeaturedSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              const SectionTitle(
                title: "Featured Resources",
                subtitle: "Discover our premium collection of psychological insights and practical strategies for growth",
                centerAlign: true,
                dividerColor: AppTheme.primarySilver,
              ),
              const SizedBox(height: 40),
              Container(
                width: 80,
                height: 4,
                color: AppTheme.primarySilver,
                margin: const EdgeInsets.only(bottom: 24),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = constraints.maxWidth;
                  final isMobile = screenWidth < 768;
                  final isTablet = screenWidth < 1024 && screenWidth >= 768;
                  
                  if (isMobile) {
                    // Mobile layout - vertical stack
                    return Column(
                      children: AppConstants.featuredResources.map((resource) => 
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: FeaturedResourceCard(resource: resource),
                        )
                      ).toList(),
                    );
                  } else if (isTablet) {
                    // Tablet layout - 2 columns
                    return Wrap(
                      spacing: 20,
                      runSpacing: 30,
                      children: AppConstants.featuredResources.map((resource) => 
                        SizedBox(
                          width: (screenWidth - 20) / 2,
                          child: FeaturedResourceCard(resource: resource),
                        )
                      ).toList(),
                    );
                  } else {
                    // Desktop layout - 3 columns
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: AppConstants.featuredResources.map((resource) => 
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: FeaturedResourceCard(resource: resource),
                          ),
                        )
                      ).toList(),
                    );
                  }
                },
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppTheme.primarySilver.withOpacity(0.5),
                        Colors.transparent,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticlesSection() {
    if (_selectedCategory != 'All' && _selectedCategory != 'Articles') return const SizedBox.shrink();
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      color: AppTheme.lightSilver.withOpacity(0.1),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              const SectionTitle(
                title: "Latest Articles",
                subtitle: "Insightful content for your personal and professional growth",
                centerAlign: true,
              ),
              const SizedBox(height: 40),
              LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = constraints.maxWidth;
                  
                  return Wrap(
                    spacing: 20,
                    runSpacing: 30,
                    children: AppConstants.recentArticles.map((article) {
                      // Determine card width based on screen size
                      double cardWidth;
                      if (screenWidth < 600) {
                        cardWidth = screenWidth - 40; // Full width on mobile
                      } else if (screenWidth < 900) {
                        cardWidth = (screenWidth - 60) / 2; // 2 cards per row on tablets
                      } else {
                        cardWidth = (screenWidth - 80) / 3; // 3 cards per row on desktop
                      }
                      
                      return SizedBox(
                        width: cardWidth,
                        child: HoverCard(
                          child: ArticleCard(article: article),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 40),
              PremiumButton(
                text: "View All Articles",
                onPressed: () {
                  // Handle view all articles
                  setState(() {
                    _selectedCategory = 'Articles';
                  });
                },
                isOutlined: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideosSection() {
    if (_selectedCategory != 'All' && _selectedCategory != 'Videos') return const SizedBox.shrink();
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              const SectionTitle(
                title: "Video Resources",
                subtitle: "Visual guidance for implementing psychological techniques",
                centerAlign: true,
              ),
              const SizedBox(height: 40),
              LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = constraints.maxWidth;
                  final isMobile = screenWidth < 768;
                  
                  if (isMobile) {
                    // Mobile layout - vertical stack
                    return Column(
                      children: AppConstants.videoResources.map((video) => 
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: VideoCard(video: video),
                        )
                      ).toList(),
                    );
                  } else {
                    // Desktop/tablet layout - grid
                    return Wrap(
                      spacing: 20,
                      runSpacing: 30,
                      children: AppConstants.videoResources.map((video) {
                        double cardWidth;
                        if (screenWidth < 900) {
                          cardWidth = (screenWidth - 40) / 2; // 2 cards per row on smaller screens
                        } else {
                          cardWidth = (screenWidth - 60) / 3; // 3 cards per row on larger screens
                        }
                        
                        return SizedBox(
                          width: cardWidth,
                          child: HoverCard(
                            child: VideoCard(video: video),
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
              const SizedBox(height: 40),
              PremiumButton(
                text: "View All Videos",
                onPressed: () {
                  // Handle view all videos
                  setState(() {
                    _selectedCategory = 'Videos';
                  });
                },
                isOutlined: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickTipsSection() {
    if (_selectedCategory != 'All' && _selectedCategory != 'Tips') return const SizedBox.shrink();
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      color: AppTheme.charcoal,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              SectionTitle(
                title: "Quick Tips",
                subtitle: "Practical, easy-to-implement techniques for daily excellence",
                centerAlign: true,
                textColor: AppTheme.white,
                dividerColor: AppTheme.primarySilver,
              ),
              const SizedBox(height: 40),
              LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = constraints.maxWidth;
                  
                  return Wrap(
                    spacing: 20,
                    runSpacing: 30,
                    alignment: WrapAlignment.center,
                    children: AppConstants.quickTips.map((tip) {
                      // Determine card width based on screen size
                      double cardWidth;
                      if (screenWidth < 600) {
                        cardWidth = screenWidth - 40; // Full width on mobile
                      } else if (screenWidth < 900) {
                        cardWidth = (screenWidth - 60) / 2; // 2 cards per row on tablets
                      } else {
                        cardWidth = (screenWidth - 100) / 3; // 3 cards per row on desktop
                      }
                      
                      return SizedBox(
                        width: cardWidth,
                        child: HoverCard(
                          child: QuickTipCard(tip: tip),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsletterSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      color: AppTheme.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 2,
                color: AppTheme.primarySilver,
                margin: const EdgeInsets.only(bottom: 24),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = constraints.maxWidth;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Subscribe to Our Newsletter",
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
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Receive exclusive content, latest articles, and expert insights directly to your inbox. Your information will be handled with the utmost confidentiality.",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    color: AppTheme.darkText.withOpacity(0.8),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = constraints.maxWidth;
                  final isMobile = screenWidth < 500;
                  
                  if (isMobile) {
                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Your email address",
                              hintStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 15,
                                color: AppTheme.darkText.withOpacity(0.5),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: AppTheme.primarySilver.withOpacity(0.3),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: AppTheme.primarySilver.withOpacity(0.3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: AppTheme.primarySilver.withOpacity(0.5),
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        PremiumButton(
                          text: "Subscribe",
                          width: double.infinity,
                          onPressed: () {
                            // Handle subscription
                          },
                        ),
                      ],
                    );
                  } else {
                    return Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Your email address",
                                hintStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 15,
                                  color: AppTheme.darkText.withOpacity(0.5),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppTheme.primarySilver.withOpacity(0.3),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppTheme.primarySilver.withOpacity(0.3),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppTheme.primarySilver.withOpacity(0.5),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 3,
                          child: PremiumButton(
                            text: "Subscribe",
                            onPressed: () {
                              // Handle subscription
                            },
                          ),
                        ),
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
} 