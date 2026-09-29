import 'package:final_project/features/firebase/data/services/technician_profile_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'technician_login_screen.dart';

class TechnicianSignUpScreen extends StatefulWidget {
  const TechnicianSignUpScreen({super.key});

  @override
  State<TechnicianSignUpScreen> createState() =>
      _TechnicianSignUpScreenState();
}

class _TechnicianSignUpScreenState extends State<TechnicianSignUpScreen> {
  bool obscurePassword = true;
  bool isLoading = false;

  String emailError = '';
  String passwordWarning = '';

  final TextEditingController fullNameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController phoneController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    emailController.addListener(validateEmail);
    passwordController.addListener(validatePassword);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  void validateEmail() {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        emailError = '';
      });
      return;
    }

    if (!email.toLowerCase().endsWith('@gmail.com')) {
      setState(() {
        emailError = 'Email is not valid. Use a Gmail address.';
      });
    } else {
      setState(() {
        emailError = '';
      });
    }
  }

  void validatePassword() {
    final password = passwordController.text;

    if (password.isEmpty) {
      setState(() {
        passwordWarning = '';
      });
      return;
    }

    if (password.length < 8) {
      setState(() {
        passwordWarning = 'Password must be at least 8 characters.';
      });
    } else {
      setState(() {
        passwordWarning = '';
      });
    }
  }

  // =========================================================
  // FIREBASE SIGN UP
  // =========================================================

  Future<void> handleSignUp() async {
    final name = fullNameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text;

    bool hasError = false;

    // Email validation
    if (email.isEmpty ||
        !email.toLowerCase().endsWith('@gmail.com')) {
      setState(() {
        emailError = 'Email is not valid. Use a Gmail address.';
      });

      hasError = true;
    }

    // Password validation
    if (password.length < 8) {
      setState(() {
        passwordWarning =
            'Password must be at least 8 characters.';
      });

      hasError = true;
    }

    // Full name validation
    if (name.isEmpty) {
      hasError = true;
    }

    // Phone validation
    if (phone.isEmpty) {
      hasError = true;
    }

    if (hasError) {
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      // =====================================================
      // CREATE FIREBASE AUTH ACCOUNT
      // =====================================================

      final UserCredential userCredential =
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user == null) {
        throw Exception(
          'Unable to create technician account.',
        );
      }

      // Save technician name in Firebase Auth
      await user.updateDisplayName(name);

      // =====================================================
      // CREATE TECHNICIAN FIRESTORE PROFILE
      // =====================================================

      await TechnicianProfileService.createTechnicianProfile(
        name: name,
        email: email,
        phone: phone,
        profession: 'Technician',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Account created successfully!',
          ),
          backgroundColor: Color(0xFF10B981),
        ),
      );

      // =====================================================
      // GO TO TECHNICIAN LOGIN
      // =====================================================

      // Sign out after registration so the technician
      // explicitly logs in through the login screen.
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const TechnicianLoginScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message;

      if (e.code == 'email-already-in-use') {
        message =
            'This email is already registered. Please use another email.';
      } else if (e.code == 'invalid-email') {
        message = 'Please enter a valid email address.';
      } else if (e.code == 'weak-password') {
        message =
            'Password is too weak. Use at least 8 characters.';
      } else if (e.code == 'network-request-failed') {
        message =
            'Network error. Please check your internet connection.';
      } else {
        message =
            e.message ?? 'Unable to create account.';
      }

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted && isLoading) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // =========================================================
  // UI
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,

          padding: EdgeInsets.only(
            left: size.width * 0.055,
            right: size.width * 0.055,
            top: 16,
            bottom:
                MediaQuery.of(context).viewInsets.bottom + 25,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Back Button
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: Color(0xFF102A43),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Heading
              const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF102A43),
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Join as a Technician',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                ),
              ),

              const SizedBox(height: 27),

              // Full Name
              const Text(
                'Full Name',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334E68),
                ),
              ),

              const SizedBox(height: 7),

              _buildTextField(
                controller: fullNameController,
                hintText: 'Full Name',
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 15),

              // Email
              const Text(
                'Email',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334E68),
                ),
              ),

              const SizedBox(height: 7),

              _buildTextField(
                controller: emailController,
                hintText: 'Email',
                icon: Icons.email_outlined,
                keyboardType:
                    TextInputType.emailAddress,
              ),

              if (emailError.isNotEmpty) ...[
                const SizedBox(height: 6),

                Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 15,
                      color: Color(0xFFE53935),
                    ),

                    const SizedBox(width: 5),

                    Expanded(
                      child: Text(
                        emailError,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFE53935),
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 15),

              // Phone Number
              const Text(
                'Phone Number',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334E68),
                ),
              ),

              const SizedBox(height: 7),

              _buildTextField(
                controller: phoneController,
                hintText: 'Phone Number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 15),

              // Password
              const Text(
                'Password',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334E68),
                ),
              ),

              const SizedBox(height: 7),

              TextField(
                controller: passwordController,
                obscureText: obscurePassword,

                decoration: InputDecoration(
                  hintText: 'Password',

                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF94A3B8),
                  ),

                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    size: 19,
                    color: Color(0xFF64748B),
                  ),

                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword =
                            !obscurePassword;
                      });
                    },
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 19,
                      color:
                          const Color(0xFF64748B),
                    ),
                  ),

                  filled: true,
                  fillColor: Colors.white,

                  contentPadding:
                      const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFFE2E8F0),
                    ),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFFE2E8F0),
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFF10B981),
                      width: 1.3,
                    ),
                  ),
                ),
              ),

              if (passwordWarning.isNotEmpty) ...[
                const SizedBox(height: 6),

                Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 15,
                      color: Color(0xFF10B981),
                    ),

                    const SizedBox(width: 5),

                    Expanded(
                      child: Text(
                        passwordWarning,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 23),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                height: 49,

                child: ElevatedButton(
                  onPressed:
                      isLoading ? null : handleSignUp,

                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        const Color(0xFF94A3B8),
                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(11),
                    ),
                  ),

                  child: isLoading
                      ? const SizedBox(
                          height: 21,
                          width: 21,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // Divider
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color:
                          const Color(0xFFE2E8F0),
                    ),
                  ),

                  const Padding(
                    padding:
                        EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: Text(
                      'Or continue with',
                      style: TextStyle(
                        fontSize: 11,
                        color:
                            Color(0xFF94A3B8),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Container(
                      height: 1,
                      color:
                          const Color(0xFFE2E8F0),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 17),

              // Google Button
              SizedBox(
                width: double.infinity,
                height: 44,

                child: OutlinedButton(
                  onPressed: () {
                    // Google authentication
                    // will be connected next.
                  },

                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,

                    side: const BorderSide(
                      color: Color(0xFFE2E8F0),
                    ),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),

                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [
                      Image.asset(
                        'assets/images/google_logo.jpeg',
                        height: 19,
                        width: 19,
                      ),

                      const SizedBox(width: 9),

                      const Text(
                        'Continue with Google',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              Color(0xFF334E68),
                          fontWeight:
                              FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Login
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const TechnicianLoginScreen(),
                        ),
                      );
                    },

                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // TEXT FIELD
  // =========================================================

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,

      decoration: InputDecoration(
        hintText: hintText,

        hintStyle: const TextStyle(
          fontSize: 13,
          color: Color(0xFF94A3B8),
        ),

        prefixIcon: Icon(
          icon,
          size: 19,
          color: const Color(0xFF64748B),
        ),

        filled: true,
        fillColor: Colors.white,

        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFFE2E8F0),
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFFE2E8F0),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFF10B981),
            width: 1.3,
          ),
        ),
      ),
    );
  }
}