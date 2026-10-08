import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/features/firebase/data/services/service_request_service.dart';
import 'package:flutter/material.dart';

class TechnicianJobRequestDetailsScreen extends StatefulWidget {
  final String requestId;
  final Map<String, dynamic> requestData;

  const TechnicianJobRequestDetailsScreen({
    super.key,
    required this.requestId,
    required this.requestData,
  });

  @override
  State<TechnicianJobRequestDetailsScreen> createState() =>
      _TechnicianJobRequestDetailsScreenState();
}

class _TechnicianJobRequestDetailsScreenState
    extends State<TechnicianJobRequestDetailsScreen> {
  bool isProcessing = false;

  // ==========================================================
  // ACCEPT
  // ==========================================================

  Future<void> acceptRequest() async {
    setState(() {
      isProcessing = true;
    });

    try {
      await ServiceRequestService.acceptRequest(
        widget.requestId,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Request accepted successfully.',
          ),
          backgroundColor: Color(0xFF10B981),
        ),
      );

      Navigator.pop(context);
    } on FirebaseException catch (e) {
      if (!mounted) return;

      setState(() {
        isProcessing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to accept request: ${e.message ?? e.code}',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isProcessing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to accept request: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ==========================================================
  // REJECT
  // ==========================================================

  Future<void> rejectRequest() async {
    setState(() {
      isProcessing = true;
    });

    try {
      await ServiceRequestService.rejectRequest(
        widget.requestId,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Request rejected.',
          ),
          backgroundColor: Colors.red,
        ),
      );

      Navigator.pop(context);
    } on FirebaseException catch (e) {
      if (!mounted) return;

      setState(() {
        isProcessing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to reject request: ${e.message ?? e.code}',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isProcessing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to reject request: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.requestData;

    final customerName =
        data['customerName']?.toString().trim().isNotEmpty == true
            ? data['customerName'].toString()
            : 'Customer';

    final service =
        data['service']?.toString().trim().isNotEmpty == true
            ? data['service'].toString()
            : 'Service not specified';

    final date =
        data['date']?.toString().trim().isNotEmpty == true
            ? data['date'].toString()
            : 'Not available';

    final time =
        data['time']?.toString().trim().isNotEmpty == true
            ? data['time'].toString()
            : 'Not available';

    final address =
        data['address']?.toString().trim().isNotEmpty == true
            ? data['address'].toString()
            : 'Not available';

    final problemDetails =
        data['problemDetails']?.toString().trim().isNotEmpty == true
            ? data['problemDetails'].toString()
            : 'No problem details provided.';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: IconButton(
          onPressed: isProcessing
              ? null
              : () {
                  Navigator.pop(context);
                },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 19,
            color: Color(0xFF102A43),
          ),
        ),

        title: const Text(
          'Job Request',
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
          10,
          20,
          25,
        ),

        child: Column(
          children: [

            // ==================================================
            // CUSTOMER
            // ==================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),

              decoration: _cardDecoration(),

              child: Row(
                children: [

                  CircleAvatar(
                    radius: 28,
                    backgroundColor:
                        const Color(0xFFE2E8F0),

                    child: const Icon(
                      Icons.person,
                      size: 30,
                      color: Color(0xFF64748B),
                    ),
                  ),

                  const SizedBox(width: 13),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        Text(
                          customerName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF102A43),
                          ),
                        ),

                        const SizedBox(height: 5),

                        const Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 15,
                              color: Color(0xFF64748B),
                            ),

                            SizedBox(width: 3),

                            Text(
                              'Customer request',
                              style: TextStyle(
                                fontSize: 11,
                                color:
                                    Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ==================================================
            // REQUEST DETAILS
            // ==================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(17),

              decoration: _cardDecoration(),

              child: Column(
                children: [

                  _detailRow(
                    Icons.home_repair_service_outlined,
                    'Service',
                    service,
                  ),

                  _divider(),

                  _detailRow(
                    Icons.calendar_today_outlined,
                    'Date & Time',
                    '$date${time != 'Not available' ? ' • $time' : ''}',
                  ),

                  _divider(),

                  _detailRow(
                    Icons.location_on_outlined,
                    'Address',
                    address,
                  ),

                  _divider(),

                  _detailRow(
                    Icons.description_outlined,
                    'Problem Details',
                    problemDetails,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // ACCEPT / REJECT
            // ==================================================

            Row(
              children: [

                Expanded(
                  child: OutlinedButton(
                    onPressed: isProcessing
                        ? null
                        : rejectRequest,

                    style: OutlinedButton.styleFrom(
                      minimumSize:
                          const Size(0, 49),

                      side: const BorderSide(
                        color: Color(0xFFFFB4B4),
                      ),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),

                    child: isProcessing
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.red,
                            ),
                          )
                        : const Text(
                            'Reject',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  Color(0xFFE53935),
                            ),
                          ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: isProcessing
                        ? null
                        : acceptRequest,

                    style:
                        ElevatedButton.styleFrom(
                      minimumSize:
                          const Size(0, 49),

                      backgroundColor:
                          const Color(0xFF10B981),

                      disabledBackgroundColor:
                          Colors.grey.shade300,

                      elevation: 0,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),

                    child: isProcessing
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Accept',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight:
                                  FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // CARD DECORATION
  // ==========================================================

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
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

          blurRadius: 10,

          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  // ==========================================================
  // DETAIL ROW
  // ==========================================================

  Widget _detailRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Icon(
          icon,
          size: 21,
          color: const Color(0xFF102A43),
        ),

        const SizedBox(width: 13),

        SizedBox(
          width: 90,

          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
        ),

        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF334E68),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // DIVIDER
  // ==========================================================

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(
        vertical: 15,
      ),

      child: Divider(
        height: 1,
        color: Color(0xFFF1F5F9),
      ),
    );
  }
}