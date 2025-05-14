import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ArticleCard extends StatelessWidget {
  final Map<String, dynamic> article;

  const ArticleCard({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Article image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                article['image'],
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
                      child: Icon(Icons.image_not_supported, color: AppTheme.darkText.withOpacity(0.5), size: 30),
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: AppTheme.darkText.withOpacity(0.6),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      article['date'],
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        color: AppTheme.darkText.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Title
                Text(
                  article['title'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Playfair Display',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkText,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Description
                Text(
                  article['description'],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    color: AppTheme.darkText.withOpacity(0.7),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Read more link
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      // Handle read more tap
                    },
                    child: Row(
                      children: [
                        const Text(
                          "Read Article",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.gold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward,
                          color: AppTheme.gold,
                          size: 14,
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