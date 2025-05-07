import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:traveling/core/services/Auth_service.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';
import 'package:traveling/features/book_service/presentation/screens/selete_servicer.dart';

import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../controllers/home_controller.dart';
import 'logout_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key}){
    AuthService.init();
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? mapController;
  final HomeScreenController controller = Get.find<HomeScreenController>();

  @override
  void initState() {
    super.initState();
    // No need to call these here as they're already called in controller's onInit
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Get.to(() => const LogoutScreen());
          },
          child: Row(
            children: [
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(
                    controller.userProfile.value == null
                        ? 'Loading...'
                        : controller.userProfile.value!.data.userName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Color(0xff333333)),
                  )),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16.sp, color: Colors.grey),
                      SizedBox(width: 2.w),
                      Obx(() => Text(
                        controller.userProfile.value == null
                            ? 'Loading...'
                            : controller.userProfile.value!.data.location,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.grey),
                      )),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16.h, right: 16.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              Text('Currently we are in:', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: Color(0xff333333))),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Text('Chicago', style: TextStyle(fontSize: 16.sp, color: AppColors.primary, fontWeight: FontWeight.w600)),
                  Text(' and ', style: TextStyle(fontSize: 16.sp, color: Color(0xff333333), fontWeight: FontWeight.w600)),
                  Text('New-York', style: TextStyle(fontSize: 16.sp, color: AppColors.primary, fontWeight: FontWeight.w600)),
                ],
              ),
              SizedBox(height: 4.h),
              Text('Mon-Fri: 9am to 5pm', style: TextStyle(color: Colors.grey, fontSize: 16.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 16.h),
              SizedBox(
                height: 370.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.h),
                  child: Stack(
                    children: [
                      Obx(() {
                        final userLatitude = controller.userProfile.value?.data.locationLatitude ?? 40.7128;
                        final userLongitude = controller.userProfile.value?.data.locationLongitude ?? -74.0060;

                        if (controller.isLoading.value) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(color: AppColors.primary),
                                SizedBox(height: 16.h),
                                Text('Loading map and locations...',
                                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))
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
                        right: 10.w,
                        child: GestureDetector(
                          onTap: controller.toggleUpcoming,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                            ),
                            child: Row(
                              children: [
                                Text('Upcoming', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.sp, color: AppColors.textPrimary)),
                                SizedBox(width: 4.w),
                                Icon(Icons.arrow_drop_down, color: AppColors.textPrimary),
                              ],
                            ),
                          ),
                        ),
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
                    borderRadius: BorderRadius.circular(8)
                ),
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
                            color: AppColors.textPrimary
                        )
                    ),
                    SizedBox(height: 8.h),
                    Text(
                        controller.isInServiceZone.value
                            ? 'Would you like to book a session with us?'
                            : 'We will notify you as soon as we are in your area.',
                        style: TextStyle(color: AppColors.textSecondary)
                    ),
                  ],
                ),
              )),
              SizedBox(height: 16.h),
              Obx(() => controller.isInServiceZone.value
                  ? CustomButton(
                onPressed: () {
                  Get.to(() => SelectServiceView());
                },
                text: 'Book Now',
              )
                  : _buildDisabledButton()
              )
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
