import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:final_project/features/firebase/data/services/rating_service.dart';

class CustomerRateTechnicianScreen extends StatefulWidget {
  final String requestId;
  final String technicianId;
  final String technicianName;
  final String service;

  const CustomerRateTechnicianScreen({
    super.key,
    required this.requestId,
    required this.technicianId,
    required this.technicianName,
    required this.service,
  });

  @override
  State<CustomerRateTechnicianScreen> createState() =>
      _CustomerRateTechnicianScreenState();
}

class _CustomerRateTechnicianScreenState
    extends State<CustomerRateTechnicianScreen> {
  int selectedRating = 0;

  final TextEditingController _reviewController =
      TextEditingController();

  bool isSubmitting = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  // =========================================================
  // SUBMIT
  // =========================================================

  Future<void> _submitRating() async {
    if (selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a rating.'),
        ),
      );

      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      await RatingService.submitRating(
        requestId: widget.requestId,
        technicianId: widget.technicianId,
        rating: selectedRating,
        review: _reviewController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Thank you! Your review has been submitted.',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
              'Exception: ',
              '',
            ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  // =========================================================
  // STAR
  // =========================================================

  Widget _buildStar(int star) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRating = star;
        });
      },
      child: Icon(
        star <= selectedRating
            ? Icons.star
            : Icons.star_border,
        size: 43,
        color: const Color(0xFFFFB800),
      ),
    );
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          'Rate Technician',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: screenHeight * 0.04,
          ),
          child: Column(
            children: [
              // =================================================
              // ICON
              // =================================================

              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF7F1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.handyman_outlined,
                  size: 45,
                  color: Color(0xFF12A66A),
                ),
              ),

              SizedBox(
                height: screenHeight * 0.025,
              ),

              Text(
                widget.technicianName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF172033),
                ),
              ),

              const SizedBox(height: 6),

              Text(
                widget.service,
                style: TextStyle(
                  fontSize: screenWidth * 0.038,
                  color: Colors.grey.shade600,
                ),
              ),

              SizedBox(
                height: screenHeight * 0.045,
              ),

              const Text(
                'How was your experience?',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF172033),
                ),
              ),

              const SizedBox(height: 20),

              // =================================================
              // STARS
              // =================================================

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStar(1),
                  const SizedBox(width: 7),
                  _buildStar(2),
                  const SizedBox(width: 7),
                  _buildStar(3),
                  const SizedBox(width: 7),
                  _buildStar(4),
                  const SizedBox(width: 7),
                  _buildStar(5),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                selectedRating == 0
                    ? 'Tap a star to rate'
                    : '$selectedRating out of 5',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),

              SizedBox(
                height: screenHeight * 0.04,
              ),

              // =================================================
              // REVIEW
              // =================================================

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Write a review (optional)',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF172033),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: _reviewController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Share your experience...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFFE5EAF0),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFFE5EAF0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFF12A66A),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: screenHeight * 0.035,
              ),

              // =================================================
              // SUBMIT BUTTON
              // =================================================

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed:
                      isSubmitting ? null : _submitRating,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child:
                              CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Submit Review',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}