import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:traveling/core/utils/constants/app_colors.dart';
import 'package:traveling/features/Tip/presentation/screens/tip.dart';

class CustomNotificationCard extends StatelessWidget {
  const CustomNotificationCard(
      {super.key,
        required this.title,
        required this.bookingID,
        required this.body,
        required this.createdAT,
        required this.username,
        this.tip});

  final String bookingID;
  final String title;
  final String body;
  final String createdAT;
  final String username;
  final String? tip;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (title.contains('Completed')) {
          Get.to(() => TipsScreen(
            bookingId: bookingID,
            userName: username,
          ));
        }
      },
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: AppColors.primary)),
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                formatFireDate(createdAT),
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (title.contains('Completed'))
                    TextButton(
                      onPressed: () {
                        Get.to(() => TipsScreen(
                          bookingId: bookingID,
                          userName: username,
                        ));
                      },
                      child: Text('Tip', style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                ],
              ),
            ],
          ),
          subtitle: Text(
            body,
            style: TextStyle(),
          ),
        ),
      ),
    );
  }

  String formatFireDate(String utcDateTime) {
    try {
      if (utcDateTime.isEmpty) return "N/A";
      final dateTime = DateTime.parse(utcDateTime).toLocal();
      final formatter = DateFormat('EEEE, MMM d, h:mm a');
      return formatter.format(dateTime);
    } catch (e) {
      return 'Invalid date';
    }
  }
}
