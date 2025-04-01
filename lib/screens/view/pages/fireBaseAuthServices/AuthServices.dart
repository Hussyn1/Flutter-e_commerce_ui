import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthServices {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Logout
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offNamed("Login");
      print("User logged out successfully.");
    } catch (e) {
      print("Error logging out: $e");
    }
  }

  //Sign Up
  Future<String> signUpUser(
      String email, String password, String name, String phoneNumber) async {
    String res = "Error";

    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          name.isNotEmpty &&
          phoneNumber.isNotEmpty) {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await firestore.collection("users").doc(userCredential.user!.uid).set({
          "name": name,
          "email": email,
          "phoneNumber": phoneNumber,
          "uid": userCredential.user!.uid,
        });

        res = "Success";
      } else {
        res = "Please fill in all fields";
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

//Login
  Future<String> loginUser(
    String email,
    String password,
  ) async {
    String res = "Error";

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        print(userCredential);
        res = "Success";
      } else {
        res = "Please fill in all fields";
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific FirebaseAuth exceptions
      if (e.code == 'user-not-found') {
        res = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        res = 'Wrong password provided for that user.';
      } else {
        res = e.message ?? 'An unknown error occurred';
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }
}
//Forget Password

class AuthForgetPassService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> sendVerificationCode(String email) async {
    print("Querying for email: $email"); // Add this line for debugging

    var snapshot = await firestore
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
    if (snapshot.docs.isNotEmpty) {
      print(
          "Email found: ${snapshot.docs.first.data()}"); // Log the found document

      String code = _generateRandomCode();
      return code;
    } else {
      return null;
    }
  }

  String _generateRandomCode() {
    var rng = Random();
    return rng.nextInt(900000).toString().padLeft(6, '0');
  }

  Future<void> resetPassword(String newPassword) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
    } else {
      throw FirebaseAuthException(
          message: "No user found", code: "USER_NOT_FOUND");
    }
  }
}
