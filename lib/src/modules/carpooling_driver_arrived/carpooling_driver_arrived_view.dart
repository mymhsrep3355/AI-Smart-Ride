import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_ride/src/modules/carpooling_driver_arrived/carpooling_driver_arrived_logic.dart';
import 'package:smart_ride/src/modules/choose_ride_carpooling/choose_ride_carpooling_view.dart';

import 'package:smart_ride/src/modules/order_info_carpooling/order_info_carpooling_view.dart';
import 'package:smart_ride/src/modules/utlis/app_colors.dart';

class CarpoolingDriverArrivedView extends StatelessWidget {
  final Map<String, dynamic> driverInfo;
  final LatLng pickupLocation;
  final List<LatLng> dropoffLocations;
  final String pickupAddress;
  final List<String> dropoffAddresses;

  const CarpoolingDriverArrivedView({
    Key? key,
    required this.driverInfo,
    required this.pickupLocation,
    required this.dropoffLocations,
    required this.pickupAddress,
    required this.dropoffAddresses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Get.isRegistered<CarpoolingDriverArrivedController>()) {
      Get.delete<CarpoolingDriverArrivedController>();
    }

    final controller = Get.put(CarpoolingDriverArrivedController(
      driverInfo: driverInfo,
      pickupLocation: pickupLocation,
      dropoffLocations: dropoffLocations,
      pickupAddress: pickupAddress,
      dropoffAddresses: dropoffAddresses,
    ));

    return Scaffold(
      body: Stack(
        children: [
          Obx(() => GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: pickupLocation, zoom: 14),
                markers: controller.markers.toSet(),
                polylines: controller.polyLines.toSet(),
                onMapCreated: controller.onMapCreated,
                myLocationEnabled: true,
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Driver Arrived",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
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
                            Text(driverInfo['name'],
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                            Text(driverInfo['car'],
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
                  const Text("Pickup & Drop-off",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_pin,
                                color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(child: Text(pickupAddress)),
                          ],
                        ),
                        ...List.generate(
                          dropoffAddresses.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                const Icon(Icons.location_pin,
                                    color: Colors.red),
                                const SizedBox(width: 8),
                                Expanded(
                                    child: Text(dropoffAddresses[index])),
                              ],
                            ),
                          ),
                        ),
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
                        style: const TextStyle(fontSize: 18, color: Colors.red));
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          controller.stopCountdown();
                          Get.to(() => ChooseRideCarpoolingView(
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
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          controller.stopCountdown();
                          Get.off(() => DriverTrackingCarpoolingView(
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
                          child: Text("OK Coming",
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
  }
}
