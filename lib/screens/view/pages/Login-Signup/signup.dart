import 'package:chat_app/screens/view/pages/GetxController/authController.dart';
import 'package:chat_app/screens/view/pages/widget/customBtn.dart';
import 'package:chat_app/screens/view/pages/widget/customField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthController _authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF6a5bc2),
        body: Obx(() {
          return _authController.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : Padding(
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
                                    controller: _authController.nameController,
                                    hintText: "Name",
                                    icon: const Icon(
                                      Icons.person,
                                    )),
                                const SizedBox(
                                  height: 15,
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
                                IntlPhoneField(
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.done,
                                  controller: _authController.phoneController,
                                  decoration: InputDecoration(
                                    hintText: "Phone Number",
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.black45)),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF6a5bc2),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                CustomField(
                                    controller:
                                        _authController.passwordController,
                                    hintText: "Password",
                                    icon: const Icon(
                                      Icons.password_rounded,
                                    )),
                                const SizedBox(
                                  height: 15,
                                ),
                                CustomBtn(
                                  onPressed: () {
                                    _authController.signUp();
                                  },
                                  text: "SignUp",
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Already have an account? ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Get.toNamed('/Login');
                                        },
                                        child: const Text("Login"))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        }));
  }
}
