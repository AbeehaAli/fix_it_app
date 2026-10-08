import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/features/firebase/data/services/service_request_service.dart';
import 'package:flutter/material.dart';
import 'package:final_project/features/firebase/data/services/messages_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomerMessagesScreen extends StatelessWidget {
  const CustomerMessagesScreen({super.key});

  String getTimeAgo(Timestamp? timestamp) {
    if (timestamp == null) {
      return '';
    }

    final difference =
        DateTime.now().difference(timestamp.toDate());

    if (difference.inSeconds < 60) {
      return 'Just now';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours} hr ago';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays} day ago';
    }

    return '${timestamp.toDate().day}/${timestamp.toDate().month}/${timestamp.toDate().year}';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: screenHeight * 0.04,
            ),

            Text(
              'Messages',
              style: TextStyle(
                fontSize: screenWidth * 0.065,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF172033),
              ),
            ),

            SizedBox(
              height: screenHeight * 0.008,
            ),

            Text(
              'Chat with your technicians',
              style: TextStyle(
                fontSize: screenWidth * 0.038,
                color: Colors.grey.shade600,
              ),
            ),

            SizedBox(
              height: screenHeight * 0.035,
            ),

            Expanded(
              child: StreamBuilder<
                  QuerySnapshot<Map<String, dynamic>>>(
                stream:
                    ServiceRequestService.customerRequestsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF12A66A),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Unable to load messages.',
                        style: TextStyle(
                          fontSize: screenWidth * 0.034,
                          color: Colors.red,
                        ),
                      ),
                    );
                  }

                  final documents =
                      snapshot.data?.docs ?? [];

                  final jobs = documents.where((doc) {
                    final status = doc.data()['status']
                        ?.toString()
                        .toLowerCase();

                    return status == 'accepted' ||
                        status == 'in_progress';
                  }).toList();

                  if (jobs.isEmpty) {
                    return Center(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.04,
                          horizontal: screenWidth * 0.06,
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
                              color: Colors.black
                                  .withOpacity(0.07),
                              blurRadius: 12,
                              spreadRadius: 1,
                              offset:
                                  const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width:
                                  screenWidth * 0.18,
                              height:
                                  screenWidth * 0.18,
                              decoration:
                                  const BoxDecoration(
                                color:
                                    Color(0xFFEAF7F1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons
                                    .chat_bubble_outline_rounded,
                                size:
                                    screenWidth * 0.09,
                                color: const Color(
                                  0xFF12A66A,
                                ),
                              ),
                            ),

                            SizedBox(
                              height:
                                  screenHeight * 0.018,
                            ),

                            Text(
                              'No messages yet',
                              style: TextStyle(
                                fontSize:
                                    screenWidth * 0.045,
                                fontWeight:
                                    FontWeight.w600,
                                color: const Color(
                                  0xFF172033,
                                ),
                              ),
                            ),

                            SizedBox(
                              height:
                                  screenHeight * 0.008,
                            ),

                            Text(
                              'Your conversations with technicians will appear here.',
                              textAlign:
                                  TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    screenWidth * 0.034,
                                color:
                                    Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      final job = jobs[index];
                      final data = job.data();

                      final technicianName =
                          data['technicianName']
                                      ?.toString()
                                      .trim()
                                      .isNotEmpty ==
                                  true
                              ? data['technicianName']
                                  .toString()
                              : 'Technician';

                      final service =
                          data['service']
                                      ?.toString()
                                      .trim()
                                      .isNotEmpty ==
                                  true
                              ? data['service'].toString()
                              : 'Service';

                      return StreamBuilder<
                          QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('service_requests')
                            .doc(job.id)
                            .collection('messages')
                            .orderBy(
                              'createdAt',
                              descending: true,
                            )
                            .limit(1)
                            .snapshots(),
                        builder:
                            (context, messageSnapshot) {
                          String lastMessage =
                              'No messages yet';

                          String timeAgo = '';

                          if (messageSnapshot.hasData &&
                              messageSnapshot
                                  .data!.docs.isNotEmpty) {
                            final messageData =
                                messageSnapshot
                                    .data!.docs.first
                                    .data();

                            lastMessage =
                                messageData['message']
                                        ?.toString() ??
                                    'No messages yet';

                            final createdAt =
                                messageData['createdAt'];

                            if (createdAt is Timestamp) {
                              timeAgo =
                                  getTimeAgo(createdAt);
                            }
                          }

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CustomerChatScreen(
                                    requestId: job.id,
                                    technicianName:
                                        technicianName,
                                    service: service,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              margin:
                                  const EdgeInsets.only(
                                bottom: 14,
                              ),
                              padding:
                                  const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(
                                    0xFFE5EAF0,
                                  ),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.05),
                                    blurRadius: 10,
                                    offset:
                                        const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration:
                                        BoxDecoration(
                                      color: const Color(
                                        0xFFEAF7F1,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(
                                        14,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.person_outline,
                                      color: Color(
                                        0xFF12A66A,
                                      ),
                                      size: 27,
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 14,
                                  ),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                technicianName,
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                style:
                                                    const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight
                                                          .bold,
                                                  color: Color(
                                                    0xFF172033,
                                                  ),
                                                ),
                                              ),
                                            ),

                                            if (timeAgo
                                                .isNotEmpty)
                                              Text(
                                                timeAgo,
                                                style:
                                                    TextStyle(
                                                  fontSize: 11,
                                                  color: Colors
                                                      .grey
                                                      .shade500,
                                                ),
                                              ),
                                          ],
                                        ),

                                        const SizedBox(
                                          height: 5,
                                        ),

                                        Text(
                                          service,
                                          maxLines: 1,
                                          overflow:
                                              TextOverflow
                                                  .ellipsis,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors
                                                .grey
                                                .shade600,
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 7,
                                        ),

                                        Text(
                                          lastMessage,
                                          maxLines: 1,
                                          overflow:
                                              TextOverflow
                                                  .ellipsis,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors
                                                .grey
                                                .shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 8,
                                  ),

                                  const Padding(
                                    padding:
                                        EdgeInsets.only(
                                      top: 18,
                                    ),
                                    child: Icon(
                                      Icons
                                          .arrow_forward_ios,
                                      size: 14,
                                      color:
                                          Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
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
}

class CustomerChatScreen extends StatefulWidget {
  final String requestId;
  final String technicianName;
  final String service;

  const CustomerChatScreen({
    super.key,
    required this.requestId,
    required this.technicianName,
    required this.service,
  });

  @override
  State<CustomerChatScreen> createState() =>
      _CustomerChatScreenState();
}

class _CustomerChatScreenState
    extends State<CustomerChatScreen> {
  final TextEditingController messageController =
      TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  Future<void> sendMessage() async {
    final message = messageController.text.trim();

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
            : 'Customer';

    try {
      await MessageService.sendMessage(
        requestId: widget.requestId,
        senderName: senderName,
        message: message,
      );

      messageController.clear();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send message: $e'),
        ),
      );
    }
  }

  String formatMessageTime(Timestamp? timestamp) {
    if (timestamp == null) {
      return '';
    }

    final dateTime = timestamp.toDate().toLocal();

    int hour = dateTime.hour;
    final minute = dateTime.minute
        .toString()
        .padLeft(2, '0');

    final period = hour >= 12 ? 'PM' : 'AM';

    hour = hour % 12;

    if (hour == 0) {
      hour = 12;
    }

    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId =
        FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.technicianName),
            Text(
              widget.service,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<
                QuerySnapshot<Map<String, dynamic>>>(
              stream: MessageService.messagesStream(
                widget.requestId,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                    ),
                  );
                }

                final messages =
                    snapshot.data?.docs ?? [];

                if (messages.isEmpty) {
                  return const Center(
                    child: Text(
                      'No messages yet',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data = messages[index].data();

                    final message =
                        data['message']?.toString() ?? '';

                    final senderId =
                        data['senderId']?.toString() ?? '';

                    final isMine =
                        senderId == currentUserId;

                    final createdAt =
                        data['createdAt'];

                    String messageTime = '';

                    if (createdAt is Timestamp) {
                      messageTime =
                          formatMessageTime(createdAt);
                    }

                    return Align(
                      alignment: isMine
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth:
                              MediaQuery.of(context).size.width *
                                  0.75,
                        ),
                        margin: const EdgeInsets.only(
                          bottom: 10,
                        ),
                        padding: const EdgeInsets.only(
                          left: 14,
                          right: 8,
                          top: 10,
                          bottom: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isMine
                              ? Colors.green
                              : Colors.grey.shade200,
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment:
                              CrossAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Text(
                                message,
                                style: TextStyle(
                                  color: isMine
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),

                            const SizedBox(width: 8),

                            Text(
                              messageTime,
                              style: TextStyle(
                                color: isMine
                                    ? Colors.white70
                                    : Colors.grey.shade600,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    textInputAction:
                        TextInputAction.send,
                    onSubmitted: (_) {
                      sendMessage();
                    },
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(25),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.green,
                  child: IconButton(
                    onPressed: sendMessage,
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}