import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/features/customer/domain/technician_data.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_project/features/firebase/data/services/service_request_service.dart';

class TechnicianDetailsScreen extends StatefulWidget {
  final Technician technician;

  const TechnicianDetailsScreen({
    super.key,
    required this.technician,
  });

  @override
  State<TechnicianDetailsScreen> createState() =>
      _TechnicianDetailsScreenState();
}

class _TechnicianDetailsScreenState
    extends State<TechnicianDetailsScreen> {
  late Future<DocumentSnapshot<Map<String, dynamic>>>
      _technicianProfile;

  int selectedTab = 0;

  Future<void> _selectService({
  required BuildContext context,
  required String technicianId,
  required String technicianName,
  required String technicianProfession,
  required List<dynamic> services,
}) async {
  if (services.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'This technician has not added any services yet.',
        ),
      ),
    );
    return;
  }

  final selectedService = await showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24),
      ),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            15,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select a Service',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172033),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Choose the service you need from $technicianName.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 18),

              ...services.map(
                (service) {
                  final serviceName =
                      service.toString();

                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: InkWell(
                      borderRadius:
                          BorderRadius.circular(14),
                      onTap: () {
                        Navigator.pop(
                          context,
                          serviceName,
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF7F1),
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration:
                                  const BoxDecoration(
                                color: Color(0xFF12A66A),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons
                                    .home_repair_service_outlined,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: Text(
                                serviceName,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight:
                                      FontWeight.w600,
                                  color:
                                      Color(0xFF172033),
                                ),
                              ),
                            ),

                            const Icon(
                              Icons
                                  .arrow_forward_ios_rounded,
                              size: 16,
                              color:
                                  Color(0xFF12A66A),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );

  if (selectedService == null ||
      selectedService.trim().isEmpty) {
    return;
  }

  if (!context.mounted) {
    return;
  }

  final shouldSend = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text(
          'Send Service Request?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF172033),
          ),
        ),
        content: Text(
          'You are requesting "$selectedService" from $technicianName.',
          style: TextStyle(
            color: Colors.grey.shade700,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(0xFF12A66A),
              elevation: 0,
            ),
            child: const Text(
              'Send Request',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    },
  );

  if (shouldSend != true) {
    return;
  }

  try {
    await ServiceRequestService.sendRequest(
      technicianId: technicianId,
      technicianName: technicianName,
      technicianProfession:
          technicianProfession,
      service: selectedService,
    );

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Service request sent successfully.',
        ),
        backgroundColor: Color(0xFF12A66A),
      ),
    );
  } on FirebaseException catch (e) {
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Request failed: ${e.message ?? e.code}',
        ),
        backgroundColor: Colors.red,
      ),
    );
  } catch (e) {
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Request failed: $e',
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  @override
  void initState() {
    super.initState();

    _technicianProfile = FirebaseFirestore.instance
        .collection('technicians')
        .doc(widget.technician.id)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: _technicianProfile,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF12A66A),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return _errorScreen('Unable to load technician profile.');
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return _errorScreen('Technician profile not found.');
        }

        final data = snapshot.data!.data()!;

        final String name =
            data['name']?.toString().trim().isNotEmpty == true
                ? data['name'].toString()
                : widget.technician.name;

        final String profession =
            data['profession']?.toString().trim().isNotEmpty == true
                ? data['profession'].toString()
                : widget.technician.service;

        final double rating = data['rating'] is num
            ? (data['rating'] as num).toDouble()
            : 0.0;

        final bool availability = data['availability'] == true;

        final String profileImageBase64 =
            data['profileImageBase64']?.toString() ?? '';

        final String profileImageUrl =
            data['profileImageUrl']?.toString() ?? '';

        final List<dynamic> services =
            data['services'] is List
                ? data['services'] as List<dynamic>
                : [];

        final String servicesText = services.isEmpty
            ? 'No services added yet'
            : services.map((service) => service.toString()).join(', ');

        Widget profileImage;

        if (profileImageBase64.isNotEmpty) {
          try {
            profileImage = Image.memory(
              base64Decode(profileImageBase64),
              width: double.infinity,
              height: size.height * 0.30,
              fit: BoxFit.cover,

              // Improves rendering quality when image is enlarged.
              filterQuality: FilterQuality.high,

              // Prevents unnecessary low-resolution resizing.
              gaplessPlayback: true,

              errorBuilder: (context, error, stackTrace) {
                return _defaultProfileImage(size.width);
              },
            );
          } catch (_) {
            profileImage = _defaultProfileImage(size.width);
          }
        } else if (profileImageUrl.isNotEmpty) {
          profileImage = Image.network(
            profileImageUrl,
            width: double.infinity,
            height: size.height * 0.30,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
            errorBuilder: (context, error, stackTrace) {
              return _defaultProfileImage(size.width);
            },
          );
        } else {
          profileImage = _defaultProfileImage(size.width);
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ======================================================
                  // PROFILE IMAGE
                  // ======================================================

                  Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: size.height * 0.30,
                        child: profileImage,
                      ),

                      // BACK BUTTON
                      Positioned(
                        top: size.height * 0.018,
                        left: size.width * 0.04,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: size.width * 0.11,
                            height: size.width * 0.11,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.10),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: size.width * 0.045,
                              color: const Color(0xFF172033),
                            ),
                          ),
                        ),
                      ),

                      // FAVORITE BUTTON
                      Positioned(
                        top: size.height * 0.018,
                        right: size.width * 0.04,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: size.width * 0.11,
                            height: size.width * 0.11,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.10),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.favorite_border_rounded,
                              size: size.width * 0.055,
                              color: const Color(0xFF172033),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ======================================================
                  // INFORMATION
                  // ======================================================

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: size.height * 0.022),

                        // NAME
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: size.width * 0.065,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF172033),
                          ),
                        ),

                        SizedBox(height: size.height * 0.006),

                        // PROFESSION
                        Text(
                          'Professional $profession',
                          style: TextStyle(
                            fontSize: size.width * 0.040,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        SizedBox(height: size.height * 0.018),

                        // RATING + AVAILABILITY
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: size.width * 0.055,
                              color: const Color(0xFFFFA000),
                            ),
                            SizedBox(width: size.width * 0.012),
                            Text(
                              rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: size.width * 0.038,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF172033),
                              ),
                            ),
                            SizedBox(width: size.width * 0.04),
                            Icon(
                              Icons.circle,
                              size: size.width * 0.025,
                              color: availability
                                  ? const Color(0xFF12A66A)
                                  : Colors.grey,
                            ),
                            SizedBox(width: size.width * 0.008),
                            Text(
                              availability
                                  ? 'Available'
                                  : 'Unavailable',
                              style: TextStyle(
                                fontSize: size.width * 0.035,
                                color: availability
                                    ? const Color(0xFF12A66A)
                                    : Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: size.height * 0.025),

                        // ==================================================
                        // ABOUT / REVIEWS TABS
                        // ==================================================

                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedTab = 0;
                                  });
                                },
                                child: _tabItem(
                                  title: 'About',
                                  isSelected: selectedTab == 0,
                                  size: size,
                                ),
                              ),
                            ),

                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedTab = 1;
                                  });
                                },
                                child: _tabItem(
                                  title: 'Reviews',
                                  isSelected: selectedTab == 1,
                                  size: size,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: size.height * 0.025),

                        // ==================================================
                        // ABOUT TAB
                        // ==================================================

                        if (selectedTab == 0) ...[
                          Text(
                            'About',
                            style: TextStyle(
                              fontSize: size.width * 0.045,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF172033),
                            ),
                          ),

                          SizedBox(height: size.height * 0.01),

                          Text(
                            'Professional $profession available for service requests.',
                            style: TextStyle(
                              fontSize: size.width * 0.036,
                              height: 1.5,
                              color: Colors.grey.shade700,
                            ),
                          ),

                          SizedBox(height: size.height * 0.025),

                          _InfoRow(
                            icon: Icons.home_repair_service_outlined,
                            title: 'Services',
                            value: servicesText,
                          ),

                          SizedBox(height: size.height * 0.015),

                          _InfoRow(
                            icon: Icons.star_outline_rounded,
                            title: 'Rating',
                            value: '${rating.toStringAsFixed(1)} / 5.0',
                          ),

                          SizedBox(height: size.height * 0.015),

                          _InfoRow(
                            icon: Icons.access_time_rounded,
                            title: 'Availability',
                            value: availability
                                ? 'Available Now'
                                : 'Currently Unavailable',
                          ),
                        ],

                        // ==================================================
                        // REVIEWS TAB
                        // ==================================================

                        if (selectedTab == 1)
                          SizedBox(
                            width: double.infinity,
                            height: size.height * 0.20,
                            child: Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.rate_review_outlined,
                                    size: size.width * 0.12,
                                    color: Colors.grey.shade400,
                                  ),
                                  SizedBox(
                                    height: size.height * 0.012,
                                  ),
                                  Text(
                                    'No reviews yet',
                                    style: TextStyle(
                                      fontSize: size.width * 0.040,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        SizedBox(height: size.height * 0.035),

                        // ==================================================
                        // BOOK NOW
                        // ==================================================

                        SizedBox(
                          width: double.infinity,
                          height: size.height * 0.065,
                          child: ElevatedButton(
                            onPressed: availability
                                ? () {
                                    _selectService(context: context
                                    , technicianId: widget.technician.id,
                                     technicianName: widget.technician.name, 
                                     technicianProfession: profession,
                                      services: services);
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF12A66A),
                              disabledBackgroundColor:
                                  Colors.grey.shade300,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Book Now',
                              style: TextStyle(
                                fontSize: size.width * 0.040,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: size.height * 0.04),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ================================================================
  // TAB ITEM
  // ================================================================

  Widget _tabItem({
    required String title,
    required bool isSelected,
    required Size size,
  }) {
    return Container(
      padding: EdgeInsets.only(
        bottom: size.height * 0.012,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isSelected
                ? const Color(0xFF12A66A)
                : Colors.transparent,
            width: 3,
          ),
        ),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: size.width * 0.037,
          fontWeight:
              isSelected ? FontWeight.w600 : FontWeight.w500,
          color: isSelected
              ? const Color(0xFF12A66A)
              : Colors.grey.shade600,
        ),
      ),
    );
  }

  // ================================================================
  // ERROR SCREEN
  // ================================================================

  Widget _errorScreen(String message) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF172033),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Text(
          message,
          style: const TextStyle(
            color: Color(0xFF172033),
          ),
        ),
      ),
    );
  }

  // ================================================================
  // DEFAULT PROFILE IMAGE
  // ================================================================

  Widget _defaultProfileImage(double screenWidth) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFEAF7F1),
      child: Icon(
        Icons.person,
        size: screenWidth * 0.25,
        color: const Color(0xFF12A66A),
      ),
    );
  }
}

// ====================================

// INFORMATION ROW
// ==================================================================

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Row(
      children: [
        Container(
          width: size.width * 0.11,
          height: size.width * 0.11,
          decoration: const BoxDecoration(
            color: Color(0xFFEAF7F1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: size.width * 0.055,
            color: const Color(0xFF12A66A),
          ),
        ),

        SizedBox(width: size.width * 0.035),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: size.width * 0.031,
                  color: Colors.grey.shade600,
                ),
              ),

              SizedBox(height: size.height * 0.003),

              Text(
                value,
                style: TextStyle(
                  fontSize: size.width * 0.037,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF172033),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}