
import 'package:final_project/features/customer/domain/technician_data.dart';
import 'package:flutter/material.dart';

class TechnicianDetailsScreen extends StatelessWidget {
  final Technician technician;

  const TechnicianDetailsScreen({
    super.key,
    required this.technician,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ==================================================
              // TECHNICIAN IMAGE
              // ==================================================

              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: screenHeight * 0.30,
                    child: technician.imageUrl.isEmpty
                        ? Container(
                            color: const Color(0xFFEAF7F1),
                            child: Icon(
                              Icons.person,
                              size: screenWidth * 0.25,
                              color:
                                  const Color(0xFF12A66A),
                            ),
                          )
                        : Image.network(
                            technician.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) {
                              return Container(
                                color:
                                    const Color(0xFFEAF7F1),
                                child: Icon(
                                  Icons.person,
                                  size:
                                      screenWidth * 0.25,
                                  color:
                                      const Color(0xFF12A66A),
                                ),
                              );
                            },
                          ),
                  ),

                  // ------------------------------------------------
                  // BACK BUTTON
                  // ------------------------------------------------

                  Positioned(
                    top: screenHeight * 0.018,
                    left: screenWidth * 0.04,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: screenWidth * 0.11,
                        height: screenWidth * 0.11,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(0.10),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: screenWidth * 0.045,
                          color:
                              const Color(0xFF172033),
                        ),
                      ),
                    ),
                  ),

                  // ------------------------------------------------
                  // FAVORITE BUTTON
                  // ------------------------------------------------

                  Positioned(
                    top: screenHeight * 0.018,
                    right: screenWidth * 0.04,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: screenWidth * 0.11,
                        height: screenWidth * 0.11,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(0.10),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.favorite_border_rounded,
                          size: screenWidth * 0.055,
                          color:
                              const Color(0xFF172033),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // ==================================================
              // MAIN INFORMATION
              // ==================================================

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    SizedBox(
                      height: screenHeight * 0.022,
                    ),

                    // ------------------------------------------------
                    // NAME
                    // ------------------------------------------------

                    Text(
                      technician.name,
                      style: TextStyle(
                        fontSize: screenWidth * 0.065,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF172033),
                      ),
                    ),

                    SizedBox(
                      height: screenHeight * 0.006,
                    ),

                    // ------------------------------------------------
                    // SERVICE
                    // ------------------------------------------------

                    Text(
                      'Professional ${technician.service}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.040,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    SizedBox(
                      height: screenHeight * 0.018,
                    ),

                    // ------------------------------------------------
                    // RATING + DISTANCE
                    // ------------------------------------------------

                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: screenWidth * 0.055,
                          color: const Color(0xFFFFA000),
                        ),

                        SizedBox(
                          width: screenWidth * 0.012,
                        ),

                        Text(
                          '${technician.rating}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.038,
                            fontWeight: FontWeight.bold,
                            color:
                                const Color(0xFF172033),
                          ),
                        ),

                        SizedBox(
                          width: screenWidth * 0.008,
                        ),

                        Text(
                          '(${technician.reviews} reviews)',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color:
                                Colors.grey.shade600,
                          ),
                        ),

                        SizedBox(
                          width: screenWidth * 0.04,
                        ),

                        Icon(
                          Icons.location_on_outlined,
                          size: screenWidth * 0.05,
                          color:
                              const Color(0xFF12A66A),
                        ),

                        SizedBox(
                          width: screenWidth * 0.008,
                        ),

                        Text(
                          technician.distance,
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color:
                                Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: screenHeight * 0.025,
                    ),

                    // =================================================
                    // TABS
                    // =================================================

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(
                              bottom: screenHeight * 0.012,
                            ),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color:
                                      Color(0xFF12A66A),
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Text(
                              'About',
                              textAlign:
                                  TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    screenWidth * 0.037,
                                fontWeight:
                                    FontWeight.w600,
                                color:
                                    const Color(0xFF12A66A),
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          child: Padding(
                            padding:
                                EdgeInsets.only(
                              bottom:
                                  screenHeight * 0.012,
                            ),
                            child: Text(
                              'Reviews',
                              textAlign:
                                  TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    screenWidth * 0.037,
                                fontWeight:
                                    FontWeight.w500,
                                color:
                                    Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          child: Padding(
                            padding:
                                EdgeInsets.only(
                              bottom:
                                  screenHeight * 0.012,
                            ),
                            child: Text(
                              'Gallery',
                              textAlign:
                                  TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    screenWidth * 0.037,
                                fontWeight:
                                    FontWeight.w500,
                                color:
                                    Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: screenHeight * 0.025,
                    ),

                    // =================================================
                    // ABOUT
                    // =================================================

                    Text(
                      'About',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF172033),
                      ),
                    ),

                    SizedBox(
                      height: screenHeight * 0.01,
                    ),

                    Text(
                      technician.about,
                      style: TextStyle(
                        fontSize: screenWidth * 0.036,
                        height: 1.5,
                        color: Colors.grey.shade700,
                      ),
                    ),

                    SizedBox(
                      height: screenHeight * 0.025,
                    ),

                    // =================================================
                    // EXPERIENCE
                    // =================================================

                    _InfoRow(
                      icon: Icons.workspace_premium_outlined,
                      title: 'Experience',
                      value: technician.experience,
                    ),

                    SizedBox(
                      height: screenHeight * 0.015,
                    ),

                    // =================================================
                    // PRICE
                    // =================================================

                    _InfoRow(
                      icon: Icons.payments_outlined,
                      title: 'Service Rate',
                      value: technician.price,
                    ),

                    SizedBox(
                      height: screenHeight * 0.015,
                    ),

                    // =================================================
                    // AVAILABILITY
                    // =================================================

                    _InfoRow(
                      icon: Icons.access_time_rounded,
                      title: 'Availability',
                      value: technician.availableToday
                          ? 'Available Today'
                          : 'Currently Unavailable',
                    ),

                    SizedBox(
                      height: screenHeight * 0.035,
                    ),

                    // =================================================
                    // BOOK NOW
                    // =================================================

                    SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.065,
                      child: ElevatedButton(
                        onPressed:
                            technician.availableToday
                                ? () {}
                                : null,
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF12A66A),
                          disabledBackgroundColor:
                              Colors.grey.shade300,
                          elevation: 0,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Book Now',
                          style: TextStyle(
                            fontSize:
                                screenWidth * 0.040,
                            fontWeight:
                                FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: screenHeight * 0.04,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =================================================================
// INFORMATION ROW
// =================================================================

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
    final mediaQuery = MediaQuery.of(context);

    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Row(
      children: [
        Container(
          width: screenWidth * 0.11,
          height: screenWidth * 0.11,
          decoration: const BoxDecoration(
            color: Color(0xFFEAF7F1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: screenWidth * 0.055,
            color: const Color(0xFF12A66A),
          ),
        ),

        SizedBox(
          width: screenWidth * 0.035,
        ),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: screenWidth * 0.031,
                  color: Colors.grey.shade600,
                ),
              ),

              SizedBox(
                height: screenHeight * 0.003,
              ),

              Text(
                value,
                style: TextStyle(
                  fontSize: screenWidth * 0.037,
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