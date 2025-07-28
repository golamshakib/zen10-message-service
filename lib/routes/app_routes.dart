import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:traveling/features/Payment/presentation/screens/receipt_screen.dart';
import 'package:traveling/features/home/presentation/screens/home_screen.dart';
import '../features/authentication/presentation/screens/login_screen.dart';
import '../features/authentication/presentation/screens/sing_up_screen.dart';
import '../features/splash_screen/presentation/screens/splash_screen.dart';

class AppRoute {
  static String loginScreen = "/loginScreen";
  static String signUpScreen = "/signUpScreen";
  static String init = "/";
  static String homeScreen = "/homeScreen";
  // static String receiptScreen = "/receiptScreen";



  static List<GetPage> routes = [
    GetPage(
        name: loginScreen,
        page: () => LoginScreen(),
        transition: Transition.fade,
        transitionDuration: const Duration(milliseconds: 300),
        curve: Curves.easeOut),
    GetPage(name: init, page: () => SplashScreen()),
    GetPage(name: signUpScreen, page: () => SignUpScreen()),
    GetPage(name: homeScreen, page: () => HomeScreen()),
    // GetPage(name: receiptScreen, page: () => ReceiptScreen()),

  ];
}
