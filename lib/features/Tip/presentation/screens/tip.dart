import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:traveling/core/common/widgets/custom_button.dart';
import 'package:traveling/core/common/widgets/custom_text_feild.dart';
import 'package:traveling/core/utils/constants/app_colors.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';
import 'package:traveling/core/utils/constants/image_path.dart';
import 'package:traveling/features/Payment/controllers/pay_and_book_controller.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen(
      {super.key, required this.bookingId, required this.userName});

  final String bookingId;
  final String userName;
  @override
  _TipsScreenState createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  int selectedTip = 2;
  final TextEditingController customTipController = TextEditingController();
  final PayAndBookController controller = Get.put(PayAndBookController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 128.h, bottom: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(ImagePath.thank, width: 145.w, height: 145.h),
              SizedBox(height: 24.h),
              Text(
                "Thank You for Using Our Service!",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "We hope you enjoyed your session. Would you like to leave a tip for your therapist?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 40.h),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text(
              //       "Your masseuse was: ",
              //       style: TextStyle(
              //         fontSize: 16,
              //         color: AppColors.textSecondary,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //     Text(
              //       " ${widget.userName}",
              //       style: TextStyle(
              //         fontSize: 16,
              //         color: AppColors.textPrimary,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(height: 16.h),
              Wrap(
                spacing: 10,
                children: [
                  tipButton(2),
                  tipButton(5),
                  tipButton(10),
                  // tipButton(null, "Other"),
                  InkWell(
                    onTap: () {
                      Get.dialog(Dialog(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Enter your custom amount",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CustomTextField(
                                  keyboardType: TextInputType.numberWithOptions(),
                                  controller: customTipController,
                                  hintText: ""),
                              SizedBox(
                                height: 30,
                              ),
                              CustomButton(
                                  onPressed: () {
                                    if (customTipController.text.isNotEmpty) {
                                      setState(() {
                                        selectedTip = int.parse(
                                            customTipController.text.trim());
                                      });
                                    } else {
                                      setState(() {
                                        selectedTip = 0;
                                      });
                                    }
                                    Get.back();
                                  },
                                  text: "Confirm")
                            ],
                          ),
                        ),
                      ));
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(
                        "Other",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Text(
                "Selected amount: $selectedTip",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Obx(() => controller.isPaymentLoading.value
                  ? Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                          color: AppColors.primary, size: 45.sp),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Get.back();
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: AppColors.white,
                              padding: EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(38),
                              ),
                              side: BorderSide(color: Color(0xffE9E9F3)),
                            ),
                            child: Text(
                              "Skip",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: CustomButton(
                            onPressed: () {
                              controller.createPayment(
                                  amount: selectedTip,
                                  bookingId: widget.bookingId);
                            },
                            text: "Tip",
                          ),
                        ),
                      ],
                    ))
            ],
          ),
        ),
      ),
    );
  }

  Widget tipButton(int? amount, [String? label]) {
    bool isSelected = selectedTip == amount;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTip = amount ?? -1;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xffF4F4FF) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppColors.primary : Color(0xffE9E9F3),
          ),
        ),
        child: Text(
          label ?? "\$$amount",
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? Color(0xff736DF8) : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
