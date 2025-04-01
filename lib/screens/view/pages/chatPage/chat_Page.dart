import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String chatWithUserId;
  final String chatWithUserName;

  ChatPage(
      {Key? key, required this.chatWithUserId, required this.chatWithUserName})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String generateChatId(String user1, String user2) {
    List<String> sortedUsers = [user1, user2]..sort();
    return '${sortedUsers[0]}_${sortedUsers[1]}';
  }

  final TextEditingController messageController = TextEditingController();
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  Stream<QuerySnapshot> fetchMessages() {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final currentUserId = user.uid;
      String chatId = generateChatId(currentUserId, widget.chatWithUserId);
      print("Fetching messages for Chat ID: $chatId");

      return FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots();
    } else {
      print("User is not authenticated.");
      return const Stream.empty();
    }
  }

  void sendMessage() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && messageController.text.isNotEmpty) {
      final currentUserId = user.uid;
      final chatWithUserId = widget.chatWithUserId;

      print("Current User ID: $currentUserId");
      print("Chat With User ID: $chatWithUserId");

      // Ensure consistent ordering of IDs for chatId
      String chatId = generateChatId(currentUserId, chatWithUserId);
      print("Generated Chat ID: $chatId");

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'senderId': currentUserId,
        'text': messageController.text,
        'timestamp': FieldValue.serverTimestamp(),
          'isRead': false, // Add this line for tracking read status

      });

      messageController.clear();
    } else {
      print("User is not authenticated or message is empty.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf0f0f0),
      appBar: AppBar(
        title: Text(widget.chatWithUserName),
        backgroundColor: const Color(0xFF6a5bc2),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: fetchMessages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No messages yet."));
                }

                List<QueryDocumentSnapshot> messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(16.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> message =
                        messages[index].data() as Map<String, dynamic>;
                    bool isSentByMe = message['senderId'] == currentUserId;

                    return Align(
                      alignment: isSentByMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 8),
                        decoration: BoxDecoration(
                          color: isSentByMe ? Colors.blue : Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message['text'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              message['timestamp'] != null
                                  ? (message['timestamp'] as Timestamp)
                                      .toDate()
                                      .toLocal()
                                      .toString()
                                  : 'Sending...',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 10),
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
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF6a5bc2),
                    shape: BoxShape.circle,
                  ),
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
