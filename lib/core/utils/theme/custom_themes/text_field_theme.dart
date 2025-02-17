import 'package:flutter/material.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';

class AppTextFormFieldTheme {
  AppTextFormFieldTheme._();

  static InputDecorationTheme _baseInputDecorationTheme({
    required Color labelColor,
    required Color hintColor,
    required Color errorColor,
    required Color focusedErrorColor,
    required Color prefixIconColor,
    required Color suffixIconColor,
    required Color borderColor,
    required Color enabledBorderColor,
    required Color focusedBorderColor,
    required Color errorBorderColor,
    required Color focusedErrorBorderColor,
  }) {
    return InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      errorMaxLines: 3,
      prefixIconColor: prefixIconColor,
      suffixIconColor: suffixIconColor,

      labelStyle: TextStyle(
          fontSize: 14.sp, color: labelColor, fontWeight: FontWeight.w500),
      hintStyle: TextStyle(
          fontSize: 14.sp, color: hintColor, fontWeight: FontWeight.w500),
      errorStyle: TextStyle(fontSize: 12.sp, color: errorColor),
      floatingLabelStyle: TextStyle(color: labelColor.withValues(alpha: 0.8)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(38.h),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(38.h),
        borderSide: BorderSide(color: enabledBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(38.h),
        borderSide: BorderSide(color: focusedBorderColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(38.h),
        borderSide: BorderSide(color: errorBorderColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(38.h),
        borderSide: BorderSide(color: focusedErrorBorderColor),
      ),
    );
  }

  static final InputDecorationTheme lightInputDecorationTheme =
      _baseInputDecorationTheme(

    labelColor: Color(0xFFB3B3B3),
    hintColor: Color(0xFFB3B3B3),
    errorColor: Colors.red,
    focusedErrorColor: Colors.orange,
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
    borderColor: Color(0xFFE9E9F3),
    enabledBorderColor: Color(0xFFE9E9F3),
    focusedBorderColor: Color(0xFFE9E9F3),
    errorBorderColor: Colors.red,
    focusedErrorBorderColor: Colors.orange,
  );

  static final InputDecorationTheme darkInputDecorationTheme =
      _baseInputDecorationTheme(
    labelColor: Colors.white,
    hintColor: Colors.white70,
    errorColor: Colors.redAccent,
    focusedErrorColor: Colors.orangeAccent,
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
    borderColor: Colors.grey,
    enabledBorderColor: Colors.grey,
    focusedBorderColor: Colors.white,
    errorBorderColor: Colors.redAccent,
    focusedErrorBorderColor: Colors.orangeAccent,
  );
}
