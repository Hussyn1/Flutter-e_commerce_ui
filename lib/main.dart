import 'package:chat_app/screens/view/pages/homepage/homePage.dart';
import 'package:chat_app/screens/view/pages/Login-Signup/uploadImage/upload_image.dart';
import 'package:chat_app/screens/view/pages/forgotpassword/codeInput.dart';
import 'package:chat_app/screens/view/pages/Login-Signup/loginPage.dart';
import 'package:chat_app/screens/view/pages/forgotpassword/resetPassword.dart';
import 'package:chat_app/screens/view/pages/Login-Signup/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/view/pages/forgotpassword/Forget_Passwrod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/Login',
      getPages: [
        GetPage(
          name: '/Signup',
          page: () => const SignUp(
            
          ),
        ),
        GetPage(
          name: '/Login',
          page: () => const LoginPage(),
        ),
        GetPage(
          name: '/ForgetPass',
          page: () => const ForgetPass(),
        ),
        GetPage(
          name: '/HomePage',
          page: () => const HomePage(),
        ),
        GetPage(
            name: '/UploadProfilePicture',
            page: () => const UploadProfilePicture(),
            transition: Transition.fade),
        GetPage(name: '/codeInput', page: () => CodeInputScreen()),
        GetPage(name: '/resetPassword', page: () => ResetPasswordScreen()),
      ],
    );
  }
}
