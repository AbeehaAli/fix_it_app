import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomerSettingsScreen extends StatefulWidget {
  const CustomerSettingsScreen({super.key});

  @override
  State<CustomerSettingsScreen> createState() =>
      _CustomerSettingsScreenState();
}


// ============================================================
// SETTINGS SCREEN
// ============================================================

class _CustomerSettingsScreenState
    extends State<CustomerSettingsScreen> {
  bool notificationsEnabled = true;
  bool jobNotifications = true;
  bool messageNotifications = true;
  bool serviceNotifications = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final screenWidth = size.width;
    final screenHeight = size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: false,

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: screenWidth * 0.055,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () {
            context.pop();
          },
        ),

        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: screenWidth * 0.06,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.015,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              
              // ==================================================
              // NOTIFICATIONS
              // ==================================================

              _sectionTitle(
                context,
                'Notifications',
              ),

              SizedBox(
                height: screenHeight * 0.012,
              ),

              _settingsCard(
                context,
                children: [
                  _switchTile(
                    context: context,
                    icon: Icons.notifications_none_rounded,
                    title: 'Notifications',
                    subtitle:
                        'Receive notifications from the app',
                    value: notificationsEnabled,
                    enabled: true,
                    onChanged: (value) {
                      setState(() {
                        notificationsEnabled = value;

                        if (!value) {
                          jobNotifications = false;
                          messageNotifications = false;
                          serviceNotifications = false;
                        }
                      });
                    },
                  ),

                  _divider(context),

                  _switchTile(
                    context: context,
                    icon: Icons.calendar_today_outlined,
                    title: 'Job Updates',
                    subtitle:
                        'Updates about your service requests',
                    value: jobNotifications,
                    enabled: notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        jobNotifications = value;
                      });
                    },
                  ),

                  _divider(context),

                  _switchTile(
                    context: context,
                    icon: Icons.chat_bubble_outline_rounded,
                    title: 'Messages',
                    subtitle:
                        'New messages from technicians',
                    value: messageNotifications,
                    enabled: notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        messageNotifications = value;
                      });
                    },
                  ),

                  _divider(context),

                  _switchTile(
                    context: context,
                    icon: Icons.auto_awesome_outlined,
                    title: 'Service Recommendations',
                    subtitle:
                        'Recommended services and technicians',
                    value: serviceNotifications,
                    enabled: notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        serviceNotifications = value;
                      });
                    },
                  ),
                ],
              ),

              SizedBox(
                height: screenHeight * 0.028,
              ),

              // ==================================================
              // ACCOUNT
              // ==================================================

              _sectionTitle(
                context,
                'Account',
              ),

              SizedBox(
                height: screenHeight * 0.012,
              ),

              _settingsCard(
                context,
                children: [
                  _navigationTile(
                    context: context,
                    icon: Icons.lock_outline_rounded,
                    title: 'Change Password',
                    subtitle:
                        'Update your account password',
                    onTap: () {
                      _showChangePasswordScreen(context);
                    },
                  ),
                ],
              ),

              SizedBox(
                height: screenHeight * 0.028,
              ),

              // ==================================================
              // SUPPORT & INFORMATION
              // ==================================================

              _sectionTitle(
                context,
                'Support & Information',
              ),

              SizedBox(
                height: screenHeight * 0.012,
              ),

              _settingsCard(
                context,
                children: [
                  _navigationTile(
                    context: context,
                    icon: Icons.help_outline_rounded,
                    title: 'Help & Support',
                    subtitle:
                        'Get help with the application',
                    onTap: () {
                      _showHelpDialog(context);
                    },
                  ),

                  _divider(context),

                  _navigationTile(
                    context: context,
                    icon: Icons.description_outlined,
                    title: 'Terms & Conditions',
                    subtitle:
                        'Read our terms and conditions',
                    onTap: () {
                      _showInformationDialog(
                        context,
                        title: 'Terms & Conditions',
                        message:
                            'Terms and conditions for using the application will appear here.',
                      );
                    },
                  ),

                  _divider(context),

                  _navigationTile(
                    context: context,
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    subtitle:
                        'Learn how your information is used',
                    onTap: () {
                      _showInformationDialog(
                        context,
                        title: 'Privacy Policy',
                        message:
                            'Our privacy policy information will appear here.',
                      );
                    },
                  ),

                  _divider(context),

                  _navigationTile(
                    context: context,
                    icon: Icons.info_outline_rounded,
                    title: 'About App',
                    subtitle:
                        'Information about this application',
                    onTap: () {
                      _showInformationDialog(
                        context,
                        title: 'About App',
                        message:
                            'Customer Service App\n\nVersion 1.0.0',
                      );
                    },
                  ),
                ],
              ),

              
              

             
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _sectionTitle(
    BuildContext context,
    String title,
  ) {
    final size = MediaQuery.of(context).size;

    return Text(
      title,
      style: TextStyle(
        fontSize: size.width * 0.043,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  // ============================================================
  // SETTINGS CARD
  // ============================================================

  Widget _settingsCard(
    BuildContext context, {
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  

  // ============================================================
  // SWITCH TILE
  // ============================================================

  Widget _switchTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required bool enabled,
    required ValueChanged<bool> onChanged,
  }) {
    final size = MediaQuery.of(context).size;

    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04,
          vertical: size.height * 0.014,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: size.width * 0.06,
              color: const Color(0xFF12A66A),
            ),

            SizedBox(
              width: size.width * 0.035,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: size.width * 0.038,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface,
                    ),
                  ),

                  SizedBox(
                    height: size.height * 0.004,
                  ),

                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: size.width * 0.031,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            Switch(
              value: value,
              onChanged: enabled ? onChanged : null,
              activeColor: const Color(0xFF12A66A),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // NAVIGATION TILE
  // ============================================================

  Widget _navigationTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04,
          vertical: size.height * 0.017,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: size.width * 0.06,
              color: const Color(0xFF12A66A),
            ),

            SizedBox(
              width: size.width * 0.035,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: size.width * 0.038,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface,
                    ),
                  ),

                  SizedBox(
                    height: size.height * 0.004,
                  ),

                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: size.width * 0.031,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios_rounded,
              size: size.width * 0.035,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DIVIDER
  // ============================================================

  Widget _divider(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: Theme.of(context).dividerColor,
    );
  }

  // ============================================================
  // CHANGE PASSWORD
  // ============================================================

  void _showChangePasswordScreen(
    BuildContext context,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const CustomerChangePasswordScreen(),
      ),
    );
  }

  // ============================================================
  // HELP DIALOG
  // ============================================================

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Help & Support',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'If you need help with your account, '
            'service request, technician, or messages, '
            'please contact our support team.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Close',
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // INFORMATION DIALOG
  // ============================================================

  void _showInformationDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Close',
              ),
            ),
          ],
        );
      },
    );
  }
    }

// ============================================================
// CHANGE PASSWORD SCREEN
// ============================================================

class CustomerChangePasswordScreen extends StatefulWidget {
  const CustomerChangePasswordScreen({
    super.key,
  });

  @override
  State<CustomerChangePasswordScreen> createState() =>
      _CustomerChangePasswordScreenState();
}

class _CustomerChangePasswordScreenState
    extends State<CustomerChangePasswordScreen> {
  final TextEditingController currentPasswordController =
      TextEditingController();

  final TextEditingController newPasswordController =
      TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool obscureCurrent = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  bool isLoading = false;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Change Password',
          style: TextStyle(
            fontSize: size.width * 0.055,
            fontWeight: FontWeight.bold,
            color: Theme.of(context)
                .colorScheme
                .onSurface,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
            vertical: size.height * 0.025,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Update your password',
                style: TextStyle(
                  fontSize: size.width * 0.045,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface,
                ),
              ),

              SizedBox(
                height: size.height * 0.008,
              ),

              Text(
                'Enter your current password and choose a new one.',
                style: TextStyle(
                  fontSize: size.width * 0.034,
                  color: Colors.grey.shade600,
                ),
              ),

              SizedBox(
                height: size.height * 0.03,
              ),

              _passwordField(
                context,
                controller: currentPasswordController,
                label: 'Current Password',
                obscureText: obscureCurrent,
                onVisibilityTap: () {
                  setState(() {
                    obscureCurrent = !obscureCurrent;
                  });
                },
              ),

              SizedBox(
                height: size.height * 0.018,
              ),

              _passwordField(
                context,
                controller: newPasswordController,
                label: 'New Password',
                obscureText: obscureNew,
                onVisibilityTap: () {
                  setState(() {
                    obscureNew = !obscureNew;
                  });
                },
              ),

              SizedBox(
                height: size.height * 0.018,
              ),

              _passwordField(
                context,
                controller: confirmPasswordController,
                label: 'Confirm New Password',
                obscureText: obscureConfirm,
                onVisibilityTap: () {
                  setState(() {
                    obscureConfirm = !obscureConfirm;
                  });
                },
              ),

              SizedBox(
                height: size.height * 0.03,
              ),

              SizedBox(
                width: double.infinity,
                height: size.height * 0.06,
                child: ElevatedButton(
                  onPressed:
                      isLoading ? null : _changePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF12A66A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          'Update Password',
                          style: TextStyle(
                            fontSize:
                                size.width * 0.038,
                            fontWeight:
                                FontWeight.w600,
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
// ============================================================
  // PASSWORD FIELD
  // ============================================================

  Widget _passwordField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onVisibilityTap,
  }) {
    final size = MediaQuery.of(context).size;

    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(
          Icons.lock_outline_rounded,
        ),
        suffixIcon: IconButton(
          onPressed: onVisibilityTap,
          icon: Icon(
            obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFF12A66A),
          ),
        ),
      ),
      style: TextStyle(
        fontSize: size.width * 0.038,
      ),
    );
  }

  // ============================================================
  // CHANGE PASSWORD FUNCTION
  // ============================================================

  Future<void> _changePassword() async {
    final currentPassword =
        currentPasswordController.text.trim();

    final newPassword =
        newPasswordController.text.trim();

    final confirmPassword =
        confirmPasswordController.text.trim();

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage(
        'Please fill in all fields.',
      );
      return;
    }

    if (newPassword.length < 8) {
      _showMessage(
        'New password must be at least 8 characters.',
      );
      return;
    }

    if (newPassword != confirmPassword) {
      _showMessage(
        'New passwords do not match.',
      );
      return;
    }

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null ||
        user.email == null) {
      _showMessage(
        'No customer account is currently signed in.',
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      final credential =
          EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(
        credential,
      );

      await user.updatePassword(
        newPassword,
      );

      if (!mounted) return;

      _showMessage(
        'Password updated successfully.',
      );

      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      if (e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        _showMessage(
          'Current password is incorrect.',
        );
      } else if (e.code == 'weak-password') {
        _showMessage(
          'The new password is too weak.',
        );
      } else {
        _showMessage(
          e.message ?? 'Could not update password.',
        );
      }
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Could not update password.',
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
  