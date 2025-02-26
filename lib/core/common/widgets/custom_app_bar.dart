import 'package:flutter/material.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';

import '../../utils/constants/app_colors.dart';

class CustomAppBar extends StatelessWidget {
  final VoidCallback onTap;
  final String? text;
  final double? spaceBetween;

  const CustomAppBar({
    super.key,
    required this.onTap,
     this.text,
    this.spaceBetween,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onDoubleTap: onTap,
          child: Container(
            padding: EdgeInsets.all(10.h),
            decoration: BoxDecoration(
              color: Color(0xffF0F0F0),
              borderRadius: BorderRadius.circular(22.h),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_outlined,
              size: 20.sp,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(width: spaceBetween ?? 16.w),
        Text(
          text??"",
          style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary),
        )
      ],
    );
  }
}