import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/Auth_service.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/utils/constants/app_urls.dart';
import '../../../core/utils/logging/logger.dart';
import '../presentation/widgets/showSnacker.dart';

class SingUpController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();


  RxBool isLoading = false.obs;





  void signUp() async {
    final user = userNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPassController.text.trim();

    if (password != confirmPassword) {
      showSnackBar(
        title: 'Password Mismatch',
        message: 'Passwords do not match. Please re-enter them.',
        icon: Icons.error_outline_rounded,
        color: Colors.redAccent,
      );
      return;
    }

    isLoading(true);
    final Map<String, String> requestBody = {
      'username': user.trim(),
      "email": email.trim(),
      "password": confirmPassword.trim(),
    };

    try {
      final response =
      await NetworkCaller().postRequest(AppUrls.singUp, body: requestBody);

      if (response.isSuccess) {
        String? token = response.responseData['data']['accessToken'];
        if (token != null) {
          await AuthService.saveToken(token);

        }
      } else if (response.statusCode == 409) {
        showSnackBar(
          title: 'Same Email',
          message: 'This email is already registered',
          icon: Icons.error_outline_rounded,
          color: Colors.redAccent,
        );
      } else {
        showSnackBar(
          title: 'Error',
          message: response.errorMessage,
          icon: Icons.error_outline_rounded,
          color: Colors.redAccent,
        );
      }
    } catch (e) {
      AppLoggerHelper.error('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
