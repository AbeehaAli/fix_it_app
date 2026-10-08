import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/features/customer/domain/technician_data.dart';
import 'package:final_project/features/customer/presentation/pages/technician_detail_screen.dart';
import 'package:final_project/features/firebase/data/services/technician_profile_service.dart';
import 'package:flutter/material.dart';

class TechnicianListScreen extends StatelessWidget {
  final String serviceName;

  // Kept so your existing navigation code does not break.
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
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F6F8),
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
            // FIRESTORE TECHNICIANS
            // ==================================================

            Expanded(
              child: StreamBuilder<
                  QuerySnapshot<Map<String, dynamic>>>(
                stream: TechnicianProfileService
                    .availableTechnicianStream(),
                builder: (context, snapshot) {
                  // ------------------------------------------------
                  // LOADING
                  // ------------------------------------------------

                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF12A66A),
                      ),
                    );
                  }

                  // ------------------------------------------------
                  // ERROR
                  // ------------------------------------------------

                  if (snapshot.hasError) {
                    return _buildErrorState(
                      context,
                      screenWidth,
                      screenHeight,
                    );
                  }

                  final documents =
                      snapshot.data?.docs ?? [];

                  // ------------------------------------------------
                  // FILTER TECHNICIANS
                  // ------------------------------------------------

                  final filteredDocuments =
                      documents.where((document) {
                    final data = document.data();

                    // "Technicians" means show all available
                    // technicians.
                    if (serviceName.toLowerCase() ==
                        'technicians') {
                      return true;
                    }

                    // For a specific service such as Plumber,
                    // Electrician, Painter, etc., check the
                    // technician's services list.
                    final services =
                        data['services'];

                    if (services is List) {
                      return services.any((service) {
                        return service
                            .toString()
                            .toLowerCase()
                            .trim() ==
                            serviceName
                                .toLowerCase()
                                .trim();
                      });
                    }

                    // Also check profession in case the
                    // technician has not selected a services list.
                    final profession =
                        data['profession']
                            ?.toString()
                            .toLowerCase()
                            .trim();

                    return profession ==
                        serviceName
                            .toLowerCase()
                            .trim();
                  }).toList();

                  // ------------------------------------------------
                  // EMPTY
                  // ------------------------------------------------

                  if (filteredDocuments.isEmpty) {
                    return _buildEmptyState(
                      context,
                      screenWidth,
                      screenHeight,
                    );
                  }

                  // ------------------------------------------------
                  // LIST
                  // ------------------------------------------------

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.01,
                    ),
                    itemCount:
                        filteredDocuments.length,
                    itemBuilder: (context, index) {
                      final document =
                          filteredDocuments[index];

                      final data =
                          document.data();

                      return _buildTechnicianCard(
                        context,
                        document.id,
                        data,
                        screenWidth,
                        screenHeight,
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

  // ============================================================
  // TECHNICIAN CARD
  // ============================================================

  Widget _buildTechnicianCard(
    BuildContext context,
    String technicianId,
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

    // ----------------------------------------------------------
    // RATING
    // ----------------------------------------------------------

    double rating = 0;

    final ratingValue = data['rating'];

    if (ratingValue is num) {
      rating = ratingValue.toDouble();
    }

    // ----------------------------------------------------------
    // PROFILE IMAGE
    // ----------------------------------------------------------

    final imageBase64 =
        data['profileImageBase64']?.toString() ?? '';

    final imageUrl =
        data['profileImageUrl']?.toString() ?? '';

    // ----------------------------------------------------------
    // TECHNICIAN MODEL
    //
    // This keeps compatibility with your existing
    // TechnicianDetailsScreen.
    // ----------------------------------------------------------

    final technician = Technician(
      id: technicianId,
      name: name,
      service: profession,
      imageUrl: imageUrl,
      rating: rating,
      reviews: 0,
      distance: 'Near you',
      price: 'Contact for price',
      experience: 'Professional technician',
      about:
          'Available technician for your service needs.',
      availableToday: true,
    );

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
            // ==================================================
            // PROFILE IMAGE
            // ==================================================

            ClipRRect(
              borderRadius: BorderRadius.circular(
                screenWidth * 0.035,
              ),
              child: _buildProfileImage(
                imageBase64,
                imageUrl,
                screenWidth,
              ),
            ),

            SizedBox(
              width: screenWidth * 0.035,
            ),

            // ==================================================
            // INFORMATION
            // ==================================================

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // ------------------------------------------------
                  // NAME
                  // ------------------------------------------------

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize:
                                screenWidth * 0.041,
                            fontWeight:
                                FontWeight.bold,
                            color:
                                const Color(0xFF172033),
                          ),
                        ),
                      ),

                      Icon(
                        Icons.favorite_border_rounded,
                        size: screenWidth * 0.06,
                        color: Colors.grey.shade500,
                      ),
                    ],
                  ),

                  SizedBox(
                    height: screenHeight * 0.006,
                  ),

                  // ------------------------------------------------
                  // PROFESSION
                  // ------------------------------------------------

                  Text(
                    profession,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: screenWidth * 0.034,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  SizedBox(
                    height: screenHeight * 0.008,
                  ),

                  // ------------------------------------------------
                  // RATING
                  // ------------------------------------------------

                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: screenWidth * 0.045,
                        color:
                            const Color(0xFFFFA000),
                      ),

                      SizedBox(
                        width: screenWidth * 0.01,
                      ),

                      Text(
                        rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize:
                              screenWidth * 0.033,
                          fontWeight:
                              FontWeight.w600,
                          color:
                              const Color(0xFF172033),
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
                        'Near you',
                        style: TextStyle(
                          fontSize:
                              screenWidth * 0.031,
                          color:
                              Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: screenHeight * 0.008,
                  ),

                  // ------------------------------------------------
                  // AVAILABLE
                  // ------------------------------------------------

                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration:
                            const BoxDecoration(
                          color:
                              Color(0xFF12A66A),
                          shape:
                              BoxShape.circle,
                        ),
                      ),

                      SizedBox(
                        width: screenWidth * 0.012,
                      ),

                      Text(
                        'Available',
                        style: TextStyle(
                          fontSize:
                              screenWidth * 0.031,
                          fontWeight:
                              FontWeight.w600,
                          color:
                              const Color(0xFF12A66A),
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
    );
  }

  // ============================================================
  // PROFILE IMAGE
  // ============================================================

  Widget _buildProfileImage(
    String imageBase64,
    String imageUrl,
    double screenWidth,
  ) {
    final size = screenWidth * 0.20;

    // ----------------------------------------------------------
    // BASE64 IMAGE
    // ----------------------------------------------------------

    if (imageBase64.isNotEmpty) {
      try {
        return Image.memory(
          base64Decode(imageBase64),
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) {
            return _defaultProfileImage(size);
          },
        );
      } catch (e) {
        return _defaultProfileImage(size);
      }
    }

    // ----------------------------------------------------------
    // NETWORK IMAGE
    // ----------------------------------------------------------

    if (imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) {
          return _defaultProfileImage(size);
        },
      );
    }

    // ----------------------------------------------------------
    // DEFAULT
    // ----------------------------------------------------------

    return _defaultProfileImage(size);
  }

  // ============================================================
  // DEFAULT PROFILE IMAGE
  // ============================================================

  Widget _defaultProfileImage(double size) {
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
                color:
                    Colors.black.withOpacity(0.07),
                blurRadius: 15,
                spreadRadius: 1,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
  // ERROR STATE
  // ============================================================

  Widget _buildErrorState(
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
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: screenWidth * 0.15,
                color: Colors.grey,
              ),

              SizedBox(
                height: screenHeight * 0.015,
              ),

              Text(
                'Unable to load technicians',
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

              Text(
                'Please check your connection and try again.',
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
    );
  }
}