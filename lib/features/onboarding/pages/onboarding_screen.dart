import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_fonts.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SizedBox(
          width: screenWidth,
          height: screenHeight,
          child: Stack(
            children: [
              // Main content
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.08,
                ),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.11),

                    // Title
                    Text(
                      'Get the Best\nHome Services',
                      textAlign: TextAlign.center,
                      style: AppFonts.headingLarge.copyWith(
                        fontSize: screenWidth * 0.075,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.018),

                    // Subtitle
                    Text(
                      'Professional. Reliable. Affordable.',
                      textAlign: TextAlign.center,
                      style: AppFonts.bodyMedium.copyWith(
                        fontSize: screenWidth * 0.041,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // Technician Illustration
                    Expanded(
                      child: Center(
                        child: Image.asset(
                          'assets/images/onboarding_image.jpeg',
                          width: screenWidth * 0.80,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),
                  ],
                ),
              ),

              // Bottom indicators
              Positioned(
                left: screenWidth * 0.08,
                bottom: screenHeight * 0.065,
                child: Row(
                  children: [
                    _buildDot(isActive: true),
                    SizedBox(width: screenWidth * 0.025),
                    _buildDot(isActive: false),
                    SizedBox(width: screenWidth * 0.025),
                    _buildDot(isActive: false),
                    SizedBox(width: screenWidth * 0.025),
                    _buildDot(isActive: false),
                  ],
                ),
              ),

              // Next button
              Positioned(
                right: screenWidth * 0.08,
                bottom: screenHeight * 0.045,
                child: GestureDetector(
                  onTap: () {
                    context.go('/roleselection');
                  },
                  child: Container(
                    width: screenWidth * 0.16,
                    height: screenWidth * 0.16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.20),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 30,
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

  Widget _buildDot({
    required bool isActive,
  }) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive
            ? AppColors.primary
            : AppColors.border,
      ),
    );
  }
}