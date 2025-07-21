

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'carpooling_driver_ETA_logic.dart';

class CarpoolingDriverETAView extends StatelessWidget {
  const CarpoolingDriverETAView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CarpoolingDriverETAController>();

    final driverInfo = controller.driverInfo;
    final driverLocation = controller.driverLocation;
    final pickupLocation = controller.pickupLocation;
    final dropoffLocations = controller.dropoffLocations;
    final pickupAddress = controller.pickupAddress;
    final dropoffAddresses = controller.dropoffAddresses;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: pickupLocation, zoom: 15),
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            markers: {
              Marker(
                markerId: const MarkerId('driver'),
                position: driverLocation,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueOrange),
              ),
              Marker(
                markerId: const MarkerId('pickup'),
                position: pickupLocation,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
              ),
              ...List.generate(
                dropoffLocations.length,
                (index) => Marker(
                  markerId: MarkerId('dropoff$index'),
                  position: dropoffLocations[index],
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                ),
              ),
            },
            polylines: {
              Polyline(
                polylineId: const PolylineId('route'),
                points: [
                  driverLocation,
                  pickupLocation,
                  ...dropoffLocations,
                ],
                color: Colors.blue,
                width: 5,
              ),
            },
          ),
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
                  const Text("Driver Information",
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
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.message, color: Colors.blue),
                            onPressed: controller.messageDriver,
                          ),
                          IconButton(
                            icon: const Icon(Icons.call, color: Colors.blue),
                            onPressed: controller.callDriver,
                          ),
                          IconButton(
                            icon: const Icon(Icons.share, color: Colors.blue),
                            onPressed: controller.shareRideDetails,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text("Ride Stops",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_pin, color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(child: Text(pickupAddress)),
                          ],
                        ),
                        ...List.generate(
                          dropoffAddresses.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                const Icon(Icons.location_pin,
                                    color: Colors.red),
                                const SizedBox(width: 8),
                                Expanded(child: Text(dropoffAddresses[index])),
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
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
  }
}
