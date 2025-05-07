import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:traveling/core/services/Auth_service.dart';
import 'package:traveling/core/services/location.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';
import 'package:traveling/features/book_service/presentation/screens/selete_servicer.dart';

import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../authentication/controllers/location_controller.dart';
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
  late GoogleMapController mapController;
  late BitmapDescriptor customIcon;
  bool showInfo = false;
  final HomeScreenController controller = Get.find<HomeScreenController>();
  // final LocationController locationController = Get.find<LocationController>();


  @override
  void initState() {
    super.initState();
    _setCustomMarker();
    // controller.fetchUserProfile();
    // controller.fetchNearbyLocations();  // Fetch locations on init
  }

  void _setCustomMarker() async {
    customIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Default coordinates (for example, New York City)
    final LatLng defaultLocation = LatLng(40.7128, -74.006);  // New York City coordinates

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
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: defaultLocation,  // Default location (New York City)
                          zoom: 14,  // Set zoom level to 14
                        ),
                        markers: controller.markers,  // Use the markers from the controller
                        onMapCreated: (GoogleMapController controller) {
                          mapController = controller;
                        },
                      ),
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
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.all(12.h),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('We are near you!', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    SizedBox(height: 8.h),
                    Text('Would you like to book a session with us?', style: TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              CustomButton(
                  onPressed: () {
                    Get.to(() => SelectServiceView());
                  },
                  text: 'Book Now')
            ],
          ),
        ),
      ),
    );
  }
}



