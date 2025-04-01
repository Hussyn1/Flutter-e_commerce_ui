import 'package:chat_app/screens/view/pages/fireBaseAuthServices/AuthServices.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  final AuthServices _authServices = AuthServices();
  final AuthForgetPassService _authForgetPassService = AuthForgetPassService();

  var isLoading = false.obs;

  // Text Controllers for the sign-up form
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
    final codeController = TextEditingController();

  RxBool codeSent = false.obs;
  String? verficationCode;

  Future<void> signUp() async {
    isLoading.value = true;

    String res = await _authServices.signUpUser(
      emailController.text.trim(),
      passwordController.text.trim(),
      nameController.text.trim(),
      phoneController.text.trim(),
      
    );

    isLoading.value = false;

    if (res == "Success") {
      Get.snackbar("Success", "Account created successfully",
          backgroundColor: Colors.green);
      Get.toNamed("/UploadProfilePicture");
    } else {
      Get.snackbar("Error", res, backgroundColor: Colors.red);
    }
  }

  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      isLoading.value = true;

      String result = await _authServices.loginUser(email, password);

      isLoading.value = false;

      if (result == "Success") {
        Get.toNamed('/HomePage');
      } else {
        Get.snackbar(
          "Login Failed",
          result,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
        );
      }
    } else {
      Get.snackbar(
        "Error",
        "Please fill in all fields",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.snackBarTheme.backgroundColor,
      );
    }
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
  }

   // Send Verification Code
  Future<void> sendVerificationCode() async {
    String email = emailController.text.trim();
    if (email.isNotEmpty) {
      verficationCode = await _authForgetPassService.sendVerificationCode(email);

      if (verficationCode != null) {
        Get.snackbar("Code Sent", "A verification code has been sent to your email.");
        codeSent.value = true;
        Get.toNamed('/codeInput'); // Move to code input screen
      } else {
        Get.snackbar("Error", "Email not found in the database.");
      }
    } else {
      Get.snackbar("Error", "Please enter your email.");
    }
  }

  // Verify Code
  Future<void> verifyCode(String text) async {
    String enteredCode = codeController.text.trim();

    if (enteredCode == verficationCode) {
      Get.toNamed('/resetPassword'); // Move to reset password screen
    } else {
      Get.snackbar("Error", "Incorrect code.");
    }
  }

  // Reset Password
  Future<void> resetPassword(String text) async {
    String newPassword = passwordController.text.trim();
    String code = codeController.text.trim();

    if (code == verficationCode) {
      if (newPassword.isNotEmpty) {
        try {
          await _authForgetPassService.resetPassword(newPassword);
          Get.snackbar("Success", "Your password has been reset.");
          clearFields();
          Get.offAllNamed('/Login'); // Navigate to login page after reset
        } catch (e) {
          Get.snackbar("Error", e.toString());
        }
      } else {
        Get.snackbar("Error", "Please enter a new password.");
      }
    } else {
      Get.snackbar("Error", "Incorrect code.");
    }
  }
    


  // Clear fields after process
  void clearfields() {
    emailController.clear();
    codeController.clear();
    passwordController.clear();
    codeSent.value = false;
  }

  @override
  
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
