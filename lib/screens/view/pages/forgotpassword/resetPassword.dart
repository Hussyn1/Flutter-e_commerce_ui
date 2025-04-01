import 'package:chat_app/screens/view/pages/GetxController/authController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_app/screens/view/pages/widget/customBtn.dart';
import 'package:chat_app/screens/view/pages/widget/customField.dart';

class ResetPasswordScreen extends StatelessWidget {
  final TextEditingController passwordController = TextEditingController();
  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFF6a5bc2),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Reset Password",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    CustomField(
                      hintText: "New Password",
                      icon: const Icon(Icons.lock),
                      controller: passwordController,
                    ),
                    SizedBox(height: 20),
                    CustomBtn(
                      text: "Reset Password",
                      onPressed: () {
                        _authController.resetPassword(passwordController.text);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
