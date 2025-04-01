import 'package:chat_app/screens/view/pages/GetxController/authController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_app/screens/view/pages/widget/customBtn.dart';
import 'package:chat_app/screens/view/pages/widget/customField.dart';

// ignore: use_key_in_widget_constructors
class CodeInputScreen extends StatelessWidget {
  final TextEditingController codeController = TextEditingController();
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
                "Enter Verification Code",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
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
                      hintText: "Verification Code",
                      icon: const Icon(Icons.verified_user),
                      controller: codeController,
                    ),
                    const SizedBox(height: 20),
                    CustomBtn(
                      text: "Verify Code",
                      onPressed: () {
                        _authController.verifyCode(codeController.text);
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
