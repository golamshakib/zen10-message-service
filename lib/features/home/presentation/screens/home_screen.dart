import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:traveling/core/services/Auth_service.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';
import 'package:traveling/features/notification/presentation/view/notification_screen.dart';

import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../controllers/home_controller.dart';
import '../widgets/disable_button.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
                Get.to(() => NotificationScreen());
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Currently we are in:',
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff333333))),
                SizedBox(height: 8.h),
                Obx(() {
                  // Check if the upcoming locations list has been fetched
                  if (controller.nearbyLocations.isNotEmpty) {
                    final locationsToShow = controller.nearbyLocations.take(2).toList();
        
                    return Wrap(
                      alignment: WrapAlignment.start,  // Align children to the start
                      spacing: 8.0,                    // Space between locations
                      runSpacing: 4.0,                 // Space between wrapped lines
                      children: locationsToShow.asMap().entries.map((entry) {
                        int index = entry.key;
                        var location = entry.value;
                        String locationName = location['location'] ?? 'Unknown Location';
        
                        List<Widget> widgets = [
                          Flexible(
                            child: Text(
                              locationName,
                              style: TextStyle(
                                fontSize: 16.sp, // Responsive font size
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                overflow: TextOverflow.ellipsis,  // Handle long text gracefully
                              ),
                              maxLines: 1,  // Ensure that text doesn't exceed 1 line if possible
                            ),
                          ),
                        ];
        
                        if (index < locationsToShow.length - 1) {
                          widgets.add(
                            Flexible(
                              child: Text(
                                ' and ',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Color(0xff333333),
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          );
                        }
        
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: widgets,
                        );
                      }).toList(),
                    );
                  } else {
                    return Text(
                      'Out of zone',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }
                }),
        
                SizedBox(height: 16.h),
                SizedBox(
                  height: 370.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.h),
                    child: Stack(
                      children: [
                        Obx(() {
                          final userLatitude = controller.currentLatitude.value != 0.0
                              ? controller.currentLatitude.value
                              : (controller.userProfile.value?.data.locationLatitude ?? 40.7128);
        
                          final userLongitude = controller.currentLongitude.value != 0.0
                              ? controller.currentLongitude.value
                              : (controller.userProfile.value?.data.locationLongitude ?? -74.0060);
        
                          if (controller.isLoading.value || controller.isLocationLoading.value || controller.isRefreshing.value) {
                            return Center(
                              child: LoadingAnimationWidget.staggeredDotsWave(
                                color: AppColors.primary,
                                size: 30.sp, // Adjust size as needed
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
                              Future.delayed(Duration(milliseconds: 500), () {
                                if (controller.markers.isEmpty) {
                                  controller.fetchNearbyLocations();
                                }
                              });
                            },
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                            compassEnabled: true,
                            zoomControlsEnabled: true,
                          );
                        }),
        
                        // Refresh Button to trigger the refresh and loading animation
                        Positioned(
                          bottom: 16.h,
                          left: 16.w,
                          child: FloatingActionButton(
                            backgroundColor: Colors.white.withOpacity(0.8),
                            child: Obx(() {
                              return controller.isRefreshing.value
                                  ? LoadingAnimationWidget.staggeredDotsWave(
                                color: AppColors.primary,
                                size: 20.sp, // Adjust size of the loading animation
                              )
                                  : Icon(Icons.refresh, color: AppColors.primary);
                            }),
                            onPressed: () async {
                              await controller.refreshLocation();
        
                              // Force the map to rebuild with updated markers
                              setState(() {});
                            },
                          ),
                        ),
        
                        // Upcoming Button
                        Positioned(
                          top: 10.h,
                          right: 50.w,
                          child: GestureDetector(
                            onTap: controller.toggleUpcoming,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
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
                                  Icon(Icons.arrow_drop_down, color: AppColors.textPrimary),
                                ],
                              ),
                            ),
                          ),
                        ),
        
                        // Upcoming Events List
                        Positioned(
                          top: 60.h,
                          left: 10.w,
                          right: 10.w,
                          child: Obx(() {
                            if (controller.showUpcoming.value) {
                              return Container(
                                height: 300.h,
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
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      controller.upcomingLocations.isEmpty
                                          ? Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                                        child: Text('No Upcoming event found',
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.textPrimary)),
                                      )
                                          : ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: controller.upcomingLocations.length,
                                        itemBuilder: (context, index) {
                                          final upcomingLocation = controller.upcomingLocations[index];
        
                                          return GestureDetector(
                                            onTap: () {
                                              // Handle event click by passing the selected event to the Book Now screen
                                              controller.handleUpcomingEventClick(controller.upcomingLocations[index]);
                                            },
                                            child: ListTile(
                                              title: Text(
                                                formatDate(upcomingLocation.date),
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                              subtitle: Text(
                                                getDayRange(upcomingLocation.startTime, upcomingLocation.endTime),
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.textSecondary,
                                                ),
                                              ),
                                              trailing: Container(
                                                width: 100, // Set a fixed width for the trailing widget
                                                child: Text(
                                                  upcomingLocation.location,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.textPrimary,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          }),
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
                    // Check if a location is selected
                    if (controller.currentLatitude.value == 0.0 || controller.currentLongitude.value == 0.0) {
                      Get.snackbar(
                        "Location not selected",
                        "Please select your location before proceeding.",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    } else {
                      controller.navigateToSelectService();
                    }
                  },
                  text: 'Book Now',
                )
                    : buildDisabledButton()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
