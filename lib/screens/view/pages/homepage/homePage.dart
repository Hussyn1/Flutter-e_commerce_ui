import 'package:chat_app/screens/view/pages/chatPage/chat_Page.dart';
import 'package:chat_app/screens/view/pages/profile/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;

  bool isTapped =
      true; // Track if the container is tapped (set true for default active)
  String userName = "User"; // Default name
  String userEmail = "Email";
  String userPhoneNumber = "Phone";
  String userProfileImageUrl =
      "https://via.placeholder.com/150"; // Default image URL

// Fetch user's details from Firestore
  Future<void> fetchUserName() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        print("Document data: ${userDoc.data()}"); // Debugging line
        setState(() {
          userName = userDoc.data()?['name'] ?? "User"; // Fetch 'name' field
          userEmail = userDoc.data()?['email'] ?? "Email";
          userPhoneNumber = userDoc.data()?['phoneNumber'] ?? "Phone";
          userProfileImageUrl = userDoc.data()?['profileImageUrl'] ??
              "https://via.placeholder.com/150";
        });
      } else {
        print("User ID is null");
      }
    } catch (e) {
      print("Error fetching user details: $e"); // Check if there's an error
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserName(); // Fetch the user's name when the widget initializes
  }

  Future<Map<String, dynamic>?> fetchLastMessage(
      String chatUserId, String currentUserId) async {
    String chatDocId = chatUserId.compareTo(currentUserId) < 0
        ? '${chatUserId}_$currentUserId'
        : '${currentUserId}_$chatUserId';

    try {
      final chatDocSnapshot = await _firestore
          .collection('chats')
          .doc(chatDocId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (chatDocSnapshot.docs.isNotEmpty) {
        // Fetch unreadCount from the chat document
        final chatData =
            await _firestore.collection('chats').doc(chatDocId).get();
        return {
          'lastMessage': chatDocSnapshot.docs.first
              .data()['text'], // Ensure the field name is correct
          'unreadCount': chatData.data()?['unreadCount'] ?? 0,
          'timestamp': chatDocSnapshot.docs.first.data()['timestamp'],
        };
      }
    } catch (e) {
      print("Error fetching last message: $e");
    }
    return null; // Return null if there's an error or no message
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch users and their profile images
  // Fetch users and their profile images, excluding the logged-in user
  Future<List<Map<String, dynamic>>> fetchUsers() async {
    List<Map<String, dynamic>> users = [];

    // Get the currently logged-in user's UID
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    try {
      // Fetch all users from the Firestore 'users' collection
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("users").get();

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        String uid = data['uid'] ?? '';

        // Exclude the currently logged-in user
        if (uid.isNotEmpty && uid != currentUserId) {
          String name = data['name'] ?? 'Unknown User';
          String profileImageUrl =
              data['profileImageUrl'] ?? 'https://via.placeholder.com/150';

          // Add the UID to the map to ensure it’s available when generating chat IDs
          users.add({
            'uid': uid,
            'name': name,
            'profileImageUrl': profileImageUrl,
          });
        }
      }
    } catch (e) {
      print("Error fetching users: $e");
    }

    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6a5bc2),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Text(
                  "Hi $userName",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "You Received",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                        userName: userName,
                                        userEmail: userEmail,
                                        userPhonenumber: userPhoneNumber,
                                        profilePicture: userProfileImageUrl,
                                      )));
                        },
                        icon: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "48 Messages",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "Contact List",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No users found.'));
                  }

                  List<Map<String, dynamic>> users = snapshot.data!;

                  return SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 2,
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      users[index]['profileImageUrl']),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              users[index]['name'],
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.search_rounded,
                              size: 30,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isTapped =
                                    !isTapped; // Toggle the state when tapped
                              });
                            },
                            child: Container(
                              height: 55,
                              width: 170,
                              decoration: BoxDecoration(
                                color: isTapped ? Colors.yellow : Colors.grey,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Direct Message",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isTapped
                                              ? Colors.black
                                              : Colors.white),
                                    ),
                                    Container(
                                      height: 20,
                                      width: 20,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black),
                                      child: const Center(
                                        child: Text(
                                          "4",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 50,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.yellow.withOpacity(0.45),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Text(
                                    "Group ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    height: 20,
                                    width: 20,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black),
                                    child: const Center(
                                      child: Text(
                                        "4",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 11),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "All Message",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 15),
                      FutureBuilder<List<Map<String, dynamic>>>(
                          future: fetchUsers(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text('No users found.'));
                            }

                            List<Map<String, dynamic>> users = snapshot.data!;

                            return Expanded(
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: users.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatPage(
                                            chatWithUserId: users[index]
                                                    ['uid'] ??
                                                'Unknown UID',
                                            chatWithUserName: users[index]
                                                    ['name'] ??
                                                'Unknown User',
                                          ),
                                        ),
                                      );
                                    },
                                    child: FutureBuilder<Map<String, dynamic>?>(
                                      future: fetchLastMessage(
                                          users[index]['uid'], currentUserId!),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        }

                                        if (snapshot.hasError) {
                                          return Text(
                                              "Error: ${snapshot.error}");
                                        }
                                        String lastMessage =
                                            snapshot.data?['lastMessage'] ??
                                                "No messages yet";
                                        int unreadCount =
                                            snapshot.data?['unreadCount'] ?? 0;
                                        Timestamp timestamp =
                                            snapshot.data?['timestamp'];
                                        String formattedTime = timestamp != null
                                            ? DateFormat.jm()
                                                .format(timestamp.toDate())
                                            : "No time";

                                        return Container(
                                          height: 88,
                                          width: double.infinity,
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.black12,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  height: 70,
                                                  width: 70,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Colors.white
                                                          .withOpacity(0.3),
                                                      width: 2,
                                                    ),
                                                    image: DecorationImage(
                                                      image: NetworkImage(users[
                                                              index]
                                                          ['profileImageUrl']),
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(users[index]['name'],
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18)),
                                                    Text(lastMessage,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .black45)),
                                                  ],
                                                ),
                                                const Spacer(),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(formattedTime,
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors
                                                                .black45)),
                                                    if (unreadCount > 0)
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xFF6a5bc2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        child: Text(
                                                          unreadCount
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            );
                          })
                    ],
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
