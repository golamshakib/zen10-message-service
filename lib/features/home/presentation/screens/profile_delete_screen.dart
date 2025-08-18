import 'package:flutter/material.dart';
import 'package:traveling/core/common/widgets/custom_button.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';
import 'package:traveling/features/home/controllers/profile_delete_controller.dart';

class ProfileDeleteScreen extends StatelessWidget {
  const ProfileDeleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileDeleteController controller = ProfileDeleteController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Account',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 30),
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
