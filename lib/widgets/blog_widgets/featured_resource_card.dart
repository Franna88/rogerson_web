import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class FeaturedResourceCard extends StatelessWidget {
  final Map<String, dynamic> resource;

  const FeaturedResourceCard({
    super.key,
    required this.resource,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Featured image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                resource['image'],
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
                      child: Icon(Icons.image_not_supported, color: AppTheme.darkText.withOpacity(0.5), size: 40),
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.gold.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    resource['category'],
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.gold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Title
                Text(
                  resource['title'],
                  style: const TextStyle(
                    fontFamily: 'Playfair Display',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkText,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Description
                Text(
                  resource['description'],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 15,
                    color: AppTheme.darkText.withOpacity(0.8),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Author and date row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "By ${resource['author']}",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.darkText.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        resource['category'] == 'Videos'
                            ? Icon(
                                Icons.play_circle_outline,
                                size: 16,
                                color: AppTheme.darkText.withOpacity(0.6),
                              )
                            : Icon(
                                Icons.calendar_today_outlined,
                                size: 14,
                                color: AppTheme.darkText.withOpacity(0.6),
                              ),
                        const SizedBox(width: 6),
                        Text(
                          resource['category'] == 'Videos'
                              ? resource['duration']
                              : resource['date'],
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            color: AppTheme.darkText.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Read more button
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      // Handle read more tap
                    },
                    child: Row(
                      children: [
                        Text(
                          resource['category'] == 'Videos' ? "Watch Video" : "Read More",
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.gold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward,
                          color: AppTheme.gold,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 