import 'package:final_project/features/firebase/data/services/technician_profile_service.dart';
import 'package:final_project/features/technician/presentation/pages/bottom_nav_bar.dart';
import 'package:final_project/features/technician/presentation/pages/edit_technician_profile.dart';
import 'package:final_project/features/technician/presentation/pages/technician_bank_detail_screen.dart';
import 'package:final_project/features/technician/presentation/pages/technician_help_support_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'technician_services_screen.dart';
import 'technician_login_screen.dart';
import 'technician_home_screen.dart';
import 'technician_jobs_screen.dart';
import 'technician_earnings_screen.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class TechnicianProfileScreen extends StatefulWidget {
  const TechnicianProfileScreen({super.key});

  @override
  State<TechnicianProfileScreen> createState() =>
      _TechnicianProfileScreenState();
}

class _TechnicianProfileScreenState
    extends State<TechnicianProfileScreen> {
  int currentIndex = 3;

  bool isAvailable = true;
  bool isLoadingProfile = true;
  bool isUpdatingAvailability = false;

  String technicianName = 'Technician';
  String technicianProfession = 'Technician';
  double technicianRating = 0;

  String technicianProfileImageUrl ='';
  String technicianProfileImageBase64 = '';
  bool isUploadingprofilePicture = false;

  @override
  void initState() {
    super.initState();
    loadTechnicianProfile();
  }

  // =========================================================
  // LOAD TECHNICIAN PROFILE
  // =========================================================

  Future<void> loadTechnicianProfile() async {
    try {
      final profile =
          await TechnicianProfileService.getCurrentTechnicianProfile();

      if (!mounted) return;

      if (profile != null && profile.exists) {
        final data = profile.data();

        if (data != null) {
          final rating = data['rating'];

          setState(() {
            technicianName =
                data['name']?.toString() ?? 'Technician';

            technicianProfession =
                data['profession']?.toString() ?? 'Technician';

            technicianProfileImageUrl =
                 data['profileImageUrl']?.toString()?? '';
            
            technicianProfileImageBase64 =
                 data['profileImageBase64']?.toString()?? '';

            isAvailable =
                data['availability'] == true;


            if (rating is num) {
              technicianRating = rating.toDouble();
            } else {
              technicianRating = 0;
            }

            isLoadingProfile = false;
          });
        } else {
          setState(() {
            isLoadingProfile = false;
          });
        }
      } else {
        setState(() {
          isLoadingProfile = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingProfile = false;
      });
    }
  }

// =========================================================
// PROFILE PICTURE
// =========================================================

Future<void> changeProfilePicture() async {
  if (isUploadingprofilePicture) return;

  try {
    final ImagePicker picker = ImagePicker();

    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 400,
      maxHeight: 400,
    );

    if (pickedImage == null) return;

    if (!mounted) return;

    setState(() {
      isUploadingprofilePicture = true;
    });

    final bytes = await pickedImage.readAsBytes();

    final imageBase64 = base64Encode(bytes);

    await TechnicianProfileService
        .updateProfilePictureBase64(
      imageBase64,
    );

    if (!mounted) return;

    setState(() {
      technicianProfileImageUrl = '';
      technicianProfileImageBase64 = imageBase64;
      isUploadingprofilePicture = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Profile picture updated successfully.',
        ),
        backgroundColor: Color(0xFF10B981),
      ),
    );
  } catch (e) {
    debugPrint(
      'PROFILE PICTURE ERROR: $e',
    );

    if (!mounted) return;

    setState(() {
      isUploadingprofilePicture = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Profile picture error: $e',
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  // =========================================================
  // EDIT PROFILE
  // =========================================================

  Future<void> openEditProfile() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const EditTechnicianProfileScreen(),
      ),
    );

    if (updated == true) {
      loadTechnicianProfile();
    }
  }

  // =========================================================
  // AVAILABILITY
  // =========================================================

  Future<void> changeAvailability(bool value) async {
    if (isUpdatingAvailability) return;

    final previousValue = isAvailable;

    setState(() {
      isAvailable = value;
      isUpdatingAvailability = true;
    });

    try {
      await TechnicianProfileService.updateAvailability(value);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isAvailable = previousValue;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to update availability.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isUpdatingAvailability = false;
        });
      }
    }
  }

  // =========================================================
  // LOGOUT
  // =========================================================

  Future<void> handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const TechnicianLoginScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to logout. Please try again.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // =========================================================
  // BOTTOM NAVIGATION
  // =========================================================

  void changeBottomTab(int index) {
    if (index == currentIndex) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const TechnicianHomeScreen(),
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const TechnicianJobsScreen(),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const TechnicianEarningsScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 19,
            color: Color(0xFF102A43),
          ),
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF102A43),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          5,
          20,
          25,
        ),
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                children: [
                Stack(
  clipBehavior: Clip.none,
  children: [
    GestureDetector(
      onTap: changeProfilePicture,
      child: Container(
        height: 76,
        width: 76,
        decoration: const BoxDecoration(
          color: Color(0xFFE2E8F0),
          shape: BoxShape.circle,
        ),
        clipBehavior: Clip.antiAlias,
        child:  isUploadingprofilePicture
            ? const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Color(0xFF10B981),
                ),
              )
            : technicianProfileImageBase64.isNotEmpty
                ? Image.memory(
                  base64Decode(
                    technicianProfileImageBase64,
                  ),
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) {
                      return const Icon(
                        Icons.person,
                        size: 42,
                        color: Color(0xFF64748B),
                      );
                    },
                  )
                : const Icon(
                    Icons.person,
                    size: 42,
                    color: Color(0xFF64748B),
                  ),
      ),
    ),

    Positioned(
      right: -2,
      bottom: -2,
      child: GestureDetector(
        onTap: changeProfilePicture,
        child: Container(
          height: 27,
          width: 27,
          decoration: BoxDecoration(
            color: const Color(0xFF10B981),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.edit,
            size: 14,
            color: Colors.white,
          ),
        ),
      ),
    ),
  ],
),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          isLoadingProfile
                              ? 'Technician'
                              : technicianName,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF102A43),
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          isLoadingProfile
                              ? 'Technician'
                              : technicianProfession,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),

                        const SizedBox(height: 7),

                        Row(
                          children: List.generate(5, 
                          (index){
                            return Icon(
                              Icons.star,
                              size: 17,
                              color: index < technicianRating ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                            );
                          }
                          )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Profile Options
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                ),
              ),
              child: Column(
                children: [
                  _profileItem(
                    icon: Icons.edit_outlined,
                    title: 'Edit Profile',
                    onTap: openEditProfile,
                  ),

                  _divider(),

                  _profileItem(
                    icon: Icons.calendar_month_outlined,
                    title: 'My Services',
                    onTap: () async {
                      final updated = await Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const TechnicianServicesScreen(),
                        ));
                        if (updated == true) {
                          loadTechnicianProfile();
                        } 
                    },
                  ),

                  _divider(),

                  // Availability
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 15,
                    ),
                    child: Row(
                      children: [
                        _iconContainer(
                          Icons.access_time,
                        ),

                        const SizedBox(width: 13),

                        const Expanded(
                          child: Text(
                            'Availability',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF334E68),
                            ),
                          ),
                        ),

                        Switch(
                          value: isAvailable,
                          activeColor:
                              const Color(0xFF10B981),
                          onChanged:
                              isUpdatingAvailability
                                  ? null
                                  : changeAvailability,
                        ),
                      ],
                    ),
                  ),

                  _divider(),

                  _profileItem(
                    icon: Icons.account_balance_outlined,
                    title: 'Bank Details',
                    onTap: () async {
                     await Navigator.push(context,
                     MaterialPageRoute(builder: (context) => const TechnicianBankDetailsScreen(),));
                    },
                  ),

                  _divider(),

                  _profileItem(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: ()  async{
                      await Navigator.push(context,
                       MaterialPageRoute(builder: (context) => TechnicianHelpSupportScreen(),));

                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Logout
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: handleLogout,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Color(0xFFFFB4B4),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE53935),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: TechnicianBottomNavBar(
        currentIndex: currentIndex,
        onTap: changeBottomTab,
      ),
    );
  }

  Widget _profileItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        child: Row(
          children: [
            _iconContainer(icon),

            const SizedBox(width: 13),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334E68),
                ),
              ),
            ),

            const Icon(
              Icons.chevron_right,
              size: 20,
              color: Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconContainer(IconData icon) {
    return Container(
      height: 34,
      width: 34,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Icon(
        icon,
        size: 19,
        color: const Color(0xFF334E68),
      ),
    );
  }

  Widget _divider() {
    return const Divider(
      height: 1,
      color: Color(0xFFF1F5F9),
    );
  }
}