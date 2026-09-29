import 'package:final_project/features/auth/data/services/authentication_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomerSignupScreen extends StatefulWidget {
  const CustomerSignupScreen({super.key});

  @override
  State<CustomerSignupScreen> createState() =>
      _CustomerSignupScreenState();
}

class _CustomerSignupScreenState
    extends State<CustomerSignupScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _obscurePassword = true;
  bool _isSigningUp = false;

  String? _fullNameError;
  String? _emailError;
  String? _phoneError;
  String? _passwordError;

  bool _nameTouched = false;
  bool _emailTouched = false;
  bool _phoneTouched = false;
  bool _passwordTouched = false;

  @override
  void initState() {
    super.initState();

    // Full name: validate only after user leaves the field.
    _nameFocus.addListener(() {
      if (_nameFocus.hasFocus) {
        _nameTouched = true;
      } else if (_nameTouched) {
        _validateName();
      }
    });

    // Email: validate only after user leaves the field.
    _emailFocus.addListener(() {
      if (_emailFocus.hasFocus) {
        _emailTouched = true;
      } else if (_emailTouched) {
        _validateEmailField();
      }
    });

    // Phone: validate only after user leaves the field.
    _phoneFocus.addListener(() {
      if (_phoneFocus.hasFocus) {
        _phoneTouched = true;
      } else if (_phoneTouched) {
        _validatePhone();
      }
    });

    // Password: validate only after user leaves the field.
    _passwordFocus.addListener(() {
      if (_passwordFocus.hasFocus) {
        _passwordTouched = true;
      } else if (_passwordTouched) {
        _validatePasswordField();
      }
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();

    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();

    super.dispose();
  }

  // ============================================================
  // NAME
  // ============================================================

  void _validateName() {
    final name = _fullNameController.text.trim();

    if (!mounted) return;

    setState(() {
      _fullNameError =
          name.isEmpty ? 'Full name is required.' : null;
    });
  }

  // ============================================================
  // EMAIL
  // ============================================================

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

  void _validateEmailField() {
    final email = _emailController.text.trim();

    if (!mounted) return;

    if (email.isEmpty) {
      setState(() {
        _emailError = null;
      });
      return;
    }

    setState(() {
      _emailError = _checkEmail(email);
    });
  }

  // ============================================================
  // PHONE
  // ============================================================

  void _validatePhone() {
    final phone = _phoneController.text.trim();

    if (!mounted) return;

    setState(() {
      _phoneError =
          phone.isEmpty ? 'Phone number is required.' : null;
    });
  }

  // ============================================================
  // PASSWORD
  // ============================================================

  String? _checkPassword(String password) {
    if (password.isEmpty) {
      return 'Password is required.';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters.';
    }

    return null;
  }

  void _validatePasswordField() {
    final password = _passwordController.text;

    if (!mounted) return;

    if (password.isEmpty) {
      setState(() {
        _passwordError = null;
      });
      return;
    }

    setState(() {
      _passwordError = _checkPassword(password);
    });
  }

  // ============================================================
  // SIGN UP
  // ============================================================

  Future<void> _handleSignUp() async {
    if (_isSigningUp) return;

    FocusManager.instance.primaryFocus?.unfocus();

    final name = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _nameTouched = true;
      _emailTouched = true;
      _phoneTouched = true;
      _passwordTouched = true;

      _fullNameError =
          name.isEmpty ? 'Full name is required.' : null;

      _emailError = _checkEmail(email);

      _phoneError =
          phone.isEmpty ? 'Phone number is required.' : null;

      _passwordError = _checkPassword(password);
    });

    if (_fullNameError != null ||
        _emailError != null ||
        _phoneError != null ||
        _passwordError != null) {
      return;
    }

    setState(() {
      _isSigningUp = true;
    });

    try {
      final UserCredential? result = await customerSignUp(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );

      final User? user =
          result?.user ?? FirebaseAuth.instance.currentUser;

      if (user == null) {
        if (!mounted) return;

        setState(() {
          _isSigningUp = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Unable to create your account. Please try again.',
            ),
          ),
        );

        return;
      }

      try {
        await user.updateDisplayName(name);
        await user.reload();
      } catch (e) {
        debugPrint(
          'Could not update display name: $e',
        );
      }

      if (!mounted) return;

      context.go('/customer-Login');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        _isSigningUp = false;
      });

      if (e.code == 'email-already-in-use') {
        setState(() {
          _isSigningUp = false;
          _emailError =
              'This email is already in use.';
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

      if (e.code == 'weak-password') {
        setState(() {
          _passwordError =
              'Password must be at least 8 characters.';
        });
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message ??
                'Something went wrong. Please try again.',
          ),
        ),
      );
    } catch (e) {
      debugPrint('SIGN UP ERROR: $e');

      if (!mounted) return;

      setState(() {
        _isSigningUp = false;
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

  // ============================================================
  // BUILD
  // ============================================================

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
                onTap: _isSigningUp
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

              const SizedBox(height: 25),

              // =================================================
              // HEADING
              // =================================================

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
                'Join as a Customer',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                ),
              ),

              const SizedBox(height: 27),

              // =================================================
              // FULL NAME
              // =================================================

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
                controller: _fullNameController,
                focusNode: _nameFocus,
                hintText: 'Full Name',
                icon: Icons.person_outline,
                errorText: _fullNameError,
              ),

              const SizedBox(height: 15),

              // =================================================
              // EMAIL
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

              _buildTextField(
                controller: _emailController,
                focusNode: _emailFocus,
                hintText: 'Email',
                icon: Icons.email_outlined,
                keyboardType:
                    TextInputType.emailAddress,
                errorText: _emailError,
              ),

              const SizedBox(height: 15),

              // =================================================
              // PHONE
              // =================================================

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
                controller: _phoneController,
                focusNode: _phoneFocus,
                hintText: 'Phone Number',
                icon: Icons.phone_outlined,
                keyboardType:
                    TextInputType.phone,
                errorText: _phoneError,
              ),

              const SizedBox(height: 15),

              // =================================================
              // PASSWORD
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

              TextField(
                controller: _passwordController,
                focusNode: _passwordFocus,
                obscureText: _obscurePassword,

                textInputAction:
                    TextInputAction.done,

                onChanged: (value) {
                  setState(() {});
                },

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

                  errorText: _passwordError,

                  errorStyle: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFFE53935),
                  ),

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(
                      color: Color(0xFFE2E8F0),
                    ),
                  ),

                  enabledBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(
                      color: Color(0xFFE2E8F0),
                    ),
                  ),

                  focusedBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(
                      color: Color(0xFF10B981),
                      width: 1.3,
                    ),
                  ),

                  errorBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(
                      color: Color(0xFFE53935),
                    ),
                  ),

                  focusedErrorBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(
                      color: Color(0xFFE53935),
                      width: 1.3,
                    ),
                  ),
                ),
              ),

              // =================================================
              // PASSWORD WARNING
              // =================================================

              Padding(
                padding: const EdgeInsets.only(
                  top: 6,
                  left: 5,
                ),

                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 15,
                      color: Color(0xFF10B981),
                    ),

                    const SizedBox(width: 5),

                    Expanded(
                      child: Text(
                        _passwordController
                                    .text.length >=
                                8
                            ? 'Password length is valid'
                            : 'Password must be at least 8 characters.',

                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 23),

              // =================================================
              // SIGN UP BUTTON
              // =================================================

              SizedBox(
                width: double.infinity,
                height: 49,

                child: ElevatedButton(
                  onPressed:
                      _isSigningUp
                          ? null
                          : _handleSignUp,

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

                  child: _isSigningUp
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
              // GOOGLE BUTTON
              // =================================================

              SizedBox(
                width: double.infinity,
                height: 44,

                child: OutlinedButton(
                  onPressed: _isSigningUp
                      ? null
                      : () async {
                          if (_isSigningUp) return;

                          FocusManager.instance
                              .primaryFocus
                              ?.unfocus();

                          setState(() {
                            _isSigningUp = true;
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
                                _isSigningUp = false;
                              });
                            }
                          } catch (e) {
                            debugPrint(
                              'Google signup error: $e',
                            );

                            if (!mounted) return;

                            setState(() {
                              _isSigningUp = false;
                            });

                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Google signup failed. Please try again.',
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

              // =================================================
              // LOGIN
              // =================================================

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(
                      fontSize: 11,
                      color:
                          Color(0xFF64748B),
                    ),
                  ),

                  GestureDetector(
                    onTap: _isSigningUp
                        ? null
                        : () {
                            context.push(
                              '/customer-Login',
                            );
                          },

                    child: const Text(
                      'Login',
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

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    required IconData icon,
    String? errorText,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
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

        errorText: errorText,

        errorStyle: const TextStyle(
          fontSize: 11,
          color: Color(0xFFE53935),
        ),

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(10),
          borderSide:
              const BorderSide(
            color: Color(0xFFE2E8F0),
          ),
        ),

        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(10),
          borderSide:
              const BorderSide(
            color: Color(0xFFE2E8F0),
          ),
        ),

        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(10),
          borderSide:
              const BorderSide(
            color: Color(0xFF10B981),
            width: 1.3,
          ),
        ),

        errorBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(10),
          borderSide:
              const BorderSide(
            color: Color(0xFFE53935),
          ),
        ),

        focusedErrorBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(10),
          borderSide:
              const BorderSide(
            color: Color(0xFFE53935),
            width: 1.3,
          ),
        ),
      ),
    );
  }
}