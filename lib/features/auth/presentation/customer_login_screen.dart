import 'package:final_project/features/auth/data/services/authentication_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_fonts.dart';

class CustomerLoginScreen extends StatefulWidget {
  const CustomerLoginScreen({super.key});

  @override
  State<CustomerLoginScreen> createState() => _CustomerLoginScreenState();
}

class _CustomerLoginScreenState extends State<CustomerLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

 

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,

          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.08,
            vertical: 20,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // Back Button
              // ==========================================

              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),

                onPressed: () {
                  context.pop();
                },

                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 23,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 35),

              // ==========================================
              // Title
              // ==========================================

              Text(
                'Welcome Back',
                style: AppFonts.headingLarge.copyWith(
                  fontSize: screenWidth * 0.075,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 7),

              // ==========================================
              // Subtitle
              // ==========================================

              Text(
                'Login to your FixIt account',
                style: AppFonts.bodyMedium.copyWith(
                  fontSize: screenWidth * 0.046,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 38),

              // ==========================================
              // Email
              // ==========================================

              _buildTextField(
                controller: _emailController,
                hintText: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 16),

              // ==========================================
              // Password
              // ==========================================

              _buildTextField(
                controller: _passwordController,
                hintText: 'Password',
                icon: Icons.lock_outline_rounded,
                isPassword: true,
              ),

              const SizedBox(height: 12),

              // ==========================================
              // Forgot Password
              // ==========================================

              Align(
                alignment: Alignment.centerRight,

                child: GestureDetector(
                  onTap: () {
                    // Forgot password functionality
                    // will be added later
                  },

                  child: Text(
                    'Forgot Password?',

                    style: AppFonts.bodyMedium.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ==========================================
              // Login Button
              // ==========================================

              SizedBox(
                width: double.infinity,
                height: 58,

                child: ElevatedButton(
                  onPressed: () async{
                   UserCredential? user =await customerLogin(
                    email: _emailController.text,
                     password: _passwordController.text
                     );
                     if (user != null && mounted) {
                      context.go('/customer-homepage');
                       
                     } else {
                       
                     }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),

                  child: Text(
                    'Login',

                    style: AppFonts.bodyMedium.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ==========================================
              // OR
              // ==========================================

              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: AppColors.border,
                      thickness: 1,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                    ),

                    child: Text(
                      'Or',

                      style: AppFonts.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  Expanded(
                    child: Divider(
                      color: AppColors.border,
                      thickness: 1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // ==========================================
              // Google Login
              // ==========================================

               SizedBox(
              width: double.infinity,
              height: 52,

              child: OutlinedButton(
                onPressed: () async {
                  final UserCredential = await customersignUpWithGoogle();
                  if (UserCredential != null) {
                    context.go('/customer-homepage');
                  } 
                },

                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,

                  side: BorderSide(
                    color: AppColors.border,
                    width: 1,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Image.asset(
                      'assets/images/google_logo.jpeg',
                      width: 25,
                      height: 25,
                    ),

                    const SizedBox(width: 12),

                    Text(
                      'Sign up with Google',
                      style: AppFonts.bodyMedium.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

              const SizedBox(height: 35),

              // ==========================================
              // Create Account
              // ==========================================

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Text(
                      "Don't have an account? ",

                      style: AppFonts.bodyMedium.copyWith(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        context.push('/customer-signup');
                      },

                      child: Text(
                        'Sign Up',

                        style: AppFonts.bodyMedium.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // Text Field
  // ==========================================================

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,

    TextInputType keyboardType = TextInputType.text,

    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,

      keyboardType: keyboardType,

      obscureText: isPassword ? _obscurePassword : false,

      style: AppFonts.bodyMedium.copyWith(
        color: AppColors.textPrimary,
      ),

      decoration: InputDecoration(
        // Hint
        hintText: hintText,

        hintStyle: AppFonts.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),

        // Prefix Icon
        prefixIcon: Icon(
          icon,
          color: AppColors.textSecondary,
        ),

        // Password Visibility
        suffixIcon: isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },

                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,

                  color: AppColors.textSecondary,
                ),
              )
            : null,

        // Background
        filled: true,
        fillColor: Colors.white,

        // Padding
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 19,
        ),

        // Normal Border
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),

          borderSide: BorderSide(
            color: AppColors.border,
          ),
        ),

        // Focused Border
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),

          borderSide: BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}