import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';

import '../../../../core/common/widgets/custom_outline_button.dart';
import '../../../../core/common/widgets/custom_submit_button.dart';
import '../../../../core/common/widgets/custom_text.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../controllers/profile_screen_controller.dart';

final ProfileScreenController controller = Get.put(ProfileScreenController());

Widget facilityProfileOptionWidget(String icon, String title, String routeName) {
  return GestureDetector(
    onTap: () {
      if (title == "Delete Account") {
        showModalBottomSheet(
          context: Get.context!,
          builder: (_) => SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(16.h))),
              child: SafeArea(
                child: Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 12.h),
                        SizedBox(
                          width: 100.w,
                          child: Divider(
                            thickness: 4,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        CustomText(
                          text: "Delete Account",
                          fontSize: 18.sp,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                        SizedBox(height: 12.h),
                        SizedBox(
                          width: 327.w,
                          child: Divider(),
                        ),
                        SizedBox(height: 12.h),
                        CustomText(
                          text: "Are you sure you want to delete your account?",
                          fontSize: 16.sp,
                          color: AppColors.backgroundDark,
                          fontWeight: FontWeight.w400,
                        ),
                        SizedBox(height: 24.h),
                        SizedBox(
                          width: 350.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 1,
                                child: CustomOutlineButton(
                                  onPressed: () {
                                    Get.back(); // Close the bottom sheet
                                  },
                                  text: "Cancel",
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Flexible(
                                flex: 1,
                                child: CustomSubmitButton(
                                  text: controller.isLoading.value
                                      ? "" // Empty text during loading
                                      : "Yes, Delete", // Normal text when not loading
                                  onTap: () {
                                    if (controller.isLoading.value) {
                                      return; // Do nothing if loading
                                    }
                                    controller.deleteAccount();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Use Obx to listen to the isLoading observable
                        Obx(
                              () => controller.isLoading.value
                              ? Center(
                            child: LoadingAnimationWidget.staggeredDotsWave(
                              color: AppColors.primary,
                              size: 50.h,
                            ),
                          )
                              : SizedBox.shrink(), // Empty widget when not loading
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      } else {
        Get.toNamed(routeName);
      }
    },
    child: Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 12.w,
            children: [
              Image.asset(
                icon,
                color: AppColors.primary,
              ),
              CustomText(
                text: title,
                fontSize: 16.sp,
                color: AppColors.primary,
              ),
            ],
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColors.primary,
          )
        ],
      ),
    ),
  );
}
