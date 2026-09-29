import 'package:final_project/features/technician/presentation/pages/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

import 'technician_home_screen.dart';
import 'technician_earnings_screen.dart';
import 'technician_profile_screen.dart';


class TechnicianJobsScreen extends StatefulWidget {
  const TechnicianJobsScreen({super.key});

  @override
  State<TechnicianJobsScreen> createState() =>
      _TechnicianJobsScreenState();
}

class _TechnicianJobsScreenState extends State<TechnicianJobsScreen> {
  int currentIndex = 1;
  int selectedTab = 0;

  final List<String> tabs = [
    'Upcoming',
    'In Progress',
    'Completed',
  ];

  void changeBottomTab(int index) {
    if (index == currentIndex) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const TechnicianHomeScreen(),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const TechnicianEarningsScreen(),
        ),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const TechnicianProfileScreen(),
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
        centerTitle: true,
        title: const Text(
          'My Jobs',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF102A43),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(18, 5, 18, 10),
        child: Column(
          children: [
            // Tabs
            Container(
              height: 45,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF4F8),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: List.generate(
                  tabs.length,
                  (index) {
                    final selected = selectedTab == index;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = index;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFF10B981)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Text(
                            tabs[index],
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: selected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: selected
                                  ? Colors.white
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 18),

            Expanded(
              child: _buildJobContent(),
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

  Widget _buildJobContent() {
  switch (selectedTab) {
    case 0:
      return _buildEmptyJobState(
        icon: Icons.work_outline,
        title: 'No jobs available',
        description:
            'Your customer jobs will appear here once you receive and accept requests.',
        bottomText: 'Upcoming jobs',
        bottomColor: const Color(0xFF10B981),
      );

    case 1:
      return _buildEmptyJobState(
        icon: Icons.pending_actions_outlined,
        title: 'No jobs in progress',
        description:
            'Jobs that you have started will appear here.',
        bottomText: 'No job is currently in progress',
        bottomColor: const Color(0xFF64748B),
      );

    case 2:
      return _buildEmptyJobState(
        icon: Icons.check_circle_outline,
        title: 'No completed jobs',
        description:
            'Your completed customer jobs will appear here.',
        bottomText: 'No completed jobs yet',
        bottomColor: const Color(0xFF64748B),
      );

    default:
      return const SizedBox();
  }
}

Widget _buildEmptyJobState({
  required IconData icon,
  required String title,
  required String description,
  required String bottomText,
  required Color bottomColor,
}) {
  return Center(
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 35,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 65,
            width: 65,
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              size: 32,
              color: const Color(0xFF10B981),
            ),
          ),

          const SizedBox(height: 15),

          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF102A43),
            ),
          ),

          const SizedBox(height: 7),

          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              height: 1.5,
              color: Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            bottomText,
            style: TextStyle(
              fontSize: 11,
              color: bottomColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}
}