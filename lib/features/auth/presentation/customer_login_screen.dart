import 'package:final_project/features/auth/data/services/authentication_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomerLoginScreen extends StatefulWidget {
  const CustomerLoginScreen({super.key});

  @override
  State<CustomerLoginScreen> createState() =>
      _CustomerLoginScreenState();
}

class _CustomerLoginScreenState
    extends State<CustomerLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoggingIn = false;

  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  // ==========================================================
  // EMAIL VALIDATION
  // ==========================================================

  String? _checkEmail(String email) {
    if (email.isEmpty) {
      return 'Email is required.';
    }

    final emailRegex = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  // ==========================================================
  // LOGIN
  // ==========================================================

  Future<void> _handleLogin() async {
    if (_isLoggingIn) return;

    // Close keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Clear old errors first
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    // ========================================================
    // CHECK EMAIL
    // ========================================================

    final emailError = _checkEmail(email);

    if (emailError != null) {
      setState(() {
        _emailError = emailError;
      });
      return;
    }

    // ========================================================
    // CHECK PASSWORD
    // ========================================================

    if (password.isEmpty) {
      setState(() {
        _passwordError = 'Password is required.';
      });
      return;
    }

    // ========================================================
    // START LOGIN
    // ========================================================

    setState(() {
      _isLoggingIn = true;
    });

    try {
      final UserCredential? user = await customerLogin(
        email: email,
        password: password,
      );

      if (!mounted) return;

      // ======================================================
      // LOGIN SUCCESS
      // ======================================================

      if (user != null) {
        setState(() {
          _isLoggingIn = false;
        });

        context.go('/customer-homepage');
        return;
      }

      // ======================================================
      // LOGIN FAILED
      // ======================================================

      setState(() {
        _isLoggingIn = false;
        _passwordError =
            'Email or password is incorrect.';
      });
    }

    // ========================================================
    // FIREBASE AUTH ERROR
    // ========================================================

    on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoggingIn = false;
      });

      if (e.code == 'invalid-credential') {
        setState(() {
          _passwordError =
              'Email or password is incorrect.';
        });
        return;
      }

      if (e.code == 'wrong-password') {
        setState(() {
          _passwordError =
              'Incorrect password.';
        });
        return;
      }

      if (e.code == 'user-not-found') {
        setState(() {
          _emailError =
              'No account found with this email.';
        });
        return;
      }

      if (e.code == 'invalid-email') {
        setState(() {
          _emailError =
              'Please enter a valid email address.';
        });
        return;
      }

      if (e.code == 'user-disabled') {
        setState(() {
          _emailError =
              'This account has been disabled.';
        });
        return;
      }

      // Other unexpected Firebase errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message ??
                'Something went wrong. Please try again.',
          ),
        ),
      );
    }

    // ========================================================
    // OTHER ERROR
    // ========================================================

    catch (e) {
      debugPrint('LOGIN ERROR: $e');

      if (!mounted) return;

      setState(() {
        _isLoggingIn = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Something went wrong. Please try again.',
          ),
        ),
      );
    }
  }

  // ==========================================================
  // BUILD
  // ==========================================================

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

              // =================================================
              // BACK BUTTON
              // =================================================

              GestureDetector(
                onTap: _isLoggingIn
                    ? null
                    : () {
                        FocusManager.instance
                            .primaryFocus
                            ?.unfocus();

                        context.pop();
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

              // =================================================
              // HEADING
              // =================================================

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
                'Login as a Customer',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                ),
              ),

              const SizedBox(height: 30),

              // =================================================
              // EMAIL LABEL
              // =================================================

              const Text(
                'Email',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334E68),
                ),
              ),

              const SizedBox(height: 7),

              // =================================================
              // EMAIL FIELD
              // =================================================

              TextField(
                controller: _emailController,
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

                  enabledBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFFE2E8F0),
                    ),
                  ),

                  focusedBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFF10B981),
                      width: 1.3,
                    ),
                  ),
                ),
              ),

              // =================================================
              // EMAIL ERROR
              // =================================================

              if (_emailError != null) ...[
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
                        _emailError!,
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

              // =================================================
              // PASSWORD LABEL
              // =================================================

              const Text(
                'Password',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334E68),
                ),
              ),

              const SizedBox(height: 7),

              // =================================================
              // PASSWORD FIELD
              // =================================================

              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,

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
                        _obscurePassword =
                            !_obscurePassword;
                      });
                    },

                    icon: Icon(
                      _obscurePassword
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

                  enabledBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFFE2E8F0),
                    ),
                  ),

                  focusedBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFF10B981),
                      width: 1.3,
                    ),
                  ),
                ),
              ),

              // =================================================
              // PASSWORD ERROR
              // =================================================

              if (_passwordError != null) ...[
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
                        _passwordError!,
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

              // =================================================
              // FORGOT PASSWORD
              // =================================================

              Align(
                alignment: Alignment.centerRight,

                child: TextButton(
                  onPressed: _isLoggingIn
                      ? null
                      : () {
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

              // =================================================
              // LOGIN BUTTON
              // =================================================

              SizedBox(
                width: double.infinity,
                height: 49,

                child: ElevatedButton(
                  onPressed:
                      _isLoggingIn
                          ? null
                          : _handleLogin,

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

                  child: _isLoggingIn
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

              // =================================================
              // DIVIDER
              // =================================================

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

              // =================================================
              // GOOGLE LOGIN
              // =================================================

              SizedBox(
                width: double.infinity,
                height: 44,

                child: OutlinedButton(
                  onPressed: _isLoggingIn
                      ? null
                      : () async {
                          if (_isLoggingIn) return;

                          FocusManager.instance
                              .primaryFocus
                              ?.unfocus();
                              setState(() {
                            _isLoggingIn = true;
                          });

                          try {
                            final UserCredential?
                                credential =
                                await customerSignUpWithGoogle();

                            if (!mounted) return;

                            if (credential != null) {
                              context.go(
                                '/customer-homepage',
                              );
                            } else {
                              setState(() {
                                _isLoggingIn = false;
                              });
                            }
                          } catch (e) {
                            debugPrint(
                              'Google login error: $e',
                            );

                            if (!mounted) return;

                            setState(() {
                              _isLoggingIn = false;
                            });

                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Google login failed. Please try again.',
                                ),
                              ),
                            );
                          }
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

              // =================================================
              // SIGN UP
              // =================================================

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
                    onTap: _isLoggingIn
                        ? null
                        : () {
                            context.push(
                              '/customer-signup',
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