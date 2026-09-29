
import 'package:final_project/features/customer/domain/technician_data.dart';
import 'package:final_project/features/customer/presentation/pages/technician_detail_screen.dart';
import 'package:flutter/material.dart';



class TechnicianListScreen extends StatelessWidget {
  final String serviceName;
  final List<Technician> technicians;

  const TechnicianListScreen({
    super.key,
    required this.serviceName,
    this.technicians = const [],
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            // ==================================================
            // HEADER
            // ==================================================

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: screenWidth * 0.11,
                      height: screenWidth * 0.11,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F6F8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: screenWidth * 0.045,
                        color: const Color(0xFF172033),
                      ),
                    ),
                  ),

                  SizedBox(
                    width: screenWidth * 0.04,
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          serviceName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: screenWidth * 0.055,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF172033),
                          ),
                        ),

                        SizedBox(
                          height: screenHeight * 0.003,
                        ),

                        Text(
                          'Near you',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Sort button
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.tune_rounded,
                          size: screenWidth * 0.045,
                          color: const Color(0xFF172033),
                        ),

                        SizedBox(
                          width: screenWidth * 0.012,
                        ),

                        Text(
                          'Sort',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF172033),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ==================================================
            // TECHNICIAN LIST
            // ==================================================

            Expanded(
              child: technicians.isEmpty
                  ? _buildEmptyState(
                      context,
                      screenWidth,
                      screenHeight,
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenHeight * 0.01,
                      ),
                      itemCount: technicians.length,
                      itemBuilder: (context, index) {
                        final technician =
                            technicians[index];

                        return _buildTechnicianCard(
                          context,
                          technician,
                          screenWidth,
                          screenHeight,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState(
    BuildContext context,
    double screenWidth,
    double screenHeight,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.08,
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: screenHeight * 0.045,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              screenWidth * 0.05,
            ),
            border: Border.all(
              color: const Color(0xFFE5EAF0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 15,
                spreadRadius: 1,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: screenWidth * 0.20,
                height: screenWidth * 0.20,
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
                height: screenHeight * 0.02,
              ),

              // Title
              Text(
                'No $serviceName available',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF172033),
                ),
              ),

              SizedBox(
                height: screenHeight * 0.01,
              ),

              // Description
              Text(
                'There are no $serviceName technicians available right now. Please check again later.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.034,
                  height: 1.4,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TECHNICIAN CARD
  // ============================================================

  Widget _buildTechnicianCard(
    BuildContext context,
    Technician technician,
    double screenWidth,
    double screenHeight,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return TechnicianDetailsScreen(
                technician: technician,
              );
            },
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(
          bottom: screenHeight * 0.018,
        ),
        padding: EdgeInsets.all(
          screenWidth * 0.035,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            screenWidth * 0.045,
          ),
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
            // --------------------------------------------------
            // TECHNICIAN IMAGE
            // --------------------------------------------------

            ClipRRect(
              borderRadius: BorderRadius.circular(
                screenWidth * 0.035,
              ),
              child: technician.imageUrl.isEmpty
                  ? Container(
                      width: screenWidth * 0.20,
                      height: screenWidth * 0.20,
                      color: const Color(0xFFEAF7F1),
                      child: Icon(
                        Icons.person,
                        size: screenWidth * 0.10,
                        color: const Color(0xFF12A66A),
                      ),
                    )
                  : Image.network(
                      technician.imageUrl,
                      width: screenWidth * 0.20,
                      height: screenWidth * 0.20,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) {
                        return Container(
                          width: screenWidth * 0.20,
                          height: screenWidth * 0.20,
                          color: const Color(0xFFEAF7F1),
                          child: Icon(
                            Icons.person,
                            size: screenWidth * 0.10,
                            color:
                                const Color(0xFF12A66A),
                          ),
                        );
                      },
                    ),
            ),

            SizedBox(
              width: screenWidth * 0.035,
            ),

            // --------------------------------------------------
            // TECHNICIAN INFORMATION
            // --------------------------------------------------

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          technician.name,
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: screenWidth * 0.041,
                            fontWeight: FontWeight.bold,
                            color:
                                const Color(0xFF172033),
                          ),
                        ),
                      ),

                      Icon(
                        Icons.favorite_border_rounded,
                        size: screenWidth * 0.06,
                        color:
                            Colors.grey.shade500,
                      ),
                    ],
                  ),

                  SizedBox(
                    height: screenHeight * 0.008,
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
                        '${technician.rating}',
                        style: TextStyle(
                          fontSize: screenWidth * 0.033,
                          fontWeight: FontWeight.w600,
                          color:
                              const Color(0xFF172033),
                        ),
                      ),

                      Text(
                        ' (${technician.reviews})',
                        style: TextStyle(
                          fontSize: screenWidth * 0.031,
                          color:
                              Colors.grey.shade600,
                        ),
                      ),

                      SizedBox(
                        width: screenWidth * 0.025,
                      ),

                      Icon(
                        Icons.location_on_outlined,
                        size: screenWidth * 0.04,
                        color:
                            Colors.grey.shade500,
                      ),

                      SizedBox(
                        width: screenWidth * 0.005,
                      ),

                      Text(
                        technician.distance,
                        style: TextStyle(
                          fontSize: screenWidth * 0.031,
                          color:
                              Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: screenHeight * 0.008,
                  ),

                  Text(
                    technician.price,
                    style: TextStyle(
                      fontSize: screenWidth * 0.033,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF172033),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}