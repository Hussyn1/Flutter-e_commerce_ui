import 'dart:io';
import 'package:chat_app/screens/view/pages/homepage/homePage.dart';
import 'package:chat_app/screens/view/pages/Login-Signup/uploadImage/uploadImage_Service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add this import
import 'package:get/get.dart';

class UploadProfilePicture extends StatefulWidget {
  const UploadProfilePicture({super.key});

  @override
  State<UploadProfilePicture> createState() => _UploadProfilePictureState();
}

class _UploadProfilePictureState extends State<UploadProfilePicture> {
  String? _uploadedImageUrl; // Store the current profile picture URL

  @override
  void initState() {
    super.initState();
    getUploadedFile(); // Fetch the uploaded file on init
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6a5bc2),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Welcome Hussyn",
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Center(
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () async {
                    File? selectedImage = await getImageFromGallery(context);
                    if (selectedImage != null) {
                      // Upload the selected image and save the URL to Firestore
                      String? newProfileUrl =
                          await uploadFileforUser(selectedImage);
                      if (newProfileUrl != null) {
                        await saveImageUrlToFirestore(
                            newProfileUrl); // Save URL to Firestore
                        setState(() {
                          _uploadedImageUrl =
                              newProfileUrl; // Update with new URL
                        });
                      } else {
                        print("Failed to upload new profile picture.");
                      }
                    }
                  },
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.white,
                    backgroundImage: _uploadedImageUrl != null
                        ? NetworkImage(_uploadedImageUrl!)
                        : null,
                    child: _uploadedImageUrl == null
                        ? const Icon(Icons.person,
                            color: Colors.black45, size: 100)
                        : null,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 35,
                  child: Icon(
                    _uploadedImageUrl == null ? Icons.camera_alt : null,
                    color: _uploadedImageUrl == null
                        ? Colors.black54
                        : Colors.white,
                    size: 27,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "You're all set\nTake a minute to upload or change your profile picture",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 20),
          if (_uploadedImageUrl != null)
            ElevatedButton(
              onPressed: () {
                Get.to(() => const HomePage());
              },
              child: const Text("Confirm Profile Picture"),
            ),
        ],
      ),
    );
  }

  // Fetch the uploaded file and update the displayed profile picture URL
  Future<void> getUploadedFile() async {
    final userId =
        FirebaseAuth.instance.currentUser?.uid; // Get current user's ID
    if (userId != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        if (userDoc.exists && userDoc.data() != null) {
          // Check if the profileImageUrl field exists
          String? downloadUrl = userDoc.get('profileImageUrl');
          if (downloadUrl != null && downloadUrl.isNotEmpty) {
            setState(() {
              _uploadedImageUrl =
                  downloadUrl; // Update to show the user's picture
            });
          } else {
            print("No profile image URL found for the user.");
          }
        } else {
          print("User document does not exist.");
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    } else {
      print("No user is currently signed in.");
    }
  }

  // Function to save the image URL to Firestore
  Future<void> saveImageUrlToFirestore(String downloadUrl) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'profileImageUrl': downloadUrl,
        });
      } else {
        print("User ID is null");
      }
    } catch (e) {
      print("Error saving image URL to Firestore: $e");
    }
  }
}
