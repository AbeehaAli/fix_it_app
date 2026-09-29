import 'package:flutter/material.dart';

class TechnicianBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const TechnicianBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem(
            icon: Icons.home_rounded,
            label: 'Home',
            index: 0,
          ),
          _buildItem(
            icon: Icons.calendar_month_outlined,
            label: 'Jobs',
            index: 1,
          ),
          _buildItem(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Earnings',
            index: 2,
          ),
          _buildItem(
            icon: Icons.person_outline,
            label: 'Profile',
            index: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool selected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 23,
              color: selected
                  ? const Color(0xFF10B981)
                  : const Color(0xFF64748B),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight:
                    selected ? FontWeight.bold : FontWeight.w500,
                color: selected
                    ? const Color(0xFF10B981)
                    : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}