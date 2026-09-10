import 'package:flutter/material.dart';

class CustomerBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomerBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.085,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE9EDF2),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(
            context: context,
            icon: Icons.home_rounded,
            label: 'Home',
            index: 0,
          ),

          _navItem(
            context: context,
            icon: Icons.calendar_today_outlined,
            label: 'My Jobs',
            index: 1,
          ),

          _navItem(
            context: context,
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Messages',
            index: 2,
            showNotification: true,
          ),

          _navItem(
            context: context,
            icon: Icons.person_outline_rounded,
            label: 'Profile',
            index: 3,
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
    bool showNotification = false,
  }) {
    final size = MediaQuery.of(context).size;

    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: SizedBox(
        width: size.width * 0.20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: size.width * 0.065,
                  color: isSelected
                      ? const Color(0xFF12A66A)
                      : const Color(0xFF7D8999),
                ),

                if (showNotification)
                  Positioned(
                    right: -4,
                    top: -3,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 4),

            Text(
              label,
              style: TextStyle(
                fontSize: size.width * 0.028,
                fontWeight: isSelected
                    ? FontWeight.w600
                    : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF12A66A)
                    : const Color(0xFF7D8999),
              ),
            ),
          ],
        ),
      ),
    );
  }
}