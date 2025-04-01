import 'package:chat_app/screens/view/pages/widget/customBtn.dart';
import 'package:chat_app/screens/view/pages/widget/customField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../GetxController/authController.dart';

class ForgetPass extends StatefulWidget {
  const ForgetPass({super.key});

  @override
  State<ForgetPass> createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  final TextEditingController _emailController = TextEditingController();
  final AuthController _authController =
      Get.find<AuthController>(); // GetX Controller

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
              Container(
                height: 150,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/Forgot.png"),
                      fit: BoxFit.contain),
                ),
              ),
              const Text(
                "Forget Password",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
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
                        hintText: "Email",
                        icon: const Icon(Icons.email),
                        controller: _emailController),
                    const SizedBox(
                      height: 20,
                    ),
                    Obx(
                      () {
                        // Show a loading indicator while processing
                        if (_authController.codeSent.value) {
                          return CircularProgressIndicator();
                        } else {
                          return CustomBtn(
                            text: "Send",
                            onPressed: () {
                              // Call the controller to send the verification code
                              _authController.emailController.text =
                                  _emailController.text;
                              _authController.sendVerificationCode( );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
