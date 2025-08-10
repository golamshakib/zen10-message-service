import 'package:flutter/material.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final Widget? suffixIcon;
  final bool readOnly;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.suffixIcon,
    this.readOnly = false,
    this.keyboardType,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(38.h),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        readOnly: readOnly,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
