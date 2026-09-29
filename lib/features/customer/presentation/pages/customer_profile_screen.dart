import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/features/customer/presentation/pages/customer_addresses_screen.dart';
import 'package:final_project/features/customer/presentation/pages/customer_personal_info_screen.dart';
import 'package:final_project/features/customer/presentation/pages/customer_settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({
    super.key,
  });

  @override
  State<CustomerProfileScreen> createState() =>
      _CustomerProfileScreenState();
}

class _CustomerProfileScreenState
    extends State<CustomerProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  bool _isLoading = true;

  String _fullName = 'Customer';
  String _email = '';

  // ============================================================
  // CUSTOMER DOCUMENT
  // ============================================================

  DocumentReference<Map<String, dynamic>>
      get _customerDocument {
    final uid = _auth.currentUser?.uid;

    return _firestore
        .collection('customers')
        .doc(uid);
  }

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _loadCustomerProfile();
  }

  // ============================================================
  // LOAD PROFILE
  // ============================================================

  Future<void> _loadCustomerProfile() async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    try {
      final document =
          await _customerDocument.get();

      final data = document.data();

      final firestoreName =
          data?['name']?.toString().trim();

      final authName =
          user.displayName?.trim();

      String name = 'Customer';

      if (firestoreName != null &&
          firestoreName.isNotEmpty) {
        name = firestoreName;
      } else if (authName != null &&
          authName.isNotEmpty) {
        name = authName;
      }

      if (mounted) {
        setState(() {
          _fullName = name;
          _email = user.email ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _fullName =
              user.displayName?.trim().isNotEmpty == true
                  ? user.displayName!.trim()
                  : 'Customer';

          _email = user.email ?? '';

          _isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // OPEN PERSONAL INFORMATION
  // ============================================================

  Future<void> _openPersonalInformation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const CustomerPersonalInformationScreen(),
      ),
    );

    // ----------------------------------------------------------
    // IMPORTANT:
    // If customer saved information, reload profile.
    // ----------------------------------------------------------

    if (result == true && mounted) {
      setState(() {
        _isLoading = true;
      });

      await _loadCustomerProfile();
    }
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> _logout() async {
    await _auth.signOut();

    if (!mounted) return;

    context.go('/customer-Login');
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // ==================================================
            // TOP SPACE
            // ==================================================

            SizedBox(
              height: size.height * 0.04,
            ),

            // ==================================================
            // PROFILE TITLE
            // ==================================================

            Text(
              'Profile',
              style: TextStyle(
                fontSize: size.width * 0.065,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF172033),
              ),
            ),

            SizedBox(
              height: size.height * 0.03,
            ),

            // ==================================================
            // PROFILE HEADER
            // ==================================================

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(
                size.width * 0.05,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(18),
                border: Border.all(
                  color:
                      const Color(0xFFE5EAF0),
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.black.withOpacity(0.07),
                    blurRadius: 12,
                    spreadRadius: 1,
                    offset:
                        const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // ==================================================
                  // PROFILE ICON
                  // ==================================================

                  Container(
                    width: size.width * 0.17,
                    height: size.width * 0.17,
                    decoration:
                        const BoxDecoration(
                      color:
                          Color(0xFFEAF7F1),
                      shape:
                          BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      size:
                          size.width * 0.09,
                      color:
                          const Color(0xFF12A66A),
                    ),
                  ),

                  SizedBox(
                    width:
                        size.width * 0.04,
                  ),

                  // ==================================================
                  // NAME + EMAIL
                  // ==================================================

                  Expanded(
                    child: _isLoading
                        ? const SizedBox(
                            height: 40,
                            child: Center(
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                                color:
                                    Color(0xFF12A66A),
                              ),
                            ),
                          )
                        : Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                _fullName,
                                maxLines: 2,
                                overflow:
                                    TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize:
                                      size.width *
                                          0.045,
                                  fontWeight:
                                      FontWeight.bold,
                                  color:
                                      const Color(
                                    0xFF172033,
                                  ),
                                ),
                              ),

                              SizedBox(
                                height:
                                    size.height *
                                        0.006,
                              ),

                              Text(
                                _email,
                                maxLines: 2,
                                overflow:
                                    TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize:
                                      size.width *
                                          0.032,
                                  color:
                                      Colors.grey
                                          .shade600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: size.height * 0.025,
            ),

            // ==================================================
            // PERSONAL INFORMATION
            // ==================================================

            _ProfileOption(
              icon:
                  Icons.person_outline_rounded,
              title:
                  'Personal Information',
              onTap:
                  _openPersonalInformation,
            ),

            // ==================================================
            // MY ADDRESSES
            // ==================================================

            _ProfileOption(
              icon:
                  Icons.location_on_outlined,
              title:
                  'My Addresses',
              onTap: () {
                Navigator.push(context, 
                MaterialPageRoute(builder: (context) => const CustomerAddressesScreen())
                );
              },
            ),

           

            // ==================================================
            // SETTINGS
            // ==================================================

            _ProfileOption(
              icon:
                  Icons.settings_outlined,
              title:
                  'Settings',
              onTap: () {
                Navigator.push(context, 
                MaterialPageRoute(builder: (context) => CustomerSettingsScreen(),));
              },
            ),

           

            // ==================================================
            // LOGOUT
            // ==================================================

            GestureDetector(
              onTap: _logout,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical:
                      size.height * 0.018,
                  horizontal:
                      size.width * 0.04,
                ),
                decoration: BoxDecoration(
                  color:
                      const Color(0xFFFFF1F1),
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      size:
                          size.width * 0.06,
                      color: Colors.red,
                    ),

                    SizedBox(
                      width:
                          size.width * 0.035,
                    ),

                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize:
                            size.width * 0.038,
                        fontWeight:
                            FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: size.height * 0.04,
            ),
          ],
        ),
      ),
    );
  }
}

// =================================================================
// PROFILE OPTION
// =================================================================

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(
          bottom: size.height * 0.012,
        ),
        padding: EdgeInsets.symmetric(
          vertical: size.height * 0.018,
          horizontal: size.width * 0.04,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFE5EAF0),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: size.width * 0.06,
              color: const Color(0xFF12A66A),
            ),

            SizedBox(
              width: size.width * 0.035,
            ),

            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: size.width * 0.038,
                  fontWeight: FontWeight.w500,
                  color:
                      const Color(0xFF172033),
                ),
              ),
            ),

            Icon(
              Icons.arrow_forward_ios_rounded,
              size: size.width * 0.035,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}