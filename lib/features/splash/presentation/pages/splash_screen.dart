import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/onboarding');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery for responsive UI
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive sizes
    final horizontalPadding = screenWidth * 0.08;
    final logoSize = screenWidth * 0.20;
    final homeImageWidth = screenWidth * 1.15;
    final homeImageHeight = screenHeight * 0.45;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SizedBox(
          height: screenHeight,
          width: screenWidth,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenHeight,
              ),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    // Top left soft decoration
                    Positioned(
                      top: -screenWidth * 0.12,
                      left: -screenWidth * 0.15,
                      child: Container(
                        width: screenWidth * 0.35,
                        height: screenWidth * 0.35,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFE6F4F0),
                        ),
                      ),
                    ),

                    // Bottom left soft decoration
                    Positioned(
                      bottom: -screenWidth * 0.15,
                      left: -screenWidth * 0.15,
                      child: Container(
                        width: screenWidth * 0.35,
                        height: screenWidth * 0.35,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFE6F4F0),
                        ),
                      ),
                    ),

                    // Bottom right soft decoration
                    Positioned(
                      bottom: -screenWidth * 0.22,
                      right: -screenWidth * 0.20,
                      child: Container(
                        width: screenWidth * 0.48,
                        height: screenWidth * 0.48,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFE6F4F0),
                        ),
                      ),
                    ),

                    // Main content
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: screenHeight * 0.07),

                          // App Logo
                          const Icon(
                            Icons.home_outlined,
                            size: 82,
                            color: AppColors.primary,
                          ),

                          SizedBox(height: screenHeight * 0.012),

                          // App name
                          Text(
                            'FixIt',
                            style: AppFonts.splashTitle.copyWith(
                              fontSize: screenWidth * 0.105,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.005),

                          // Tagline
                          Text(
                            'Your Home. Our Experts.',
                            style: AppFonts.bodyMedium.copyWith(
                              fontSize: screenWidth * 0.038,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.035),

                          // Large Home Illustration
                          Image.asset(
                            'assets/images/splash_logo.jpeg',
                            width: homeImageWidth,
                            height: homeImageHeight,
                            fit: BoxFit.contain,
                          ),

                          SizedBox(height: screenHeight * 0.025),

                          // Description
                          Text(
                            'Reliable home services\nat your fingertips.',
                            textAlign: TextAlign.center,
                            style: AppFonts.headingSmall.copyWith(
                              fontSize: screenWidth * 0.048,
                              height: 1.5,
                              color: AppColors.textPrimary,
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.045),

                          // Page indicators
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildIndicator(
                                context,
                                isActive: true,
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              _buildIndicator(
                                context,
                                isActive: false,
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              _buildIndicator(
                                context,
                                isActive: false,
                              ),
                            ],
                          ),

                          SizedBox(height: screenHeight * 0.04),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(
    BuildContext context, {
    required bool isActive,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? screenWidth * 0.07 : screenWidth * 0.022,
      height: screenWidth * 0.022,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary
            : AppColors.border,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}