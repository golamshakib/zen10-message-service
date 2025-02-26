import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:traveling/core/common/widgets/custom_button.dart';
import 'package:traveling/core/services/location.dart';
import 'package:traveling/core/utils/constants/app_colors.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';
import 'package:traveling/features/book_service/presentation/screens/book_service_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController mapController;
  late BitmapDescriptor customIcon;
  bool showInfo = false;

  @override
  void initState() {
    super.initState();
    _setCustomMarker();
  }

  void _setCustomMarker() async {
    customIcon = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueBlue,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final locationService = LocationService();
    final LatLng location =
        LatLng(locationService.latitude, locationService.longitude);
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 70.h,
        title: Row(
          children: [
            // CircleAvatar(
            //   radius: 30.h,
            //   backgroundImage: AssetImage(
            //       'assets/profile.jpg'), // Change this to actual image
            // ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Snow',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff333333),
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16.sp, color: Colors.grey),
                    SizedBox(width: 2.w),
                    Text(locationService.address,
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey)),
                  ],
                ),
              ],
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
              Text(
                'Currently we are in:',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff333333),
                ),
              ),
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
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: location,
                          zoom: 18,
                        ),
                        markers: {
                          Marker(
                            markerId: MarkerId('location'),
                            position: location,
                            icon: customIcon,
                            onTap: () {
                              setState(() {
                                showInfo = true;
                              });
                            },
                          ),
                        },
                        onMapCreated: (GoogleMapController controller) {
                          mapController = controller;
                        },
                      ),
                      Positioned(
                        top: 10.h,
                        right: 10.w,
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
                              SizedBox(
                                width: 4.w,
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                color: AppColors.textPrimary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (showInfo)
                        Positioned(
                          bottom: 37.h,
                          left: 20.w,
                          child: Container(
                            padding: EdgeInsets.all(8.h),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFFE9E9F3), // Border color
                                width: 1, // Border width
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x80808080),
                                  offset: Offset(0, 2),
                                  blurRadius: 3,
                                  spreadRadius: 0,
                                ),
                                BoxShadow(
                                  color: Color(0x80808080),
                                  offset: Offset(0, 6),
                                  blurRadius: 6,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Text(
                              '113 N Franklin St, Hempstead, NY 11550, USA',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textSecondary),
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
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'We are near you!',
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Would you like to book a season with us?',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              CustomButton(
                  onPressed: () {
                    Get.to(() => BookServiceView());
                  },
                  text: 'Book Now')
            ],
          ),
        ),
      ),
    );
  }
}
