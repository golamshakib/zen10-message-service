import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';
import 'package:traveling/core/utils/validators/app_validator.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/custom_text_feild.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/logo_path.dart';
import '../../controllers/change_password_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  final String accessToken;
  ChangePasswordScreen({super.key, required this.accessToken});

  // Define the formKey for validation
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final changePasswordController = Get.put(ChangePasswordController());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 70.h),
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  LogoPath.appLogo,
                  height: 80.h,
                  width: 80.w,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Change Password!',
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              Text('Please enter the new password.', style: TextStyle()),
              SizedBox(height: 30.h),

              // Wrap the form fields in a Form widget and pass the formKey
              Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Use the CustomTextField widget for password input
                      CustomTextField(
                        controller: changePasswordController.newPasswordController,
                        hintText: 'Enter your new password',
                        validator: AppValidator.validatePassword,
                      ),
                      SizedBox(height: 32.h),
                      Obx(
                            () => Center(
                          child: changePasswordController.isLoading.value
                              ? LoadingAnimationWidget.staggeredDotsWave(
                              color: AppColors.primary, size: 25.sp)
                              : CustomButton(
                            text: 'Save',
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                changePasswordController.changePassword(accessToken);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
