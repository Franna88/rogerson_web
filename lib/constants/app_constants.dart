class AppConstants {
  // App Info
  static const String appName = "Nathan Rogerson";
  static const String appTagline = "Premium Psychological Services for Elite Professionals";
  
  // Navigation
  static const String homeLabel = "Home";
  static const String aboutLabel = "About";
  static const String servicesLabel = "Services";
  static const String contactLabel = "Contact";
  static const String blogLabel = "Resources";
  
  // Home Page
  static const String homeHeroTitle = "Elite Psychological Services";
  static const String homeHeroSubtitle = "Tailored to meet the unique needs of high-profile individuals and business leaders";
  static const String homeIntroText = "Experience premium psychological care designed exclusively for discerning clients who demand excellence, privacy, and results.";
  static const String ctaButtonText = "Schedule a Consultation";
  
  // About Page
  static const String aboutTitle = "Nathan Rogerson";
  static const String aboutSubtitle = "Specialized in executive psychology and high-performance coaching";
  static const String aboutDescription = "With over 15 years of experience working with high-profile clients, Nathan Rogerson provides sophisticated psychological services that address the complex challenges faced by executives, entrepreneurs, and public figures.";
  static const String qualificationsTitle = "Credentials & Expertise";
  static const List<String> qualifications = [
    "Ph.D. in Clinical Psychology, Harvard University",
    "Executive Coaching Certification, Wharton Business School",
    "Specialized training in Cognitive Behavioral Therapy for high-performance individuals",
    "Published author on leadership psychology and elite performance",
    "International speaker on executive mental wellness"
  ];
  static const String approachTitle = "My Approach";
  static const String approachDescription = "I believe in a holistic, evidence-based approach that integrates cutting-edge psychological techniques with practical strategies for elite performance. My methods are discreet, efficient, and tailored to the unique demands of high-achieving individuals.";
  
  // Services Page
  static const String servicesTitle = "Premium Psychological Services";
  static const String servicesSubtitle = "Tailored solutions for extraordinary individuals";
  
  static const String executiveTherapyTitle = "Executive Therapy";
  static const String executiveTherapyDescription = "Specialized psychological support designed for the unique challenges faced by C-suite executives, business owners, and leaders. Addressing performance pressure, decision fatigue, and leadership stress in a confidential, results-oriented environment.";
  
  static const String relationshipCoachingTitle = "Relationship Coaching";
  static const String relationshipCoachingDescription = "Strategic guidance for navigating complex personal and professional relationships. Develop advanced communication skills, emotional intelligence, and conflict resolution strategies that enhance both personal satisfaction and professional effectiveness.";
  
  static const String stressManagementTitle = "Elite Stress & Trauma Support";
  static const String stressManagementDescription = "Sophisticated psychological techniques for managing high-pressure situations, public scrutiny, and crisis events. Learn to transform stress into optimal performance while maintaining psychological wellbeing.";
  
  // Contact Page
  static const String contactTitle = "Private Consultation";
  static const String contactSubtitle = "Begin your journey to exceptional psychological wellbeing";
  static const String contactDescription = "All inquiries are handled with the utmost discretion and privacy. Nathan Rogerson personally reviews each consultation request to ensure his expertise aligns with your specific needs.";

  // Blog section titles and descriptions
  static const String blogTitle = "Resources & Insights";
  static const String blogSubtitle = "Valuable content to support your psychological wellbeing and professional excellence.";

  // Resource categories
  static const String articlesCategory = "Articles";
  static const String videosCategory = "Videos";
  static const String tipsCategory = "Quick Tips";

  // Placeholder content for blog
  static const List<Map<String, dynamic>> featuredResources = [
    {
      'title': 'The Executive Mind: Strategies for Peak Performance',
      'category': 'Articles',
      'image': 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2071&q=80',
      'author': 'Nathan Rogerson',
      'date': 'June 15, 2023',
      'description': 'Learn how top executives maintain mental clarity and make decisive choices under pressure. This comprehensive guide explores cognitive techniques for enhanced decision-making and emotional resilience in high-stakes environments.',
    },
    {
      'title': 'Balancing Success and Connection: The Relationship Guide',
      'category': 'Articles',
      'image': 'https://images.unsplash.com/photo-1542338347-4fff3276af78?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'author': 'Nathan Rogerson',
      'date': 'May 22, 2023',
      'description': 'Discover how to nurture meaningful relationships while pursuing career excellence. This article provides actionable insights for maintaining emotional intimacy and open communication despite demanding schedules.',
    },
    {
      'title': 'Stress Transformation Technique',
      'category': 'Videos',
      'image': 'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2071&q=80',
      'author': 'Nathan Rogerson',
      'date': 'April 10, 2023',
      'duration': '18:35',
      'description': 'A guided video session demonstrating a powerful technique to transform stress into focused energy. Learn how to use cognitive reframing to change your relationship with pressure and leverage it for peak performance.',
    },
  ];

  static const List<Map<String, dynamic>> recentArticles = [
    {
      'title': 'Navigating Professional Setbacks with Resilience',
      'category': 'Articles',
      'image': 'https://images.unsplash.com/photo-1522125123931-9304d91a42ee?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
      'date': 'March 5, 2023',
      'description': 'Strategies for maintaining confidence and rebuilding momentum after professional challenges.',
    },
    {
      'title': 'Communication Techniques for Leadership',
      'category': 'Articles',
      'image': 'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
      'date': 'February 18, 2023',
      'description': 'Advanced communication approaches for executives seeking to inspire and lead effectively.',
    },
    {
      'title': 'Managing Anxiety in High-Pressure Environments',
      'category': 'Articles',
      'image': 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2076&q=80',
      'date': 'January 30, 2023',
      'description': 'Practical techniques to identify and address anxiety symptoms in demanding professional settings.',
    },
    // {
    //   'title': 'The Mindful Executive: Daily Practices',
    //   'category': 'Articles',
    //   'image': 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
    //   'date': 'January 15, 2023',
    //   'description': 'Simple yet powerful mindfulness practices that can be integrated into a busy executive schedule.',
    // },
  ];

  static const List<Map<String, dynamic>> videoResources = [
    {
      'title': 'Executive Presence: Developing Authentic Authority',
      'category': 'Videos',
      'image': 'https://images.unsplash.com/photo-1557804506-669a67965ba0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2074&q=80',
      'date': 'February 28, 2023',
      'duration': '22:15',
      'description': 'This video explores the psychological foundations of executive presence and how to develop it authentically.',
    },
    {
      'title': 'Effective Confrontation in Professional Relationships',
      'category': 'Videos',
      'image': 'https://images.unsplash.com/photo-1530720018-fe47e7c2c772?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'date': 'January 20, 2023',
      'duration': '15:42',
      'description': 'Learn techniques for addressing conflicts professionally while preserving relationships.',
    },
    {
      'title': '5-Minute Stress Reset Technique',
      'category': 'Videos',
      'image': 'https://images.unsplash.com/photo-1574027542338-98e75acfd385?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
      'date': 'December 12, 2022',
      'duration': '6:50',
      'description': 'A quick guided practice to reset your stress response system between meetings or challenging tasks.',
    },
  ];

  static const List<Map<String, dynamic>> quickTips = [
    {
      'title': 'Morning Routine for Mental Clarity',
      'description': 'Start with 2 minutes of deep breathing, followed by writing down your top 3 priorities for the day.',
      'icon': 'sunrise',
    },
    {
      'title': 'Meeting Preparation Ritual',
      'description': 'Take 5 minutes before important meetings to center yourself and clarify your desired outcomes.',
      'icon': 'calendar',
    },
    {
      'title': 'Transition Technique',
      'description': 'When moving from work to home, use a simple ritual like changing clothes to mentally shift from professional to personal mode.',
      'icon': 'home',
    },
    {
      'title': 'Decision Fatigue Prevention',
      'description': 'Schedule important decisions before 2pm when your cognitive resources are typically at their highest.',
      'icon': 'lightbulb',
    },
    {
      'title': 'Micro-Recovery Moments',
      'description': 'Integrate 60-second breathing breaks between tasks to prevent stress accumulation throughout the day.',
      'icon': 'clock',
    },
  ];
} 