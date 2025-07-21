import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_ride/src/modules/choose_ride/choose_ride_view.dart';

import 'package:smart_ride/src/modules/order_info/order_info_view.dart';
import 'driver_arrived_logic.dart';
import 'package:smart_ride/src/modules/utlis/app_colors.dart';

class DriverArrivedView extends StatelessWidget {
  final Map<String, dynamic> driverInfo;
  final LatLng pickupLocation;
  final List<LatLng> dropoffLocations;
  final String pickupAddress;
  final List<String> dropoffAddresses;

  const DriverArrivedView({
    Key? key,
    required this.driverInfo,
    required this.pickupLocation,
    required this.dropoffLocations,
    required this.pickupAddress,
    required this.dropoffAddresses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverArrivedController>(
      init: DriverArrivedController(
        driverInfo: driverInfo,
        pickupLocation: pickupLocation,
        dropoffLocations: dropoffLocations,
        pickupAddress: pickupAddress,
        dropoffAddresses: dropoffAddresses,
      ),
      builder: (controller) {
        return Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: pickupLocation,
                  zoom: 15,
                ),
                markers: controller.markers,
                polylines: {controller.routePolyline},
                onMapCreated: controller.onMapCreated,
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                AssetImage("assets/images/driver.jpeg"),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(driverInfo['name'] ?? '',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                Text(driverInfo['car'] ?? '',
                                    style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.message,
                                color: AppColors.primary),
                            onPressed: controller.messageDriver,
                          ),
                          IconButton(
                            icon: const Icon(Icons.call,
                                color: AppColors.primary),
                            onPressed: controller.callDriver,
                          ),
                          IconButton(
                            icon: const Icon(Icons.share,
                                color: AppColors.primary),
                            onPressed: controller.shareRideDetails,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              const Icon(Icons.location_pin,
                                  color: Colors.orange),
                              const SizedBox(width: 8),
                              Expanded(child: Text(pickupAddress)),
                            ]),
                            const SizedBox(height: 8),
                            for (int i = 0; i < dropoffAddresses.length; i++)
                              Row(children: [
                                const Icon(Icons.location_pin,
                                    color: Colors.blue),
                                const SizedBox(width: 8),
                                Expanded(child: Text(dropoffAddresses[i])),
                              ]),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Obx(() {
                        final minutes = (controller.secondsLeft.value ~/ 60)
                            .toString()
                            .padLeft(2, '0');
                        final seconds = (controller.secondsLeft.value % 60)
                            .toString()
                            .padLeft(2, '0');
                        return Text("$minutes:$seconds",
                            style: const TextStyle(
                                fontSize: 18, color: Colors.red));
                      }),
                      const SizedBox(height: 12),
                      const Text(
                        "Driver has arrived at the pickup point",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Get.to(() => ChooseRideView(
                                    pickupLocation: pickupLocation,
                                    dropoffLocations: dropoffLocations,
                                    pickupAddress: pickupAddress,
                                    dropoffAddresses: dropoffAddresses,
                                  ));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              child: Text("Cancel",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          ElevatedButton(
                            // onPressed: () {
                            //   controller.stopCountdown(); // ⛔ Stop the timer
                            //   Get.off(() => DriverTrackingView(
                            //         driverInfo: driverInfo,
                            //         pickupLocation: pickupLocation,
                            //         dropoffLocations: dropoffLocations,
                            //         pickupAddress: pickupAddress,
                            //         dropoffAddresses: dropoffAddresses,
                            //       ));
                            // },
                            onPressed: () async {
                              await controller.markPassengerComing();
                              controller.stopCountdown();
                              Get.off(() => DriverTrackingView(
                                    driverInfo: driverInfo,
                                    pickupLocation: pickupLocation,
                                    dropoffLocations: dropoffLocations,
                                    pickupAddress: pickupAddress,
                                    dropoffAddresses: dropoffAddresses,
                                  ));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              child: Text("OK, Coming",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
