import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:traveling/core/common/widgets/custom_button.dart';
import 'package:traveling/core/common/widgets/custom_text_feild.dart';
import 'package:traveling/core/utils/constants/app_colors.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';
import 'package:traveling/core/utils/constants/logo_path.dart';
import 'package:traveling/core/utils/validators/app_validator.dart';
import 'package:get/get.dart';
import 'package:traveling/features/authentication/controllers/login_controller.dart';
import 'package:traveling/features/authentication/presentation/widgets/forgot_password_dialog.dart';
import 'package:traveling/routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final loginController = Get.find<LoginController>();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 72.h),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Image.asset(
                  LogoPath.appLogo,
                  width: 250.w,
                  height: 120.h,
                ),
                SizedBox(height: 12.h),
                Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF333333),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Book your next session and experience care wherever you are.',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF808080),
                  ),
                ),
                SizedBox(height: 40.h),
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
                  controller: loginController.emailController,
                  hintText: 'Enter your phone number or email',
                  validator: AppValidator.validateInput,
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
                  controller: loginController.passwordController,
                  hintText: 'Enter your password',
                  validator: AppValidator.validatePassword,
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Obx(() => Checkbox(
                              value: loginController.isRememberMeChecked.value,
                              onChanged: (value) {
                                loginController.isRememberMeChecked.value =
                                    value!;
                              },
                              activeColor: AppColors.primary,
                            )),
                        Text(
                          'Remember me',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        showForgotPasswordDialog(context);
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationStyle: TextDecorationStyle.solid,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff002BFF),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Obx(
                  () => Center(
                    child: loginController.isLoading.value
                        ? LoadingAnimationWidget.staggeredDotsWave(
                            color: AppColors.primary, size: 25.sp)
                        : CustomButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                loginController.login();
                              }
                            },
                            text: 'Login',
                          ),
                  ),
                ),
                SizedBox(height: 40.h),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoute.signUpScreen);
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Don’t have an account? ",
                      style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(
                          text: "Sign Up",
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
