import 'package:flutter/material.dart';
import 'package:traveling/core/common/widgets/custom_button.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';
import 'package:traveling/features/home/controllers/profile_screen_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileScreenController controller = ProfileScreenController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Account',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 40.0),
              child: CustomButton(
                onPressed: () {
                  controller.deleteAccount();
                },
                text: 'Delete Account',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
