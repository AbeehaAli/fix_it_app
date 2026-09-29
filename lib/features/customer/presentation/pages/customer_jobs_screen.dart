import 'package:flutter/material.dart';

class CustomerJobsScreen extends StatefulWidget {
  const CustomerJobsScreen({super.key});

  @override
  State<CustomerJobsScreen> createState() =>
      _CustomerJobsScreenState();
}

class _CustomerJobsScreenState extends State<CustomerJobsScreen> {
  bool showActive = true;

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

            Expanded(
              child: Center(
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
                      color: const Color(0xFFE5EAF0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withOpacity(0.07),
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: const Offset(0, 5),
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
                          color: Color(0xFFEAF7F1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.calendar_today_outlined,
                          size: screenWidth * 0.09,
                          color:
                              const Color(0xFF12A66A),
                        ),
                      ),

                      SizedBox(
                        height: screenHeight * 0.018,
                      ),

                      Text(
                        showActive
                            ? 'No jobs yet'
                            : 'No completed jobs yet',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w600,
                          color:
                              const Color(0xFF172033),
                        ),
                      ),

                      SizedBox(
                        height: screenHeight * 0.008,
                      ),

                      Text(
                        showActive
                            ? 'Your service requests will appear here.'
                            : 'Your completed service requests will appear here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.034,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}