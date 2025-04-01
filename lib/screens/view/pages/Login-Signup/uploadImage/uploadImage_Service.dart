import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gallery_picker/gallery_picker.dart';

Future<File?> getImageFromGallery(BuildContext context) async {
  try {
    List<MediaFile>? singleMedia = await GalleryPicker.pickMedia(
      context: context,
      singleMedia: true,
    );
    return singleMedia?.first.getFile();
  } catch (e) {
    print(e.toString());
  }
  return null;
}

Future<String?> uploadFileforUser(File file) async {
  try {
    // Create a reference to the storage bucket
    final storageRef = FirebaseStorage.instance.ref();
    
    // Create a unique file name
    String fileName = 'profile_pictures/${DateTime.now().millisecondsSinceEpoch}.jpg';
    
    // Upload the file
    UploadTask uploadTask = storageRef.child(fileName).putFile(file);
    
    // Wait for the upload to complete
    TaskSnapshot snapshot = await uploadTask;
    
    // Get the download URL
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl; // Return the download URL
  } catch (e) {
    print("Error uploading file: $e");
    return null; // Return null on failure
  }
}
  Future<void> saveImageUrlToFirestore(String downloadUrl) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        await FirebaseFirestore.instance.collection('users').doc(userId).update({
          'profileImageUrl': downloadUrl,
        });
      } else {
        print("User ID is null");
      }
    } catch (e) {
      print("Error saving image URL to Firestore: $e");
    }
  }
   Future<void> uploadImageAndSaveUrl(BuildContext context, File selectedImage) async {
    File? imageFile = await getImageFromGallery(context);
    if (imageFile != null) {
      String? downloadUrl = await uploadFileforUser(imageFile);
      if (downloadUrl != null) {
        await saveImageUrlToFirestore(downloadUrl);
        print("Image uploaded and URL saved to Firestore");
      } else {
        print("Failed to get download URL");
      }
    } else {
      print("No image selected");
    }
  }
Future<List<Reference>?> getUserUploadedFiles() async {
  try {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final storageRef = FirebaseStorage.instance.ref();
    final uploadRed = storageRef.child("$userId/uploads");
    final upload = await uploadRed.listAll();
    return upload.items;
  } catch (e) {
    print(e);
  }
  return null;
}
