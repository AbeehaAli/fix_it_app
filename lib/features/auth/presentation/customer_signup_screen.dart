import 'package:final_project/features/auth/data/services/authentication_services.dart';
import 'package:final_project/features/auth/presentation/customer_login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_fonts.dart';

class CustomerSignupScreen extends StatefulWidget {
  const CustomerSignupScreen({super.key});

  @override
  State<CustomerSignupScreen> createState() =>
      _CustomerSignupScreenState();
}

class _CustomerSignupScreenState extends State<CustomerSignupScreen> {

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;


  

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

 @override
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  // Responsive spacing
  final bool isSmallScreen = screenHeight < 700;

  final horizontalPadding = screenWidth * 0.08;

  final topSpacing = isSmallScreen ? 12.0 : 20.0;
  final afterBack = isSmallScreen ? 14.0 : 22.0;
  final afterSubtitle = isSmallScreen ? 18.0 : 26.0;
  final fieldGap = isSmallScreen ? 10.0 : 14.0;
  final buttonGap = isSmallScreen ? 18.0 : 24.0;
  final dividerGap = isSmallScreen ? 14.0 : 20.0;
  final googleGap = isSmallScreen ? 14.0 : 20.0;
  final loginGap = isSmallScreen ? 18.0 : 26.0;

  return Scaffold(
    backgroundColor: AppColors.background,

    body: SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: topSpacing,
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ------------------------------------------------
            // Back Button
            // ------------------------------------------------

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

            SizedBox(height: afterBack),

            // ------------------------------------------------
            // Title
            // ------------------------------------------------

            Text(
              'Create Account',
              style: AppFonts.headingLarge.copyWith(
                fontSize: screenWidth * 0.075,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 4),

            // ------------------------------------------------
            // Subtitle
            // ------------------------------------------------

            Text(
              'Join as a Customer',
              style: AppFonts.bodyMedium.copyWith(
                fontSize: screenWidth * 0.046,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),

            SizedBox(height: afterSubtitle),

            // ------------------------------------------------
            // Full Name
            // ------------------------------------------------

            _buildTextField(
              controller: _fullNameController,
              hintText: 'Full Name',
              icon: Icons.person_outline_rounded,
            ),

            SizedBox(height: fieldGap),

            // ------------------------------------------------
            // Email
            // ------------------------------------------------

            _buildTextField(
              controller: _emailController,
              hintText: 'Email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),

            SizedBox(height: fieldGap),

            // ------------------------------------------------
            // Phone Number
            // ------------------------------------------------

            _buildTextField(
              controller: _phoneController,
              hintText: 'Phone Number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),

            SizedBox(height: fieldGap),

            // ------------------------------------------------
            // Password
            // ------------------------------------------------

            _buildTextField(
              controller: _passwordController,
              hintText: 'Password',
              icon: Icons.lock_outline_rounded,
              isPassword: true,
            ),

            SizedBox(height: buttonGap),

            // ------------------------------------------------
            // Sign Up Button
            // ------------------------------------------------

            SizedBox(
              width: double.infinity,
              height: 52,

              child: ElevatedButton(
               onPressed: () async {
  print('1. SIGN UP CLICKED');

  try {
    print('2. CALLING customersignUp');

    UserCredential? user = await customersignUp(
      name: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    print('3. customersignUp FINISHED');
    print('USER: $user');

    if (user != null && mounted) {
      print('4. GOING TO LOGIN');
      context.go('/customer-Login');
    } else {
      print('4. USER IS NULL');
    }
  } catch (e) {
    print('ERROR: $e');
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
                  'Sign Up',
                  style: AppFonts.bodyMedium.copyWith(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            SizedBox(height: dividerGap),

            // ------------------------------------------------
            // OR Divider
            // ------------------------------------------------

            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.grey.shade300,
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
                    color: Colors.grey.shade300,
                    thickness: 1,
                  ),
                ),
              ],
            ),

            SizedBox(height: googleGap),

            // ------------------------------------------------
            // Google Button
            // ------------------------------------------------

            SizedBox(
              width: double.infinity,
              height: 52,

              child: OutlinedButton(
                onPressed: () async{
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

            SizedBox(height: loginGap),

            // ------------------------------------------------
            // Login
            // ------------------------------------------------

            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Text(
                    'Already have an account? ',
                    style: AppFonts.bodyMedium.copyWith(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      context.push('/customer-Login');
                    },

                    child: Text(
                      'Login',
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
          ],
        ),
      ),
    ),
  );
}

  // ============================================================
  // Custom Text Field
  // ============================================================

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
        hintText: hintText,

        hintStyle: AppFonts.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),

        prefixIcon: Icon(
          icon,
          color: AppColors.textSecondary,
        ),

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

        filled: true,

        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 19,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),

          borderSide: BorderSide(
            color: AppColors.border,
          ),
        ),

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