import 'package:flutter/material.dart';
import 'package:traveling/core/common/widgets/custom_button.dart';
import 'package:traveling/core/common/widgets/custom_text_feild.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';
import 'package:traveling/core/utils/constants/logo_path.dart';
import 'package:traveling/core/utils/validators/app_validator.dart';
import 'package:get/get.dart';
import 'package:traveling/features/authentication/controllers/sing_up_controller.dart';
import 'package:traveling/routes/app_routes.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  final singUpController = Get.find<SingUpController>();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 72.h,
                ),
                Image.asset(
                  LogoPath.appLogo,
                  width: 250.w,
                  height: 100.h,
                ),
                SizedBox(height: 12.h),
                Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF333333),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Create an account to access mobile care and book services near you.',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF808080),
                  ),
                ),
                SizedBox(height: 40.h),
                Text(
                  'Username',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: singUpController.userNameController,
                  hintText: 'Enter your username',
                  validator: AppValidator.validateInput,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Phone/Email',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: singUpController.emailController,
                  hintText: 'Enter your phone number/email',
                  validator: AppValidator.validatePassword,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: singUpController.passwordController,
                  hintText: 'Enter your password',
                  validator: AppValidator.validatePassword,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Confirm Password',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: singUpController.confirmPassController,
                  hintText: 'Enter your password again',
                  validator: AppValidator.validatePassword,
                ),
                SizedBox(height: 16.h),
                CustomButton(
                  onPressed: () {
                    // if (formKey.currentState!.validate()) {
                    //   // Perform login operation
                    // }
                  },
                  text: 'Sing Up',
                ),
                SizedBox(height: 40.h),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoute.loginScreen);
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(
                          text: "Log In",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Color(0xff002BFF),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
