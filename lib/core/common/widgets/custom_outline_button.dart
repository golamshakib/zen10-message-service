import 'package:flutter/material.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';

import '../../utils/constants/app_colors.dart';
import 'custom_text.dart';

class CustomOutlineButton extends StatelessWidget {
  const CustomOutlineButton({
    super.key,
    this.text,
    this.icon,
    this.borderColor,
    this.containerWidth,
    this.containerPadding,
    required this.onPressed,
  });

  final String? text;
  final Widget? icon;
  final Color? borderColor;
  final double? containerWidth;
  final EdgeInsetsGeometry? containerPadding;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.white.withOpacity(0.5),
        onTap: onPressed,
        child: Container(
          width: containerWidth,
          padding: containerPadding ?? EdgeInsets.symmetric(vertical: 17.h, horizontal: 16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: borderColor ?? AppColors.primary),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                const SizedBox(),
                SizedBox(
                  height: 23.h,
                  width: 23.w,
                  child: icon!,
                ),
              ],
              // SizedBox(
              //   width: getWidth(12),
              // ),
              CustomText(
                text: text ?? '',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              )
            ],
          ),
        ),
      ),
    );
  }
}
