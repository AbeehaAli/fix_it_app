import 'package:final_project/features/firebase/data/services/technician_profile_service.dart';
import 'package:final_project/features/technician/presentation/pages/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'technician_jobs_screen.dart';
import 'technician_earnings_screen.dart';
import 'technician_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/features/firebase/data/services/service_request_service.dart';
import 'technician_job_request_detail_screen.dart';

class TechnicianHomeScreen extends StatefulWidget {
  const TechnicianHomeScreen({super.key});

  @override
  State<TechnicianHomeScreen> createState() =>
      _TechnicianHomeScreenState();
}

class _TechnicianHomeScreenState extends State<TechnicianHomeScreen> {
  int currentIndex = 0;

  bool isOnline = true;
  bool isLoading = true;

  String technicianName = 'Technician';

  @override
  void initState() {
    super.initState();
    loadTechnicianData();
  }

  // =========================================================
  // LOAD TECHNICIAN DATA
  // =========================================================

  Future<void> loadTechnicianData() async {
    try {
      final profile =
          await TechnicianProfileService
              .getCurrentTechnicianProfile();

      if (!mounted) return;

      if (profile != null && profile.exists) {
        final data = profile.data();

        if (data != null) {
          final name =
              data['name']?.toString().trim() ?? '';

          final availability =
              data['availability'] as bool? ?? true;

          setState(() {
            if (name.isNotEmpty) {
              technicianName = name.split(' ').first;
            }

            isOnline = availability;
            isLoading = false;
          });

          return;
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  // =========================================================
  // CHANGE AVAILABILITY
  // =========================================================

  Future<void> changeAvailability(bool value) async {
    setState(() {
      isOnline = value;
    });

    try {
      await TechnicianProfileService.updateAvailability(value);
    } catch (e) {
      if (!mounted) return;

      // If Firestore update fails,
      // restore the previous state.
      setState(() {
        isOnline = !value;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to update availability. Please try again.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // =========================================================
  // BOTTOM NAVIGATION
  // =========================================================

  void changeTab(int index) {
    if (index == currentIndex) return;

    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const TechnicianJobsScreen(),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, $technicianName 👋',
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF102A43),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'You are ',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),

                  // Online Switch
                  Switch(
                    value: isOnline,
                    activeColor: const Color(0xFF10B981),
                    onChanged:
                        isLoading ? null : changeAvailability,
                  ),
                ],
              ),

              const SizedBox(height: 3),

              Text(
                isOnline ? 'Online' : 'Offline',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isOnline
                      ? const Color(0xFF10B981)
                      : const Color(0xFF64748B),
                ),
              ),

              const SizedBox(height: 20),

              // Statistics
              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      value: '0',
                      title: 'New Requests',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statCard(
                      value: '0',
                      title: 'Total Jobs',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 27),

               // New Requests
StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
  stream:
      ServiceRequestService.technicianRequestsStream(),
  builder: (context, snapshot) {
    // Firestore error
    if (snapshot.hasError) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          'Unable to load requests.\n${snapshot.error}',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.red,
          ),
        ),
      );
    }

    // Loading
    if (snapshot.connectionState ==
        ConnectionState.waiting) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF10B981),
          ),
        ),
      );
    }

    // Get only pending requests
    final requests = snapshot.data?.docs
            .where(
              (doc) =>
                  doc.data()['status'] == 'pending',
            )
            .toList() ??
        [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Heading
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'New Requests',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF102A43),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const TechnicianJobsScreen(),
                  ),
                );
              },
              child: const Text(
                'See All',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF10B981),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // No requests
        if (requests.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 30,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  height: 58,
                  width: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius:
                        BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.assignment_outlined,
                    size: 29,
                    color: Color(0xFF10B981),
                  ),
                ),

                const SizedBox(height: 14),

                const Text(
                  'No new requests',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF102A43),
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Customer requests will appear here when someone sends you a job.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.5,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),

        // Request exists
        if (requests.isNotEmpty)
          ...requests.take(3).map(
            (request) {
              final data = request.data();

              final customerName =
                  data['customerName']
                          ?.toString()
                          .trim()
                          .isNotEmpty ==
                      true
                  ? data['customerName']
                      .toString()
                  : 'Customer';

              final service =
                  data['service']
                          ?.toString()
                          .trim()
                          .isNotEmpty ==
                      true
                  ? data['service'].toString()
                  : 'Service request';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TechnicianJobRequestDetailsScreen(
                        requestId: request.id,
                        requestData: data,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  padding:
                      const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(16),
                    border: Border.all(
                      color:
                          const Color(0xFFE2E8F0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.04),
                        blurRadius: 12,
                        offset:
                            const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration:
                            BoxDecoration(
                          color:
                              const Color(
                            0xFFECFDF5,
                          ),
                          borderRadius:
                              BorderRadius.circular(
                            15,
                          ),
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          color:
                              Color(0xFF10B981),
                          size: 27,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              customerName,
                              style:
                                  const TextStyle(
                                fontSize: 15,
                                fontWeight:
                                    FontWeight.bold,
                                color: Color(
                                  0xFF102A43,
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 5,
                            ),

                            Text(
                              service,
                              style:
                                  const TextStyle(
                                fontSize: 12,
                                color: Color(
                                  0xFF64748B,
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 7,
                            ),

                            Container(
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 9,
                                vertical: 4,
                              ),
                              decoration:
                                  BoxDecoration(
                                color:
                                    const Color(
                                  0xFFECFDF5,
                                ),
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  20,
                                ),
                              ),
                              child:
                                  const Text(
                                'Pending',
                                style:
                                    TextStyle(
                                  fontSize: 10,
                                  fontWeight:
                                      FontWeight.bold,
                                  color: Color(
                                    0xFF10B981,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Icon(
                        Icons
                            .arrow_forward_ios,
                        size: 15,
                        color:
                            Color(0xFF94A3B8),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  },
),

const SizedBox(height: 20),

              // Info card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Color(0xFF10B981),
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Stay online to receive new job requests from customers.',
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.5,
                          color: Color(0xFF334E68),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: TechnicianBottomNavBar(
        currentIndex: currentIndex,
        onTap: changeTab,
      ),
    );
  }

  Widget _statCard({
    required String value,
    required String title,
  }) {
    return Container(
      height: 86,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F6FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF102A43),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}