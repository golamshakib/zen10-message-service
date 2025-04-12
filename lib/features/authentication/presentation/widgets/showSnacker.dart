import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackBar(
    {required String title,
      required String message,
      required IconData icon,
      required Color color}) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: color,
    colorText: Colors.white,
    icon: Icon(icon, color: Colors.white),
    borderRadius: 8,
    margin: EdgeInsets.all(10),
    duration: Duration(seconds: 3),
    isDismissible: true,
    forwardAnimationCurve: Curves.easeOutBack,
  );
}