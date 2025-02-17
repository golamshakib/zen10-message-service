import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import '../features/authentication/presentation/screens/login_screen.dart';
import '../features/authentication/presentation/screens/sing_up_screen.dart';
import '../features/splash_screen/presentation/screens/splash_screen.dart';

class AppRoute {
  static String loginScreen = "/loginScreen";
  static String signUpScreen = "/signUpScreen";
  static String init = "/";

  static List<GetPage> routes = [
    GetPage(
        name: loginScreen,
        page: () => const LoginScreen(),
        transition: Transition.fade,
        transitionDuration: const Duration(milliseconds: 300),curve: Curves.easeOut),
    GetPage(name: init, page: () => SplashScreen()),
    GetPage(name: signUpScreen, page: () => const SignUpScreen())
  ];
}
