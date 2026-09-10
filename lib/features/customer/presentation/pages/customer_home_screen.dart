import 'package:final_project/features/customer/presentation/widget/customer_bottom_nav_bar.dart';
import 'package:flutter/material.dart';


class CustomerHome extends StatefulWidget {
  // Customer name will come dynamically from signup/login
  final String customerName;

  const CustomerHome({
    super.key,
    required this.customerName,
  });

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // =====================================================
              // GREETING
              // =====================================================

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, ${widget.customerName} 👋',
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF172033),
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        'What do you need today?',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  IconButton(
                    onPressed: () {
                      // Search functionality will be added later
                    },
                    icon: const Icon(
                      Icons.search_rounded,
                      size: 30,
                      color: Color(0xFF172033),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // =====================================================
              // SEARCH BAR
              // =====================================================

              Container(
                height: 55,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F6F9),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search_rounded,
                      color: Colors.grey.shade600,
                      size: 23,
                    ),

                    const SizedBox(width: 12),

                    Text(
                      'Search for services...',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // =====================================================
              // SERVICES
              // =====================================================

              const Text(
                'Services',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172033),
                ),
              ),

              const SizedBox(height: 16),

              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 14,
                mainAxisSpacing: 18,
                childAspectRatio: 0.95,
                children: const [

                  ServiceItem(
                    icon: Icons.bolt_rounded,
                    title: 'Plumber',
                    iconColor: Color(0xFF1877F2),
                    backgroundColor: Color(0xFFEAF3FF),
                  ),

                  ServiceItem(
                    icon: Icons.electric_bolt_rounded,
                    title: 'Electrician',
                    iconColor: Color(0xFFFFA726),
                    backgroundColor: Color(0xFFFFF3DE),
                  ),

                  ServiceItem(
                    icon: Icons.ac_unit_rounded,
                    title: 'AC Service',
                    iconColor: Color(0xFF1596A8),
                    backgroundColor: Color(0xFFE6F8F6),
                  ),

                  ServiceItem(
                    icon: Icons.format_paint_rounded,
                    title: 'Painter',
                    iconColor: Color(0xFFE53935),
                    backgroundColor: Color(0xFFFFE9EA),
                  ),

                  ServiceItem(
                    icon: Icons.handyman_rounded,
                    title: 'Carpenter',
                    iconColor: Color(0xFFFFA726),
                    backgroundColor: Color(0xFFFFF3DE),
                  ),

                  ServiceItem(
                    icon: Icons.cleaning_services_rounded,
                    title: 'Cleaning',
                    iconColor: Color(0xFF159447),
                    backgroundColor: Color(0xFFE7F8EE),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // =====================================================
              // RECOMMENDED TECHNICIANS
              // =====================================================

              Row(
                crossAxisAlignment: .center,
                children: [
                  const Text(
                    'Recommended Technicians',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF172033),
                    ),
                  ),
                  
                  SizedBox(width: 40,),
                  TextButton(
                    onPressed: () {
                      // Separate technician page will be added later
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF12A66A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // =====================================================
              // EMPTY TECHNICIAN LIST
              // =====================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFE5EAF0),
                  ),
                  boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          spreadRadius: 1,
                          offset: const Offset(0, 5),
                        ),
                  ]
                ),
                child: Column(
                  mainAxisAlignment: .center,
                  children: [
                    Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF7F1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.engineering_outlined,
                        size: 45,
                        color: Colors.grey.shade400,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'No technicians available yet',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF172033),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      'Recommended technicians will appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      // ==========================================================
      // BOTTOM NAVIGATION BAR
      // ==========================================================

      bottomNavigationBar: CustomerBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}


// ================================================================
// SERVICE ITEM WIDGET
// ================================================================

class ServiceItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final Color backgroundColor;

  const ServiceItem({
    super.key,
    required this.icon,
    required this.title,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Service page will be connected later
      },
      child: Column(
        children: [

          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              icon,
              size: 32,
              color: iconColor,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF172033),
            ),
          ),
        ],
      ),
    );
  }
}