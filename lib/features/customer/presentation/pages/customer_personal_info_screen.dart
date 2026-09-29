import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomerPersonalInformationScreen extends StatefulWidget {
  const CustomerPersonalInformationScreen({
    super.key,
  });

  @override
  State<CustomerPersonalInformationScreen> createState() =>
      _CustomerPersonalInformationScreenState();
}

class _CustomerPersonalInformationScreenState
    extends State<CustomerPersonalInformationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  bool _isLoading = true;
  bool _isSaving = false;

  String _email = '';

  // ============================================================
  // CUSTOMER FIRESTORE DOCUMENT
  // ============================================================

  DocumentReference<Map<String, dynamic>> get _customerDocument {
    final uid = _auth.currentUser!.uid;

    return _firestore.collection('customers').doc(uid);
  }

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _phoneController = TextEditingController();

    _loadCustomerInformation();
  }

  // ============================================================
  // LOAD CUSTOMER INFORMATION
  // ============================================================

  Future<void> _loadCustomerInformation() async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    try {
      final document = await _customerDocument.get();

      final data = document.data();

      _nameController.text =
          (data?['name'] ?? user.displayName ?? '').toString();

      _phoneController.text =
          (data?['phone'] ?? '').toString();

      _email = user.email ?? '';

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Unable to load your information: $e',
            ),
          ),
        );
      }
    }
  }

  // ============================================================
  // SAVE CUSTOMER INFORMATION
  // ============================================================

  Future<void> _saveCustomerInformation() async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    // ----------------------------------------------------------
    // NAME VALIDATION
    // ----------------------------------------------------------

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your full name'),
        ),
      );

      return;
    }

    // ----------------------------------------------------------
    // START SAVING
    // ----------------------------------------------------------

    setState(() {
      _isSaving = true;
    });

    try {
      // --------------------------------------------------------
      // UPDATE FIREBASE AUTH DISPLAY NAME
      // --------------------------------------------------------

      await user.updateDisplayName(name);

      // --------------------------------------------------------
      // SAVE CUSTOMER DATA TO FIRESTORE
      // --------------------------------------------------------

      await _customerDocument.set(
        {
          'name': name,
          'email': user.email ?? '',
          'phone': phone,
        },
        SetOptions(merge: true),
      );

      // --------------------------------------------------------
      // REFRESH AUTH USER
      // --------------------------------------------------------

      await user.reload();

      if (!mounted) return;

      // --------------------------------------------------------
      // GO BACK TO PROFILE
      // --------------------------------------------------------

      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Unable to update profile: $e',
            ),
          ),
        );
      }
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF172033),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          'Personal Information',
          style: TextStyle(
            fontSize: size.width * 0.05,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF172033),
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF12A66A),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: size.height * 0.025,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // PROFILE ICON
                  // ==================================================

                  Center(
                    child: Container(
                      width: size.width * 0.25,
                      height: size.width * 0.25,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEAF7F1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        size: size.width * 0.13,
                        color: const Color(0xFF12A66A),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: size.height * 0.035,
                  ),

                  // ==================================================
                  // FULL NAME
                  // ==================================================

                  Text(
                    'Full Name',
                    style: TextStyle(
                      fontSize: size.width * 0.035,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF172033),
                    ),
                  ),

                  SizedBox(
                    height: size.height * 0.01,
                  ),

                  TextField(
                    controller: _nameController,
                    textCapitalization:
                        TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText: 'Enter your full name',
                      prefixIcon: const Icon(
                        Icons.person_outline_rounded,
                        color: Color(0xFF12A66A),
                      ),
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
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: size.height * 0.025,
                  ),

                  // ==================================================
                  // PHONE
                  // ==================================================

                  Text(
                    'Phone Number',
                    style: TextStyle(
                      fontSize: size.width * 0.035,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF172033),
                    ),
                  ),

                  SizedBox(
                    height: size.height * 0.01,
                  ),

                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Enter your phone number',
                      prefixIcon: const Icon(
                        Icons.phone_outlined,
                        color: Color(0xFF12A66A),
                      ),
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
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: size.height * 0.025,
                  ),

                  // ==================================================
                  // EMAIL
                  // ==================================================

                  Text(
                    'Email',
                    style: TextStyle(
                      fontSize: size.width * 0.035,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF172033),
                    ),
                  ),

                  SizedBox(
                    height: size.height * 0.01,
                  ),

                  TextField(
                    enabled: false,
                    controller: TextEditingController(
                      text: _email,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: Color(0xFF12A66A),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF5F6F7),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Color(0xFFE5EAF0),
                        ),
                      ),
                      disabledBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Color(0xFFE5EAF0),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: size.height * 0.04,
                  ),

                  // ==================================================
                  // SAVE BUTTON
                  // ==================================================

                  SizedBox(
                    width: double.infinity,
                    height: size.height * 0.065,
                    child: ElevatedButton(
                      onPressed: _isSaving
                          ? null
                          : _saveCustomerInformation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF12A66A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2.5,
                                  color: Colors.white,
                                  ),
                          ) :Text('Save Changes',
                          style: TextStyle(
                            fontSize: size.width *0.038,
                            fontWeight: FontWeight.w600,
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