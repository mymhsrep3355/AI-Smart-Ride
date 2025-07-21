import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_ride/src/modules/driver_ETA/driver_ETA_logic.dart';
import 'package:smart_ride/src/modules/utlis/app_colors.dart';

class DriverETAView extends StatelessWidget {
  final Map<String, dynamic> driverInfo;
  final LatLng driverLocation;
  final LatLng pickupLocation;
  final List<LatLng> dropoffLocations;
  final String pickupAddress;
  final List<String> dropoffAddresses;

  const DriverETAView({
    super.key,
    required this.driverInfo,
    required this.driverLocation,
    required this.pickupLocation,
    required this.dropoffLocations,
    required this.pickupAddress,
    required this.dropoffAddresses,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverETAController>(
      init: DriverETAController(
        driverInfo: driverInfo,
        driverLocation: driverLocation,
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
                  zoom: 14,
                ),
                markers: controller.markers,
                polylines: controller.polylines,
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
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: driverInfo['profileImage'] != ''
                                ? NetworkImage(
                                    'http://192.168.10.13:3000${driverInfo['profileImage']}')
                                : const AssetImage("assets/images/driver.jpeg")
                                    as ImageProvider,
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
                                Text(
                                  "Vehicle: ${driverInfo['car']} - ${driverInfo['brand']} ${driverInfo['model']} (${driverInfo['color']})",
                                  style: const TextStyle(fontSize: 14),
                                ),
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
          ),
        );
      },
    );
  }
}
