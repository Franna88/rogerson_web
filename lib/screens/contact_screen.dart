import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';
import '../widgets/premium_button.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  
  String _selectedService = 'Executive Therapy';
  bool _isMessageSent = false;
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          _buildHeroSection(context),
          _buildContactFormSection(),
          _buildAdditionalInfoSection(),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4, // Responsive height based on screen size
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.charcoal,
        image: DecorationImage(
          image: const NetworkImage('https://images.unsplash.com/photo-1633360821222-7e8df83639fb?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            AppTheme.charcoal.withOpacity(0.7),
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
              width: 60,
              height: 2,
              color: AppTheme.primarySilver,
              margin: const EdgeInsets.only(bottom: 24),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                AppConstants.contactTitle,
                style: TextStyle(
                  fontFamily: 'Playfair Display',
                  fontSize: MediaQuery.of(context).size.width < 600 ? 36 : 48, // Smaller font on smaller screens
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
                AppConstants.contactSubtitle,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: MediaQuery.of(context).size.width < 600 ? 16 : 20, // Smaller font on smaller screens
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

  Widget _buildContactFormSection() {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildContactInfo(),
                    const SizedBox(height: 60),
                    _buildForm(),
                  ],
                );
              } else {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: _buildContactInfo(),
                    ),
                    const SizedBox(width: 80),
                    Expanded(
                      flex: 6,
                      child: _buildForm(),
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

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 50,
          height: 2,
          color: AppTheme.primarySilver,
          margin: const EdgeInsets.only(bottom: 24),
        ),
        const Text(
          "Contact Information",
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkText,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          AppConstants.contactDescription,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            color: AppTheme.darkText.withOpacity(0.8),
            height: 1.8,
          ),
        ),
        const SizedBox(height: 40),
        _buildContactItem(
          icon: Icons.location_on_outlined,
          title: "Office Location",
          detail: "1215 5th Avenue, New York, NY 10029",
        ),
        const SizedBox(height: 24),
        _buildContactItem(
          icon: Icons.email_outlined,
          title: "Email Address",
          detail: "contact@nathanrogerson.com",
        ),
        const SizedBox(height: 24),
        _buildContactItem(
          icon: Icons.phone_outlined,
          title: "Telephone",
          detail: "+1 (212) 555-7890",
        ),
        const SizedBox(height: 40),
        const Text(
          "Office Hours",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkText,
          ),
        ),
        const SizedBox(height: 16),
        _buildOfficeHours("Monday - Thursday", "9:00 AM - 7:00 PM"),
        _buildOfficeHours("Friday", "9:00 AM - 5:00 PM"),
        _buildOfficeHours("Saturday", "By Appointment Only"),
        _buildOfficeHours("Sunday", "Closed"),
      ],
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String detail,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primarySilver.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppTheme.primarySilver,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                detail,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 15,
                  color: AppTheme.darkText.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOfficeHours(String day, String hours) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              day,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppTheme.darkText,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              hours,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 15,
                color: AppTheme.darkText.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    if (_isMessageSent) {
      return _buildSuccessMessage();
    }
    
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: AppTheme.primarySilver.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Schedule a Consultation",
            style: TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Complete the form below to request a confidential consultation with Nathan Rogerson.",
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 15,
              color: AppTheme.darkText.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 32),
          Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(
                  controller: _nameController,
                  label: "Full Name",
                  hint: "Enter your full name",
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                LayoutBuilder(
                  builder: (context, constraints) {
                    // Stack fields vertically on smaller screens
                    if (constraints.maxWidth < 500) {
                      return Column(
                        children: [
                          _buildTextField(
                            controller: _emailController,
                            label: "Email Address",
                            hint: "Enter your email address",
                            icon: Icons.email_outlined,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              // Simple email validation
                              if (!value.contains('@') || !value.contains('.')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          _buildTextField(
                            controller: _phoneController,
                            label: "Phone Number",
                            hint: "Enter your phone number",
                            icon: Icons.phone_outlined,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                          ),
                        ],
                      );
                    }
                    
                    // Use row layout on larger screens
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _emailController,
                            label: "Email Address",
                            hint: "Enter your email address",
                            icon: Icons.email_outlined,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              // Simple email validation
                              if (!value.contains('@') || !value.contains('.')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _phoneController,
                            label: "Phone Number",
                            hint: "Enter your phone number",
                            icon: Icons.phone_outlined,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                _buildDropdown(),
                const SizedBox(height: 24),
                _buildTextField(
                  controller: _messageController,
                  label: "Your Message",
                  hint: "Please provide any additional details about your consultation request",
                  icon: Icons.chat_bubble_outline,
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your message';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      color: AppTheme.primarySilver,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Your information is secured with end-to-end encryption",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          color: AppTheme.darkText.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                PremiumButton(
                  text: "Submit Request",
                  width: double.infinity,
                  onPressed: _submitForm,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkText,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppTheme.darkText.withOpacity(0.6),
              fontFamily: 'Montserrat',
              fontSize: 15,
            ),
            prefixIcon: Icon(
              icon,
              color: AppTheme.primarySilver,
              size: 22,
            ),
            filled: true,
            fillColor: AppTheme.lightSilver.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppTheme.primarySilver.withOpacity(0.3),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppTheme.primarySilver.withOpacity(0.3),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppTheme.primarySilver.withOpacity(0.8),
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.redAccent,
                width: 1,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 16 : 0,
            ),
            labelStyle: TextStyle(
              color: AppTheme.darkText.withOpacity(0.6),
              fontFamily: 'Montserrat',
              fontSize: 15,
            ),
          ),
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 15,
            color: AppTheme.darkText,
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Service of Interest",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkText,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppTheme.lightSilver.withOpacity(0.1),
            border: Border.all(
              color: AppTheme.primarySilver.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedService,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppTheme.primarySilver,
              ),
              isExpanded: true,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 15,
                color: AppTheme.darkText,
              ),
              items: [
                'Executive Therapy',
                'Relationship Coaching',
                'Elite Stress & Trauma Support',
                'Other Services',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedService = newValue;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // In a real app, this would send the form data to a server
      setState(() {
        _isMessageSent = true;
      });
    }
  }

  Widget _buildSuccessMessage() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: AppTheme.primarySilver.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: AppTheme.primarySilver,
            size: 80,
          ),
          const SizedBox(height: 24),
          const Text(
            "Thank You for Your Request",
            style: TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            "Your consultation request has been received. Nathan Rogerson's office will contact you within 24 hours to schedule your appointment.",
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              color: AppTheme.darkText,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          PremiumButton(
            text: "Return to Home",
            onPressed: () {
              // Reset form and navigate to home
              setState(() {
                _isMessageSent = false;
                _nameController.clear();
                _emailController.clear();
                _phoneController.clear();
                _messageController.clear();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      color: AppTheme.charcoal,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              const Text(
                "Committed to Your Privacy",
                style: TextStyle(
                  fontFamily: 'Playfair Display',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                "Nathan Rogerson maintains the highest standards of confidentiality and discretion. All sessions and client information are protected by both legal confidentiality requirements and state-of-the-art security measures.",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  color: AppTheme.white.withOpacity(0.8),
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = constraints.maxWidth;
                  
                  // Stack cards vertically on smaller screens
                  if (screenWidth < 650) {
                    return Column(
                      children: [
                        _buildInfoCard(
                          icon: Icons.verified_user_outlined,
                          title: "Strict Confidentiality",
                          description: "Your information is protected by both ethical standards and legal regulations.",
                        ),
                        const SizedBox(height: 24),
                        _buildInfoCard(
                          icon: Icons.security_outlined,
                          title: "Secure Communications",
                          description: "All electronic communications are encrypted and secured.",
                        ),
                        const SizedBox(height: 24),
                        _buildInfoCard(
                          icon: Icons.meeting_room_outlined,
                          title: "Private Facilities",
                          description: "Discreet office locations with private entrances and exits.",
                        ),
                      ],
                    );
                  } else if (screenWidth < 900) {
                    // Two column layout for medium screens
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoCard(
                                icon: Icons.verified_user_outlined,
                                title: "Strict Confidentiality",
                                description: "Your information is protected by both ethical standards and legal regulations.",
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: _buildInfoCard(
                                icon: Icons.security_outlined,
                                title: "Secure Communications",
                                description: "All electronic communications are encrypted and secured.",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildInfoCard(
                          icon: Icons.meeting_room_outlined,
                          title: "Private Facilities",
                          description: "Discreet office locations with private entrances and exits.",
                        ),
                      ],
                    );
                  }
                  
                  // Use row with spacing on larger screens
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.verified_user_outlined,
                          title: "Strict Confidentiality",
                          description: "Your information is protected by both ethical standards and legal regulations.",
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.security_outlined,
                          title: "Secure Communications",
                          description: "All electronic communications are encrypted and secured.",
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.meeting_room_outlined,
                          title: "Private Facilities",
                          description: "Discreet office locations with private entrances and exits.",
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primarySilver.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppTheme.primarySilver,
            size: 40,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 15,
              color: AppTheme.white.withOpacity(0.7),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
} 