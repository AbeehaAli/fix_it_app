import 'package:final_project/features/firebase/data/services/technician_profile_service.dart';
import 'package:flutter/material.dart';

class TechnicianBankDetailsScreen extends StatefulWidget {
  const TechnicianBankDetailsScreen({super.key});

  @override
  State<TechnicianBankDetailsScreen> createState() =>
      _TechnicianBankDetailsScreenState();
}

class _TechnicianBankDetailsScreenState
    extends State<TechnicianBankDetailsScreen> {
  final accountTitleController = TextEditingController();
  final accountNumberController = TextEditingController();
  final bankNameController = TextEditingController();
  final ibanController = TextEditingController();

  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    loadBankDetails();
  }

  @override
  void dispose() {
    accountTitleController.dispose();
    accountNumberController.dispose();
    bankNameController.dispose();
    ibanController.dispose();
    super.dispose();
  }

  // =========================================================
  // LOAD BANK DETAILS
  // =========================================================

  Future<void> loadBankDetails() async {
    try {
      final profile =
          await TechnicianProfileService
              .getCurrentTechnicianProfile();

      if (!mounted) return;

      if (profile != null && profile.exists) {
        final data = profile.data();

        if (data != null) {
          final bankDetails = data['bankDetails'];

          if (bankDetails is Map) {
            accountTitleController.text =
                bankDetails['accountTitle']?.toString() ?? '';

            accountNumberController.text =
                bankDetails['accountNumber']?.toString() ?? '';

            bankNameController.text =
                bankDetails['bankName']?.toString() ?? '';

            ibanController.text =
                bankDetails['iban']?.toString() ?? '';
          }
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to load bank details.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // =========================================================
  // SAVE BANK DETAILS
  // =========================================================

  Future<void> saveBankDetails() async {
    if (accountTitleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter the account title.',
          ),
        ),
      );
      return;
    }

    if (accountNumberController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter the account number.',
          ),
        ),
      );
      return;
    }

    if (bankNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter the bank name.',
          ),
        ),
      );
      return;
    }

    if (ibanController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter the IBAN.',
          ),
        ),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await TechnicianProfileService.updateBankDetails(
        bankDetails: {
          'accountTitle':
              accountTitleController.text.trim(),
          'accountNumber':
              accountNumberController.text.trim(),
          'bankName':
              bankNameController.text.trim(),
          'iban':
              ibanController.text.trim(),
        },
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Bank details updated successfully.',
          ),
          backgroundColor: Color(0xFF10B981),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to update bank details. Please try again.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // =========================================================
  // FIELD DECORATION
  // =========================================================

  InputDecoration fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 13,
        color: Color(0xFF94A3B8),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(
          color: Color(0xFFE2E8F0),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(
          color: Color(0xFFE2E8F0),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(
          color: Color(0xFF10B981),
        ),
      ),
    );
  }

  // =========================================================
  // FIELD
  // =========================================================

  Widget buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334E68),
          ),
        ),

        const SizedBox(height: 7),

        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: TextInputAction.next,
          decoration: fieldDecoration(hint),
        ),
      ],
    );
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 19,
            color: Color(0xFF102A43),
          ),
        ),
        title: const Text(
          'Bank Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF102A43),
          ),
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF10B981),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20,
                5,
                20,
                25,
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Payment Information',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF102A43),
                          ),
                        ),

                        const SizedBox(height: 5),

                        const Text(
                          'Add your bank account details for receiving payments.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),

                        const SizedBox(height: 20),

                        buildField(
                          label: 'Account Title',
                          hint: 'Enter account title',
                          controller:
                              accountTitleController,
                        ),

                        const SizedBox(height: 15),

                        buildField(
                          label: 'Account Number',
                          hint: 'Enter account number',
                          controller:
                              accountNumberController,
                          keyboardType:
                              TextInputType.number,
                        ),

                        const SizedBox(height: 15),

                        buildField(
                          label: 'Bank Name',
                          hint: 'Enter bank name',
                          controller:
                              bankNameController,
                        ),

                        const SizedBox(height: 15),

                        buildField(
                          label: 'IBAN',
                          hint: 'Enter IBAN',
                          controller: ibanController,
                          keyboardType:
                              TextInputType.text,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed:
                          isSaving
                              ? null
                              : saveBankDetails,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF10B981),
                        disabledBackgroundColor:
                            const Color(0xFF94A3B8),
                        elevation: 0,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(11),
                        ),
                      ),
                      child: isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Save Bank Details',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight:
                                    FontWeight.bold,
                                color: Colors.white,
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