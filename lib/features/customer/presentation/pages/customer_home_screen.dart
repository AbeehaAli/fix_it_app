import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/features/customer/presentation/pages/customer_jobs_screen.dart';
import 'package:final_project/features/customer/presentation/pages/customer_msgs_screen.dart';
import 'package:final_project/features/customer/presentation/pages/customer_profile_screen.dart';
import 'package:final_project/features/customer/presentation/pages/technician_list_screen.dart';
import 'package:final_project/features/customer/presentation/widget/customer_bottom_nav_bar.dart';
import 'package:final_project/features/firebase/data/services/technician_profile_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomerHome extends StatefulWidget {
  final String? customerName;

  const CustomerHome({
    super.key,
    this.customerName,
  });

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  int currentIndex = 0;

  String get customerFirstName {
    final firebaseName =
        FirebaseAuth.instance.currentUser?.displayName?.trim();

    String? name;

    if (firebaseName != null && firebaseName.isNotEmpty) {
      name = firebaseName;
    } else if (widget.customerName != null &&
        widget.customerName!.trim().isNotEmpty) {
      name = widget.customerName!.trim();
    }

    if (name == null || name.isEmpty) {
      return 'Customer';
    }

    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: currentIndex,
        children: [
          _buildHomePage(context),
          const CustomerJobsScreen(),
          const CustomerMessagesScreen(),
          const CustomerProfileScreen(),
        ],
      ),
      bottomNavigationBar: CustomerBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildHomePage(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    final horizontalPadding = screenWidth * 0.05;
    final topPadding = screenHeight * 0.055;
    final greetingFontSize = screenWidth * 0.064;
    final subtitleFontSize = screenWidth * 0.038;
    final sectionTitleSize = screenWidth * 0.047;
    final technicianTitleSize = screenWidth * 0.043;
    final searchHeight = screenHeight * 0.068;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: horizontalPadding,
          right: horizontalPadding,
          top: topPadding,
          bottom: screenHeight * 0.025,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================
            // GREETING
            // ==================================================

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, $customerFirstName 👋',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: greetingFontSize,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF172033),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.007,
                      ),
                      Text(
                        'What do you need today?',
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {},
                  icon: Icon(
                    Icons.search_rounded,
                    size: screenWidth * 0.075,
                    color: const Color(0xFF172033),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: screenHeight * 0.025,
            ),

            // ==================================================
            // SEARCH
            // ==================================================

            Container(
              width: double.infinity,
              height: searchHeight,
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F6F9),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: Colors.grey.shade600,
                    size: screenWidth * 0.06,
                  ),
                  SizedBox(
                    width: screenWidth * 0.03,
                  ),
                  Text(
                    'Search for services...',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: screenWidth * 0.038,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: screenHeight * 0.035,
            ),

            // ==================================================
            // SERVICES
            // ==================================================

            Text(
              'Services',
              style: TextStyle(
                fontSize: sectionTitleSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF172033),
              ),
            ),

            SizedBox(
              height: screenHeight * 0.018,
            ),

            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: screenWidth * 0.035,
              mainAxisSpacing: screenHeight * 0.022,
              childAspectRatio: 0.95,
              children: const [
                ServiceItem(
                  icon: Icons.bolt_rounded,
                  title: 'Plumber',
                  iconColor: Color(0xFF1877F2),
                  backgroundColor: Color(0xFFEAF3FF),
                ),
                ServiceItem(
                  icon: Icons.electric_bolt_rounded,
                  title: 'Electrician',
                  iconColor: Color(0xFFFFA726),
                  backgroundColor: Color(0xFFFFF3DE),
                ),
                ServiceItem(
                  icon: Icons.ac_unit_rounded,
                  title: 'AC Service',
                  iconColor: Color(0xFF1596A8),
                  backgroundColor: Color(0xFFE6F8F6),
                ),
                ServiceItem(
                  icon: Icons.format_paint_rounded,
                  title: 'Painter',
                  iconColor: Color(0xFFE53935),
                  backgroundColor: Color(0xFFFFE9EA),
                ),
                ServiceItem(
                  icon: Icons.handyman_rounded,
                  title: 'Carpenter',
                  iconColor: Color(0xFFFFA726),
                  backgroundColor: Color(0xFFFFF3DE),
                ),
                ServiceItem(
                  icon: Icons.cleaning_services_rounded,
                  title: 'Cleaning',
                  iconColor: Color(0xFF159447),
                  backgroundColor: Color(0xFFE7F8EE),
                ),
              ],
            ),

            SizedBox(
              height: screenHeight * 0.035,
            ),

            // ==================================================
            // RECOMMENDED TECHNICIANS
            // ==================================================

            Row(
              children: [
                Expanded(
                  child: Text(
                    'Available Technicians',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: technicianTitleSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF172033),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.02,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const TechnicianListScreen(
                          serviceName: 'Technicians',
                        ),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'See All',
                    style: TextStyle(
                      fontSize: screenWidth * 0.032,
                      color: const Color(0xFF12A66A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: screenHeight * 0.012,
            ),

            // ==================================================
            // AVAILABLE TECHNICIANS FROM FIRESTORE
            // ==================================================

            StreamBuilder<
                QuerySnapshot<Map<String, dynamic>>>(
              stream:
                  TechnicianProfileService
                      .availableTechnicianStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Container(
                    width: double.infinity,
                    height: 190,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFFE5EAF0),
                      ),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF12A66A),
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return _buildTechnicianErrorState(
                    screenWidth,
                    screenHeight,
                  );
                }

                final technicians =
                    snapshot.data?.docs ?? [];

                if (technicians.isEmpty) {
                  return _buildEmptyTechnicianState(
                    screenWidth,
                    screenHeight,
                  );
                }

                return SizedBox(
                  height: 205,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: technicians.length,
                    itemBuilder: (context, index) {
                      final document =
                          technicians[index];

                      final data = document.data();

                      return _buildTechnicianCard(
                        data,
                        screenWidth,
                        screenHeight,
                      );
                    },
                  ),
                );
              },
            ),

            SizedBox(
              height: screenHeight * 0.025,
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // TECHNICIAN CARD
  // ==========================================================

  Widget _buildTechnicianCard(
    Map<String, dynamic> data,
    double screenWidth,
    double screenHeight,
  ) {
    final name =
        data['name']?.toString().trim().isNotEmpty == true
            ? data['name'].toString().trim()
            : 'Technician';

    final profession =
        data['profession']?.toString().trim().isNotEmpty == true
            ? data['profession'].toString().trim()
            : 'Technician';

    final ratingValue = data['rating'];

    double rating = 0;

    if (ratingValue is num) {
      rating = ratingValue.toDouble();
    }

    final imageBase64 =
        data['profileImageBase64']?.toString() ?? '';

    final imageUrl =
        data['profileImageUrl']?.toString() ?? '';

    return Container(
      width: screenWidth * 0.72,
      margin: EdgeInsets.only(
        right: screenWidth * 0.035,
      ),
      padding: EdgeInsets.all(
        screenWidth * 0.035,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE5EAF0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ====================================================
          // PROFILE IMAGE
          // ====================================================

          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: _buildTechnicianImage(
              imageBase64,
              imageUrl,
              screenWidth,
            ),
          ),

          SizedBox(
            width: screenWidth * 0.035,
          ),

          // ====================================================
          // TECHNICIAN INFORMATION
          // ====================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: screenWidth * 0.041,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF172033),
                  ),
                ),

                SizedBox(
                  height: screenHeight * 0.006,
                ),

                Text(
                  profession,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: screenWidth * 0.033,
                    color: Colors.grey.shade600,
                  ),
                ),

                SizedBox(
                  height: screenHeight * 0.009,
                ),

                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: screenWidth * 0.045,
                      color: const Color(0xFFFFA000),
                    ),

                    SizedBox(
                      width: screenWidth * 0.01,
                    ),

                    Text(
                      rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: screenWidth * 0.032,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF172033),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: screenHeight * 0.009,
                ),

                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF12A66A),
                        shape: BoxShape.circle,
                      ),
                    ),

                    SizedBox(
                      width: screenWidth * 0.012,
                    ),

                    Text(
                      'Available',
                      style: TextStyle(
                        fontSize: screenWidth * 0.031,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF12A66A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // TECHNICIAN IMAGE
  // ==========================================================

  Widget _buildTechnicianImage(
    String imageBase64,
    String imageUrl,
    double screenWidth,
  ) {
    final imageSize = screenWidth * 0.20;

    if (imageBase64.isNotEmpty) {
      try {
        return Image.memory(
          base64Decode(imageBase64),
          width: imageSize,
          height: imageSize,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) {
            return _defaultTechnicianImage(
              imageSize,
            );
          },
        );
      } catch (e) {
        return _defaultTechnicianImage(
          imageSize,
        );
      }
    }

    if (imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        width: imageSize,
        height: imageSize,
        fit: BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) {
          return _defaultTechnicianImage(
            imageSize,
          );
        },
      );
    }

    return _defaultTechnicianImage(
      imageSize,
    );
  }

  Widget _defaultTechnicianImage(
    double size,
  ) {
    return Container(
      width: size,
      height: size,
      color: const Color(0xFFEAF7F1),
      child: Icon(
        Icons.person,
        size: size * 0.50,
        color: const Color(0xFF12A66A),
      ),
    );
  }

  // ==========================================================
  // EMPTY STATE
  // ==========================================================

  Widget _buildEmptyTechnicianState(
    double screenWidth,
    double screenHeight,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.035,
        horizontal: screenWidth * 0.05,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE5EAF0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: screenWidth * 0.16,
            height: screenWidth * 0.16,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF7F1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.engineering_outlined,
              size: screenWidth * 0.11,
              color: Colors.grey,
            ),
          ),

          SizedBox(
            height: screenHeight * 0.012,
          ),

          Text(
            'No technicians available yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF172033),
            ),
          ),

          SizedBox(
            height: screenHeight * 0.006,
          ),

          Text(
            'Technicians who are currently available will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenWidth * 0.032,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // ERROR STATE
  // ==========================================================

  Widget _buildTechnicianErrorState(
    double screenWidth,
    double screenHeight,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.035,
        horizontal: screenWidth * 0.05,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE5EAF0),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: screenWidth * 0.12,
            color: Colors.grey,
          ),
          SizedBox(
            height: screenHeight * 0.012,
          ),
          Text(
            'Unable to load technicians',
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF172033),
            ),
          ),
          SizedBox(
            height: screenHeight * 0.006,
          ),
          Text(
            'Please check your connection and try again.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenWidth * 0.032,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// SERVICE ITEM
// ================================================================

class ServiceItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final Color backgroundColor;

  const ServiceItem({
    super.key,
    required this.icon,
    required this.title,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(context).size.width;

    final screenHeight =
        MediaQuery.of(context).size.height;

    final iconContainerSize =
        screenWidth * 0.16;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return TechnicianListScreen(
                serviceName: title,
              );
            },
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: iconContainerSize,
            height: iconContainerSize,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius:
                  BorderRadius.circular(
                screenWidth * 0.045,
              ),
            ),
            child: Icon(
              icon,
              size: screenWidth * 0.075,
              color: iconColor,
            ),
          ),

          SizedBox(
            height: screenHeight * 0.009,
          ),

          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: screenWidth * 0.033,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF172033),
            ),
          ),
        ],
      ),
    );
  }
}