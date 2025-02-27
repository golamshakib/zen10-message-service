import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveling/core/common/widgets/custom_app_bar.dart';
import 'package:traveling/core/common/widgets/custom_button.dart';
import 'package:traveling/core/utils/constants/app_colors.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';
import 'package:traveling/core/utils/constants/icon_path.dart';
import 'package:traveling/features/Confirmation/presentation/screens/confirmation.dart';

class PaymentMethodScreen extends StatefulWidget {
  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String selectedPayment = "PayPal";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 72, bottom: 30.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(
              onTap: () {
                Get.back();
              },
              text: "payment Method",
            ),
            SizedBox(
              height: 50.h,
            ),
            paymentOption(
              title: "Paypal",
              assetImage: IconPath.payPal,
              lastDigits: "43",
              selected: selectedPayment == "PayPal",
              onSelect: () {
                setState(() {
                  selectedPayment = "PayPal";
                });
              },
            ),
            SizedBox(height: 16.h),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Color(0xffE9E9F3),
                  width: 1,
                ),
                color: Color(0xffFFFFFF),
              ),
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Image.asset(IconPath.zelle, width: 44, height: 44),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Zelle",
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            CustomButton(
                onPressed: () {
                  Get.to(() => BookingConfirmed());
                },
                text: "Pay & Book Now")
          ],
        ),
      ),
    );
  }

  Widget paymentOption({
    required String title,
    required String assetImage,
    String? lastDigits,
    required bool selected,
    required VoidCallback onSelect,
  }) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? Color(0xff736DF8) : Colors.transparent,
            width: 1,
          ),
          color: Color(0xffF4F4FF),
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(assetImage, width: 44, height: 44),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12.h,
            ),
            Divider(
              color: Colors.white,
            ),
            SizedBox(
              height: 6.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "**** **** **43",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary),
                ),
                IconButton(
                  icon:
                      Icon(Icons.delete, size: 20.sp, color: Color(0xff757575)),
                  onPressed: () {},
                ),
              ],
            ),
            Text(
              "Add new Card",
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.solid,
                  color: Color(0xff002BFF),
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
