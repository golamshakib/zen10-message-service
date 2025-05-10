import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:traveling/core/services/Auth_service.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';


import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../controllers/home_controller.dart';
import 'helper_function/helper_function.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key}) {
    AuthService.init();
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? mapController;
  final HomeScreenController controller = Get.find<HomeScreenController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(
                        controller.userProfile.value == null
                            ? 'Loading...'
                            : controller.userProfile.value!.data.userName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff333333)),
                      )),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16.sp, color: Colors.grey),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Obx(() => Text(
                              controller.userProfile.value == null
                                  ? 'Loading...'
                                  : controller.userProfile.value!.data.location,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                // navigate to Notification Screen
              },
              child: Image.asset(
                IconPath.notification,
                height: 24.h,
                width: 24.w,
                color: Colors.red.shade300,
              ),
            ),
            SizedBox(width: 13.w),
            InkWell(
              onTap: () async {
                AuthService.logoutUser();
              },
              child: Image.asset(
                IconPath.logout,
                height: 20.h,
                width: 20.w,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16.h, right: 16.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              Text('Currently we are in:',
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff333333))),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Text('Chicago',
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600)),
                  Text(' and ',
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: Color(0xff333333),
                          fontWeight: FontWeight.w600)),
                  Text('New-York',
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              SizedBox(height: 4.h),
              Text('Mon-Fri: 9am to 5pm',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 16.h),
              SizedBox(
                height: 370.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.h),
                  child: Stack(
                    children: [
                      Obx(() {
                        final userLatitude = controller
                                .userProfile.value?.data.locationLatitude ??
                            40.7128;
                        final userLongitude = controller
                                .userProfile.value?.data.locationLongitude ??
                            -74.0060;

                        if (controller.isLoading.value) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                    color: AppColors.primary),
                                SizedBox(height: 16.h),
                                Text('Loading map and locations...',
                                    style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          );
                        }

                        return GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(userLatitude, userLongitude),
                            zoom: 14,
                          ),
                          markers: controller.markers,
                          onMapCreated: (GoogleMapController mapCtrl) {
                            mapController = mapCtrl;
                            // Force a small delay and then check if we need to refresh markers
                            Future.delayed(Duration(milliseconds: 500), () {
                              if (controller.markers.isEmpty) {
                                controller.fetchNearbyLocations();
                              }
                            });
                          },
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          compassEnabled: true,
                        );
                      }),

                      Positioned(
                        top: 10.h,
                        right: 50.w,
                        child: GestureDetector(
                          onTap: controller.toggleUpcoming,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 9.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 5)
                              ],
                            ),
                            child: Row(
                              children: [
                                Text('Upcoming',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16.sp,
                                        color: AppColors.textPrimary)),
                                SizedBox(width: 4.w),
                                Icon(Icons.arrow_drop_down,
                                    color: AppColors.textPrimary),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Upcoming Locations List positioned just below the Upcoming Button
                      Positioned(
                        top: 60.h, // Adjust this to position below the button
                        left: 10.w,
                        right: 10.w,
                        child: Obx(() {
                          if (controller.showUpcoming.value) {
                            if (controller.upcomingLocations.isEmpty) {
                              return Text('No Upcoming event found');
                            }
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.h),
                                border: Border.all(
                                  color: Color(0xFFE9E9F3),
                                  width: 1.0,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF808080).withOpacity(0.1),
                                    offset: Offset(0, 4),
                                    blurRadius: 9,
                                    spreadRadius: 0,
                                  ),
                                  BoxShadow(
                                    color: Color(0xFF808080).withOpacity(0.1),
                                    offset: Offset(0, 17),
                                    blurRadius: 17,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      controller.upcomingLocations.length,
                                  itemBuilder: (context, index) {
                                    final upcomingLocation =
                                        controller.upcomingLocations[index];
                                    return ListTile(
                                      title: Text(
                                        formatDate(upcomingLocation.date),
                                        // Format date as May 20
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      subtitle: Text(
                                        getDayRange(upcomingLocation.startTime,
                                            upcomingLocation.endTime),
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      trailing: Text(
                                        upcomingLocation.location,
                                       // 'asdfljadslf jdlfjlkdsjf lkdsjf lkdsfl dslkf jlkdjfl ',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        }),
                      ),
                      // Add a refresh button to manually refresh markers
                      Positioned(
                        bottom: 16.h,
                        left: 16.w,
                        child: FloatingActionButton.small(
                          backgroundColor: Colors.white.withOpacity(0.8),
                          child: Icon(Icons.refresh, color: AppColors.primary),
                          onPressed: () {
                            controller.fetchNearbyLocations();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Obx(() => Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.all(12.h),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            controller.isInServiceZone.value
                                ? 'We are near you!'
                                : 'Out of zone 😢',
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary)),
                        SizedBox(height: 8.h),
                        Text(
                            controller.isInServiceZone.value
                                ? 'Would you like to book a session with us?'
                                : 'We will notify you as soon as we are in your area.',
                            style: TextStyle(color: AppColors.textSecondary)),
                      ],
                    ),
                  )),
              SizedBox(height: 16.h),
              Obx(() => controller.isInServiceZone.value
                  ? CustomButton(
                      onPressed: () {
                        // Use the new navigation method that checks for selected location
                        controller.navigateToSelectService();
                      },
                      text: 'Book Now',
                    )
                  : _buildDisabledButton()),
            ],
          ),
        ),
      ),
    );
  }

  // Custom disabled button that matches the style of CustomButton but with gray colors
  Widget _buildDisabledButton() {
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

}
