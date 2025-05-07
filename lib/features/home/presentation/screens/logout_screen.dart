import 'package:flutter/material.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';

import '../../../../core/services/Auth_service.dart';
import '../../../../core/utils/constants/icon_path.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            SizedBox(height: 100.h),

            InkWell(
              onTap: () async {
                await AuthService.logoutUser();

              },
              child: Row(
                children: [
                  Image.asset(
                    IconPath.logout,
                    height: 20.h,
                    width: 20.w,
                  ),
                  SizedBox(width: 13.w),
                  Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff333333),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
