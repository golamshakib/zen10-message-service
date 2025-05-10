

import 'package:flutter/material.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:traveling/core/common/widgets/custom_button.dart';
import 'package:traveling/core/common/widgets/custom_text_feild.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';
import 'package:traveling/core/utils/constants/logo_path.dart';
import 'package:traveling/core/utils/validators/app_validator.dart';
import 'package:get/get.dart';
import 'package:traveling/features/authentication/controllers/sing_up_controller.dart';
import 'package:traveling/routes/app_routes.dart';

import '../../../../core/utils/constants/app_colors.dart';
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
                SizedBox(height: 72.h),
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
                ),
                SizedBox(height: 16.h),
                Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: singUpController.emailController,
                  hintText: 'Enter your email',
                  validator: AppValidator.validateEmail,
                ),
                SizedBox(height: 16.h),
                // Text(
                //   'Address',
                //   style: TextStyle(
                //     fontSize: 16.sp,
                //     fontWeight: FontWeight.w600,
                //     color: Color(0xFF333333),
                //   ),
                // ),
                // SizedBox(height: 8.h),
                // Container(
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(38.h),
                //   ),
                //   child: TextFormField(
                //     readOnly: true,
                //     controller: singUpController.addressController,
                //     validator: AppValidator.validateInputField,
                //     decoration: InputDecoration(
                //       suffixIcon: IconButton(
                //         onPressed: () async {
                //           log("Navigating to MapScreen...");
                //           LatLng? selectedLocation =
                //               await Get.to(() => MapScreen());
                //           log("Returned location: $selectedLocation");
                //
                //           if (selectedLocation != null) {
                //             // Use reverse geocoding to get the address from latitude and longitude
                //             List<Placemark> placemarks = await GeocodingPlatform
                //                 .instance!
                //                 .placemarkFromCoordinates(
                //               selectedLocation.latitude,
                //               selectedLocation.longitude,
                //             );
                //
                //             // Check if placemarks are available
                //             if (placemarks.isNotEmpty) {
                //               Placemark place = placemarks[0];
                //               String address =
                //                   '${place.name}, ${place.locality}, ${place.country}';
                //
                //               // Set the selected address in the controller
                //               singUpController.addressController.text = address;
                //             } else {
                //               singUpController.addressController.text =
                //                   'Address not found';
                //             }
                //           }
                //         },
                //         icon: Icon(Icons.location_on_outlined),
                //       ),
                //       hintText: 'Pick your address',
                //       border: InputBorder.none,
                //       focusedBorder: InputBorder.none,
                //       focusedErrorBorder: InputBorder.none,
                //       enabledBorder: InputBorder.none,
                //       errorBorder: InputBorder.none,
                //       disabledBorder: InputBorder.none,
                //       contentPadding:
                //           EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                //     ),
                //   ),
                // ),
                // SizedBox(height: 16.h),
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
                Obx(
                  () => Center(
                    child: singUpController.isLoading.value
                        ? LoadingAnimationWidget.staggeredDotsWave(
                            color: AppColors.primary, size: 25.sp)
                        : CustomButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                singUpController.signUp();
                              }
                            },
                            text: 'Sign Up',
                          ),
                  ),
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
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
