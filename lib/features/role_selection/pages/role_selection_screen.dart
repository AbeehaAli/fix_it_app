import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_fonts.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() =>
      _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String selectedRole = 'customer';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.07,
          ),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.08),

              // Title
              Text(
                'How would you like\nto use FixIt?',
                textAlign: TextAlign.center,
                style: AppFonts.headingLarge.copyWith(
                  fontSize: screenWidth * 0.070,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                  color: AppColors.textPrimary,
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Customer Card
              Expanded(
                child: _buildRoleCard(
                  context: context,
                  icon: Icons.person_rounded,
                  title: "I'm a Customer",
                  subtitle: 'Find and book professionals\nfor your home.',
                  isSelected: selectedRole == 'customer',
                  onTap: () {
                    setState(() {
                      selectedRole = 'customer';
                    });
                    context.push('/customer-signUp');
                  },
                ),
              ),

              SizedBox(height: screenHeight * 0.025),

              // Technician Card
              Expanded(
                child: _buildRoleCard(
                  context: context,
                  icon: Icons.build_rounded,
                  title: "I'm a Technician",
                  subtitle: 'Offer your services and\ngrow your business.',
                  isSelected: selectedRole == 'technician',
                  onTap: () {
                    setState(() {
                      selectedRole = 'technician';
                    });
                    context.push('/technician_signUp');
                  },
                ),
              ),

              SizedBox(height: screenHeight * 0.04),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          // Selected = light bluish color
          // Not selected = white
          color: isSelected
              ? const Color(0xFFE1EEF8)
              : Colors.white,

          borderRadius: BorderRadius.circular(24),

          border: Border.all(
            color: isSelected
                ? const Color(0xFFCFE3F3)
                : const Color(0xFFE8E8E8),
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final iconSize =
                constraints.maxHeight < 220
                    ? screenWidth * 0.13
                    : screenWidth * 0.16;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: iconSize,
                  color: isSelected
                      ? AppColors.primary
                      : const Color(0xFF8A98A8),
                ),

                SizedBox(
                  height: constraints.maxHeight * 0.06,
                ),

                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppFonts.headingSmall.copyWith(
                    fontSize: screenWidth * 0.055,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),

                SizedBox(
                  height: constraints.maxHeight * 0.04,
                ),

                Flexible(
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.bodyMedium.copyWith(
                      fontSize: screenWidth * 0.038,
                      height: 1.35,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}