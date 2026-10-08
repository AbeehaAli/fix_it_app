import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/features/firebase/data/services/service_request_service.dart';
import 'package:flutter/material.dart';
import 'package:final_project/features/firebase/data/services/rating_service.dart';
import 'customer_rate_technician.dart';

class CustomerJobsScreen extends StatefulWidget {
  const CustomerJobsScreen({super.key});

  @override
  State<CustomerJobsScreen> createState() =>
      _CustomerJobsScreenState();
}

class _CustomerJobsScreenState extends State<CustomerJobsScreen> {
  bool showActive = true;

  Future<void> _openRatingScreen({
  required String requestId,
  required String technicianId,
  required String technicianName,
  required String service,
  required dynamic rating,
}) async {
  if (technicianId.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Technician information is missing.',
        ),
      ),
    );

    return;
  }

  if (rating != null) {
    final ratingValue =
        (rating as num).toDouble();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'You already rated this technician '
          '${ratingValue.toStringAsFixed(0)}/5.',
        ),
      ),
    );

    return;
  }

  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          CustomerRateTechnicianScreen(
        requestId: requestId,
        technicianId: technicianId,
        technicianName: technicianName,
        service: service,
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: screenHeight * 0.04,
            ),

            Text(
              'My Jobs',
              style: TextStyle(
                fontSize: screenWidth * 0.065,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF172033),
              ),
            ),

            SizedBox(
              height: screenHeight * 0.008,
            ),

            Text(
              'Track your service requests',
              style: TextStyle(
                fontSize: screenWidth * 0.038,
                color: Colors.grey.shade600,
              ),
            ),

            SizedBox(
              height: screenHeight * 0.035,
            ),

            // ==================================================
            // TABS
            // ==================================================

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showActive = true;
                      });
                    },
                    child: Container(
                      height: screenHeight * 0.055,
                      decoration: BoxDecoration(
                        color: showActive
                            ? const Color(0xFFEAF7F1)
                            : const Color(0xFFF1F3F5),
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Active',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w600,
                            color: showActive
                                ? const Color(0xFF12A66A)
                                : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  width: screenWidth * 0.025,
                ),

                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showActive = false;
                      });
                    },
                    child: Container(
                      height: screenHeight * 0.055,
                      decoration: BoxDecoration(
                        color: !showActive
                            ? const Color(0xFFEAF7F1)
                            : const Color(0xFFF1F3F5),
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Completed',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w500,
                            color: !showActive
                                ? const Color(0xFF12A66A)
                                : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: screenHeight * 0.05,
            ),

            // ==================================================
            // CUSTOMER JOBS
            // ==================================================

            Expanded(
              child: StreamBuilder<
                  QuerySnapshot<Map<String, dynamic>>>(
                stream: ServiceRequestService
                    .customerRequestsStream(),
                builder: (context, snapshot) {
                  // Firestore error
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Unable to load jobs.\n${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.034,
                          color: Colors.red,
                        ),
                      ),
                    );
                  }

                  // Loading
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF12A66A),
                      ),
                    );
                  }

                  final documents =
                      snapshot.data?.docs ?? [];

                  // ==================================================
                  // FILTER JOBS
                  // ==================================================

                  final jobs = documents.where((doc) {
                    final status =
                        doc.data()['status']
                            ?.toString()
                            .toLowerCase();

                    if (showActive) {
                      return status == 'pending' ||
                          status == 'accepted' ||
                          status == 'in_progress';
                    }

                    return status == 'completed';
                  }).toList();

                  // ==================================================
                  // EMPTY STATE
                  // ==================================================

                  if (jobs.isEmpty) {
                    return Center(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.04,
                          horizontal: screenWidth * 0.06,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(18),
                          border: Border.all(
                            color:
                                const Color(0xFFE5EAF0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.07),
                              blurRadius: 12,
                              spreadRadius: 1,
                              offset:
                                  const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: screenWidth * 0.18,
                              height: screenWidth * 0.18,
                              decoration:
                                  const BoxDecoration(
                                color:
                                    Color(0xFFEAF7F1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons
                                    .calendar_today_outlined,
                                size:
                                    screenWidth * 0.09,
                                color: const Color(
                                  0xFF12A66A,
                                ),
                              ),
                            ),

                            SizedBox(
                              height:
                                  screenHeight * 0.018,
                            ),

                            Text(
                              showActive
                                  ? 'No jobs yet'
                                  : 'No completed jobs yet',
                              textAlign:
                                  TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    screenWidth * 0.045,
                                fontWeight:
                                    FontWeight.w600,
                                color: const Color(
                                  0xFF172033,
                                ),
                              ),
                            ),

                            SizedBox(
                              height:
                                  screenHeight * 0.008,
                            ),

                            Text(
                              showActive
                                  ? 'Your service requests will appear here.'
                                  : 'Your completed service requests will appear here.',
                              textAlign:
                                  TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    screenWidth * 0.034,
                                color:
                                    Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // ==================================================
                  // JOB LIST
                  // ==================================================

                  return ListView.builder(
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      final job = jobs[index];
                      final data = job.data();

                      final technicianName =
                          data['technicianName']
                                  ?.toString()
                                  .trim()
                                  .isNotEmpty ==
                              true
                          ? data['technicianName']
                              .toString()
                          : 'Technician';

                      final service =
                          data['service']
                                  ?.toString()
                                  .trim()
                                  .isNotEmpty ==
                              true
                          ? data['service'].toString()
                          : 'Service';

                      final status =
                          data['status']
                              ?.toString()
                              .toLowerCase() ??
                          'pending';

                      String statusText;

                      if (status == 'pending') {
                        statusText = 'Pending';
                      } else if (status == 'accepted') {
                        statusText = 'Accepted';
                      } else if (status == 'in_progress') {
                        statusText = 'In Progress';
                      } else {
                        statusText = 'Completed';
                      }

                      return GestureDetector(
  onTap: status == 'completed'
      ? () {
          _openRatingScreen(
            requestId: job.id,
            technicianId:
                data['technicianId']?.toString() ?? '',
            technicianName: technicianName,
            service: service,
            rating: data['rating'],
          );
        }
      : null,
  child: Container(
    width: double.infinity,
    margin:
        const EdgeInsets.only(
      bottom: 14,
    ),
                        padding:
                            const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(16),
                          border: Border.all(
                            color:
                                const Color(0xFFE5EAF0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.05),
                              blurRadius: 10,
                              offset:
                                  const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration:
                                  BoxDecoration(
                                color: const Color(
                                  0xFFEAF7F1,
                                ),
                                borderRadius:
                                    BorderRadius
                                        .circular(14),
                              ),
                              child: const Icon(
                                Icons
                                    .handyman_outlined,
                                color: Color(
                                  0xFF12A66A,
                                ),
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
                                    technicianName,
                                    style:
                                        const TextStyle(
                                      fontSize: 15,
                                      fontWeight:
                                          FontWeight.bold,
                                      color: Color(
                                        0xFF172033,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 5,
                                  ),

                                  Text(
                                    service,
                                    style:
                                        TextStyle(
                                      fontSize: 12,
                                      color: Colors
                                          .grey
                                          .shade600,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 8,
                                  ),

                                  Container(
                                    padding:
                                        const EdgeInsets
                                            .symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration:
                                        BoxDecoration(
                                      color:
                                          const Color(
                                        0xFFEAF7F1,
                                      ),
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        20,
                                      ),
                                    ),
                                    child: Text(
                                      statusText,
                                      style:
                                          const TextStyle(
                                        fontSize: 10,
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                        color: Color(
                                          0xFF12A66A,
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}