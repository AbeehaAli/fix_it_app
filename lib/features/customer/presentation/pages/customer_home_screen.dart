
import 'package:final_project/features/customer/presentation/pages/customer_jobs_screen.dart';
import 'package:final_project/features/customer/presentation/pages/customer_msgs_screen.dart';
import 'package:final_project/features/customer/presentation/pages/customer_profile_screen.dart';
import 'package:final_project/features/customer/presentation/pages/technician_list_screen.dart';
import 'package:final_project/features/customer/presentation/widget/customer_bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
                    'Recommended Technicians',
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
                  onPressed: () {},
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
            // EMPTY TECHNICIANS
            // ==================================================

            Container(
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
                mainAxisAlignment: MainAxisAlignment.center,
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
                    'Recommended technicians will appear here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.032,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: screenHeight * 0.025,
            ),
          ],
        ),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final iconContainerSize = screenWidth * 0.16;

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
              borderRadius: BorderRadius.circular(
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