
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_ride/src/modules/order_info_carpooling/order_info_carpooling_logic.dart';
import 'package:smart_ride/src/modules/utlis/app_colors.dart';

class DriverTrackingCarpoolingView extends StatelessWidget {
  final Map<String, dynamic> driverInfo;
  final LatLng pickupLocation;
  final List<LatLng> dropoffLocations;
  final String pickupAddress;
  final List<String> dropoffAddresses;

  const DriverTrackingCarpoolingView({
    super.key,
    required this.driverInfo,
    required this.pickupLocation,
    required this.dropoffLocations,
    required this.pickupAddress,
    required this.dropoffAddresses,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DriverTrackingCarpoolingController());
    controller.initialize(
      driverInfo,
      pickupLocation,
      dropoffLocations,
      pickupAddress,
      dropoffAddresses,
    );

    return Scaffold(
      body: Obx(() => Stack(
            children: [
              GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: pickupLocation, zoom: 14),
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                markers: controller.markers.value,
                polylines: controller.polylines.value,
                onMapCreated: controller.onMapCreated,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Ride In Progress",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
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
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                Text(driverInfo['car'],
                                    style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                          IconButton(
                              icon: const Icon(Icons.message,
                                  color: AppColors.primary),
                              onPressed: controller.messageDriver),
                          IconButton(
                              icon: const Icon(Icons.call,
                                  color: AppColors.primary),
                              onPressed: controller.callDriver),
                          IconButton(
                              icon: const Icon(Icons.share,
                                  color: AppColors.primary),
                              onPressed: controller.shareRideDetails),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text("Route Stops",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
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
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: controller.cancelRide,
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
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
