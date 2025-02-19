import 'package:flutter/material.dart';
import 'package:traveling/core/common/widgets/custom_button.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/logos/img.png', // Replace with your logo asset path
              width: 55.w,
              height: 44.h,
            ),
            SizedBox(
                height: 20.h), // Add some spacing between the logo and text
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(38.h),
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter your phone number/ email',
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: 13.h,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF736DF8),
                    Color(0xFF4F4BF7)
                  ], // Colors from Figma
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(38.h),
              ),
              child: Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
