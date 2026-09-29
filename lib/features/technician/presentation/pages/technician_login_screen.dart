import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_project/features/technician/presentation/pages/technician_signUp_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TechnicianLoginScreen extends StatefulWidget {
  const TechnicianLoginScreen({super.key});

  @override
  State<TechnicianLoginScreen> createState() =>
      _TechnicianLoginScreenState();
}

class _TechnicianLoginScreenState extends State<TechnicianLoginScreen> {
  bool obscurePassword = true;
  bool isLoading = false;

  String emailError = '';
  String passwordError = '';

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    emailController.addListener(validateEmail);
    passwordController.addListener(validatePassword);
  }

  @override
  void dispose() {
    emailController.dispose();
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
        emailError =
            'Email is not valid. Use a Gmail address.';
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
        passwordError = '';
      });
      return;
    }

    if (password.length < 8) {
      setState(() {
        passwordError =
            'Password must be at least 8 characters.';
      });
    } else {
      setState(() {
        passwordError = '';
      });
    }
  }

  // =========================================================
  // FIREBASE TECHNICIAN LOGIN
  // =========================================================

  Future<void> handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    bool hasError = false;

    // Email validation
    if (email.isEmpty ||
        !email.toLowerCase().endsWith('@gmail.com')) {
      setState(() {
        emailError =
            'Email is not valid. Use a Gmail address.';
      });

      hasError = true;
    }

    // Password validation
    if (password.length < 8) {
      setState(() {
        passwordError =
            'Password must be at least 8 characters.';
      });

      hasError = true;
    }

    // Stop if input is invalid
    if (hasError) {
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      // =====================================================
      // STEP 1: LOGIN WITH FIREBASE AUTH
      // =====================================================

      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user == null) {
        throw Exception('Unable to login. Please try again.');
      }

      // =====================================================
      // STEP 2: CHECK TECHNICIAN PROFILE
      // =====================================================

      final technicianDocument =
          await _firestore
              .collection('technicians')
              .doc(user.uid)
              .get();

      // =====================================================
      // STEP 3: PREVENT CUSTOMER FROM ENTERING TECHNICIAN SIDE
      // =====================================================

      if (!technicianDocument.exists) {
        await _auth.signOut();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'This account is not registered as a technician.',
            ),
            backgroundColor: Colors.red,
          ),
        );

        return;
      }

      // =====================================================
      // STEP 4: SUCCESSFUL TECHNICIAN LOGIN
      // =====================================================

      if (!mounted) return;

      context.go('/technician_homepage');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Login successful!',
          ),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message =
          'Incorrect email or password.';

      if (e.code == 'invalid-credential' ||
          e.code == 'invalid-email' ||
          e.code == 'user-not-found' ||
          e.code == 'wrong-password') {
        message = 'Incorrect email or password.';
      } else if (e.code == 'network-request-failed') {
        message =
            'Network error. Please check your internet connection.';
      } else if (e.code == 'too-many-requests') {
        message =
            'Too many login attempts. Please try again later.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
              'Exception: ',
              '',
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

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

              const SizedBox(height: 32),

              // Heading
              const Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF102A43),
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Login as a Technician',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                ),
              ),

              const SizedBox(height: 30),

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

              TextField(
                controller: emailController,
                keyboardType:
                    TextInputType.emailAddress,

                decoration: InputDecoration(
                  hintText: 'Email',

                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF94A3B8),
                  ),

                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    size: 19,
                    color: Color(0xFF64748B),
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

              // Email Error
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

              const SizedBox(height: 17),

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

              // Password Error
              if (passwordError.isNotEmpty) ...[
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
                        passwordError,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 7),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,

                child: TextButton(
                  onPressed: () {
                    // Forgot password will be
                    // connected later.
                  },

                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize:
                        const Size(0, 35),
                    tapTargetSize:
                        MaterialTapTargetSize
                            .shrinkWrap,
                  ),

                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                          FontWeight.w600,
                      color:
                          Color(0xFF10B981),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 49,

                child: ElevatedButton(
                  onPressed:
                      isLoading ? null : handleLogin,

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF10B981),
                    foregroundColor:
                        Colors.white,
                    disabledBackgroundColor:
                        const Color(0xFF94A3B8),
                    elevation: 0,

                    shape:
                        RoundedRectangleBorder(
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
                          'Login',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                FontWeight.bold,
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
                    // will be connected later.
                  },

                  style:
                      OutlinedButton.styleFrom(
                    backgroundColor:
                        Colors.white,

                    side: const BorderSide(
                      color:
                          Color(0xFFE2E8F0),
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

              const SizedBox(height: 25),

              // Sign Up
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      fontSize: 11,
                      color:
                          Color(0xFF64748B),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const TechnicianSignUpScreen(),
                        ),
                      );
                    },

                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            Color(0xFF10B981),
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
}