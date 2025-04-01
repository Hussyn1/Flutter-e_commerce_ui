import 'package:chat_app/screens/view/pages/GetxController/authController.dart';
import 'package:chat_app/screens/view/pages/widget/customBtn.dart';
import 'package:chat_app/screens/view/pages/widget/customField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
    final AuthController _authController = Get.put(AuthController());

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6a5bc2),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 40),
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/logo.png"),
                        fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      CustomField(
                          controller: _authController.emailController,
                          hintText: "Email",
                          icon: const Icon(
                            Icons.email,
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomField(
                          controller: _authController.passwordController,
                          hintText: "Password",
                          icon: const Icon(
                            Icons.password_rounded,
                          )),
                      TextButton(
                        onPressed: () {Get.toNamed('/ForgetPass');},
                        child: const Text("Forgot Password?"),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomBtn(
                        onPressed: () {
                          _authController.login();
                        },
                        text: "Login",
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                          TextButton(
                              onPressed: () {
                                Get.toNamed('/Signup');
                              },
                              child: const Text("SignUp"))
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
