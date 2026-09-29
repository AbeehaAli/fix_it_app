import 'package:flutter/material.dart';

class TechnicianJobInProgressScreen extends StatelessWidget {
  const TechnicianJobInProgressScreen({super.key});

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
          'Job In Progress',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF102A43),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
        child: Column(
          children: [
            // Customer header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: const Color(0xFFE2E8F0),
                    child: const Icon(
                      Icons.person,
                      size: 30,
                      color: Color(0xFF64748B),
                    ),
                  ),

                  const SizedBox(width: 13),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Customer',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF102A43),
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 15,
                              color: Color(0xFF64748B),
                            ),
                            SizedBox(width: 3),
                            Text(
                              'Location unavailable',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  _actionButton(
                    Icons.phone_outlined,
                  ),

                  const SizedBox(width: 8),

                  _actionButton(
                    Icons.chat_bubble_outline,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Job information
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(17),
              decoration: _cardDecoration(),
              child: Column(
                children: [
                  _infoRow(
                    Icons.person_outline,
                    'Service',
                    'Plumbing',
                  ),
                  _divider(),
                  _infoRow(
                    Icons.access_time,
                    'Start Time',
                    'Not started',
                  ),
                  _divider(),
                  _infoRow(
                    Icons.location_on_outlined,
                    'Address',
                    'Address will appear here',
                  ),

                  const SizedBox(height: 10),

                  // Navigate
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.navigation_outlined,
                        size: 19,
                      ),
                      label: const Text(
                        'Navigate',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor:
                            const Color(0xFF10B981),
                        side: const BorderSide(
                          color: Color(0xFFE2E8F0),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  _infoRow(
                    Icons.info_outline,
                    'Status',
                    'Work in progress',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Complete button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF10B981),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Mark as Completed',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: const Color(0xFFE2E8F0),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  Widget _actionButton(IconData icon) {
    return Container(
      height: 39,
      width: 39,
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 19,
        color: const Color(0xFF10B981),
      ),
    );
  }

  Widget _infoRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Divider(
        height: 1,
        color: Color(0xFFF1F5F9),
      ),
    );
  }
}