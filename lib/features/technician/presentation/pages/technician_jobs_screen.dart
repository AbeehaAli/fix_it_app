import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/features/firebase/data/services/messages_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:final_project/features/firebase/data/services/service_request_service.dart';

import 'technician_home_screen.dart';
import 'technician_earnings_screen.dart';
import 'technician_profile_screen.dart';
import 'bottom_nav_bar.dart';

class TechnicianJobsScreen extends StatefulWidget {
  const TechnicianJobsScreen({super.key});

  @override
  State<TechnicianJobsScreen> createState() => _TechnicianJobsScreenState();
}

class _TechnicianJobsScreenState extends State<TechnicianJobsScreen> {
  int selectedTab = 0;
  int currentIndex = 1;

  final ServiceRequestService _serviceRequestService =
      ServiceRequestService();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            // ================= HEADER =================
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'My Jobs',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  // MESSAGE ICON
                  StreamBuilder<QuerySnapshot>(
                    stream: _getAcceptedJobsStream(),
                    builder: (context, snapshot) {
                      final hasMessages =
                          snapshot.hasData && snapshot.data!.docs.isNotEmpty;

                      return Stack(
                        children: [
                          IconButton(
                            onPressed: () {
                              _openMessages();
                            },
                            icon: const Icon(
                              Icons.chat_bubble_outline,
                              color: Colors.black,
                              size: 27,
                            ),
                          ),

                          if (hasMessages)
                            Positioned(
                              right: 7,
                              top: 7,
                              child: Container(
                                width: 9,
                                height: 9,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            // ================= TABS =================
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTab = 0;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedTab == 0
                              ? Colors.black
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Active',
                            style: TextStyle(
                              color: selectedTab == 0
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTab = 1;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedTab == 1
                              ? Colors.black
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Completed',
                            style: TextStyle(
                              color: selectedTab == 1
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // ================= JOBS =================
            Expanded(
              child: _buildJobsList(),
            ),
          ],
        ),
      ),

      // ================= BOTTOM NAVIGATION =================
      bottomNavigationBar: TechnicianBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });

          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const TechnicianHomeScreen(),
              ),
            );
          } else if (index == 1) {
            // Already on Jobs
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const TechnicianEarningsScreen(),
              ),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const TechnicianProfileScreen(),
              ),
            );
          }
        },
      ),
    );
  }

  // ============================================================
  // JOB LIST
  // ============================================================

  Widget _buildJobsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _getTechnicianJobsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Something went wrong.\n${snapshot.error}',
              textAlign: TextAlign.center,
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              selectedTab == 0
                  ? 'No active jobs yet.'
                  : 'No completed jobs yet.',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          );
        }

        final jobs = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final status = data['status']?.toString().toLowerCase() ?? '';

          if (selectedTab == 0) {
            return status == 'accepted' || status == 'in_progress';
          }

          return status == 'completed';
        }).toList();

        if (jobs.isEmpty) {
          return Center(
            child: Text(
              selectedTab == 0
                  ? 'No active jobs yet.'
                  : 'No completed jobs yet.',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 5,
          ),
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final job = jobs[index];

            final data = job.data() as Map<String, dynamic>;

            final status = data['status']?.toString() ?? 'pending';

            final customerName =
                data['customerName']?.toString() ??
                data['customer_name']?.toString() ??
                'Customer';

            final service =
                data['service']?.toString() ??
                data['serviceName']?.toString() ??
                data['service_required']?.toString() ??
                'Service';

            return _buildJobCard(
              jobId: job.id,
              customerName: customerName,
              service: service,
              status: status,
              data: data,
            );
          },
        );
      },
    );
  }

  // ============================================================
  // JOB CARD
  // ============================================================

  Widget _buildJobCard({
    required String jobId,
    required String customerName,
    required String service,
    required String status,
    required Map<String, dynamic> data,
  }) {
    final isCompleted = status.toLowerCase() == 'completed';
    final isInProgress = status.toLowerCase() == 'in_progress';

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CUSTOMER + STATUS
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey.shade200,
                child: const Icon(
                  Icons.person,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customerName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      service,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _statusColor(status).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _formatStatus(status),
                  style: TextStyle(
                    color: _statusColor(status),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // ADDRESS
          if (data['address'] != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 19,
                  color: Colors.grey,
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    data['address'].toString(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),

          const SizedBox(height: 15),

          // BUTTONS
          if (!isCompleted)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TechnicianChatScreen(
                            requestId: jobId,
                            customerName: customerName,
                            service: service,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.chat_bubble_outline,
                      size: 18,
                    ),
                    label: const Text('Message'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: const BorderSide(
                        color: Colors.black,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                if (!isInProgress)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _startJob(jobId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Start Job'),
                    ),
                  )
                else
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _completeJob(jobId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Complete'),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  // ============================================================
  // FIRESTORE STREAM
  // ============================================================

  Stream<QuerySnapshot> _getTechnicianJobsStream() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return FirebaseFirestore.instance
        .collection('service_requests')
        .where('technicianId', isEqualTo: user.uid)
        .snapshots();
  }

  // ============================================================
  // ACCEPTED / ACTIVE JOBS FOR MESSAGE ICON
  // ============================================================

  Stream<QuerySnapshot> _getAcceptedJobsStream() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return FirebaseFirestore.instance
        .collection('service_requests')
        .where('technicianId', isEqualTo: user.uid)
        .snapshots();
  }

  // ============================================================
  // MESSAGE SCREEN
  // ============================================================

  void _openMessages() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TechnicianMessagesScreen(),
      ),
    );
  }

  // ============================================================
  // START JOB
  // ============================================================

Future<void> _startJob(String requestId) async {
  try {
    await ServiceRequestService.startJob(requestId);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Job started successfully'),
      ),
    );
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $e'),
      ),
    );
  }
}

  // ============================================================
  // COMPLETE JOB
  // ============================================================

 Future<void> _completeJob(String requestId) async {
  try {
    await ServiceRequestService.completeJob(requestId);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Job completed successfully'),
      ),
    );
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $e'),
      ),
    );
  }
}
  // ============================================================
  // STATUS COLOR
  // ============================================================

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.blue;
      case 'in_progress':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatStatus(String status) {
    if (status == 'in_progress') {
      return 'In Progress';
    }

    if (status.isEmpty) {
      return 'Unknown';
    }

    return status[0].toUpperCase() + status.substring(1);
  }
}

// ================================================================
// TECHNICIAN MESSAGES SCREEN
// ================================================================

class TechnicianMessagesScreen extends StatelessWidget {
  const TechnicianMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please login again.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('service_requests')
            .where('technicianId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong.\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No messages yet.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            );
          }

          final jobs = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;

            final status =
                data['status']?.toString().toLowerCase() ?? '';

            return status == 'accepted' || status == 'in_progress';
          }).toList();

          if (jobs.isEmpty) {
            return const Center(
              child: Text(
                'No active conversations yet.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];

              final data = job.data() as Map<String, dynamic>;

              final customerName =
                  data['customerName']?.toString() ??
                  data['customer_name']?.toString() ??
                  'Customer';

              final service =
                  data['service']?.toString() ??
                  data['serviceName']?.toString() ??
                  data['service_required']?.toString() ??
                  'Service';

              return _messageJobCard(
                context,
                requestId: job.id,
                customerName: customerName,
                service: service,
              );
            },
          );
        },
      ),
    );
  }

  Widget _messageJobCard(
    BuildContext context, {
    required String requestId,
    required String customerName,
    required String service,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: const CircleAvatar(
          radius: 25,
          backgroundColor: Color(0xFFEAEAEA),
          child: Icon(
            Icons.person,
            color: Colors.grey,
          ),
        ),
        title: Text(
          customerName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(service),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.grey,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TechnicianChatScreen(
                requestId: requestId,
                customerName: customerName,
                service: service,
              ),
            ),
          );
        },
      ),
    );
  }
}

// ================================================================
// TECHNICIAN CHAT SCREEN
// ================================================================

class TechnicianChatScreen extends StatefulWidget {
  final String requestId;
  final String customerName;
  final String service;

  const TechnicianChatScreen({
    super.key,
    required this.requestId,
    required this.customerName,
    required this.service,
  });

  @override
  State<TechnicianChatScreen> createState() =>
      _TechnicianChatScreenState();
}

class _TechnicianChatScreenState extends State<TechnicianChatScreen> {
  final TextEditingController _messageController =
      TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // ============================================================
  // SEND MESSAGE
  // ============================================================

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();

    if (message.isEmpty) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    final senderName =
        user.displayName?.trim().isNotEmpty == true
            ? user.displayName!.trim()
            : 'Technician';

    _messageController.clear();

    try {
      await MessageService.sendMessage(
        requestId: widget.requestId,
        senderName: senderName,
        message: message,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to send message: $e',
          ),
        ),
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        iconTheme: const IconThemeData(
          color: Colors.black,
        ),

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.customerName,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              widget.service,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: Column(
        children: [

          // ====================================================
          // MESSAGES
          // ====================================================

          Expanded(
            child: StreamBuilder<
                QuerySnapshot<Map<String, dynamic>>>(
              stream: MessageService.messagesStream(
                widget.requestId,
              ),

              builder: (context, snapshot) {

                // LOADING
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // ERROR
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Something went wrong.\n\n'
                        '${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  );
                }

                // NO DATA
                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'Start the conversation.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                  );
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),

                  itemCount: messages.length,

                  itemBuilder: (context, index) {

                    final messageData =
                        messages[index].data();

                    final senderId =
                        messageData['senderId']
                            ?.toString() ??
                        '';

                    final text =
                        messageData['message']
                            ?.toString() ??
                        '';

                    final isMine =
                        senderId == currentUser?.uid;

                    return Align(
                      alignment: isMine
                          ? Alignment.centerRight
                          : Alignment.centerLeft,

                      child: Container(
                        margin: const EdgeInsets.only(
                          bottom: 10,
                        ),

                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),

                        constraints:
                            const BoxConstraints(
                          maxWidth: 280,
                        ),

                        decoration: BoxDecoration(
                          color: isMine
                              ? Colors.black
                              : Colors.white,

                          borderRadius:
                              BorderRadius.circular(16),
                        ),

                        child: Text(
                          text,

                          style: TextStyle(
                            color: isMine
                                ? Colors.white
                                : Colors.black,

                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // ====================================================
          // MESSAGE INPUT
          // ====================================================

          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),

              color: Colors.white,

              child: Row(
                children: [

                  // TEXT FIELD
                  Expanded(
                    child: TextField(
                      controller: _messageController,

                      textInputAction:
                          TextInputAction.send,

                      onSubmitted: (_) {
                        _sendMessage();
                      },

                      decoration: InputDecoration(
                        hintText: 'Type a message...',

                        filled: true,

                        fillColor:
                            const Color(0xFFF2F2F2),

                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(25),

                          borderSide:
                              BorderSide.none,
                        ),

                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // SEND BUTTON
                  CircleAvatar(
                    radius: 23,

                    backgroundColor: Colors.black,

                    child: IconButton(
                      onPressed: _sendMessage,

                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 19,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}