import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_ride/src/modules/ride_summary/ride_summary_logic.dart';

class RideSummaryView extends StatelessWidget {
  final Map<String, dynamic> driverInfo;
  final int fare;
  final LatLng pickupLocation;
  final List<LatLng> dropoffLocations;
  final List<String> dropoffAddresses;

  RideSummaryView({
    Key? key,
    required this.driverInfo,
    required this.fare,
    required this.pickupLocation,
    required this.dropoffLocations,
    required this.dropoffAddresses,
  }) : super(key: key);

  final RideSummaryController controller = Get.put(RideSummaryController());

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = {
      Marker(
        markerId: const MarkerId("pickup"),
        position: pickupLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      ...List.generate(dropoffLocations.length, (index) {
        return Marker(
          markerId: MarkerId("dropoff$index"),
          position: dropoffLocations[index],
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        );
      })
    };

    Polyline route = Polyline(
      polylineId: const PolylineId("route"),
      color: Colors.blue,
      width: 4,
      points: [pickupLocation, ...dropoffLocations],
    );

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: pickupLocation,
              zoom: 14,
            ),
            markers: markers,
            polylines: {route},
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
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
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                            Text(driverInfo['car']),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text("Payment : Rs $fare",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text("Rate your ride:"),
                  const SizedBox(height: 8),
                  Obx(() {
                    return Row(
                      children: List.generate(
                        5,
                        (index) => IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            index < controller.rating.value
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.orange,
                            size: 28,
                          ),
                          onPressed: () => controller.setRating(index + 1),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 10),
                  const Text("Comment:"),
                  const SizedBox(height: 6),
                  TextField(
                    controller: controller.commentController,
                    decoration: InputDecoration(
                      hintText: "Write",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: controller.submitRating,
                      child: const Text("End Ride",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
