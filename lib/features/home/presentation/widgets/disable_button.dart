import 'package:flutter/material.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';

Widget buildDisabledButton() {
  return Container(
    alignment: Alignment.center,
    width: double.maxFinite,
    padding: EdgeInsets.symmetric(
      vertical: 13.h,
    ),
    decoration: BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(38.h),
    ),
    child: Text(
      'Book Now',
      style: TextStyle(
        color: Colors.grey[600],
        fontWeight: FontWeight.w700,
        fontSize: 16.sp,
      ),
    ),
  );
}