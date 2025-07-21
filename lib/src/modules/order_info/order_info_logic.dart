import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_ride/src/modules/message_driver_screen/message_driver_view.dart';

import 'package:smart_ride/src/modules/ride_summary/ride_summary_view.dart';

class DriverTrackingController extends GetxController {
  final Map<String, dynamic> driverInfo;
  final LatLng pickupLocation;
  final List<LatLng> dropoffLocations;
  final String pickupAddress;
  final List<String> dropoffAddresses;

  final Rx<LatLng> driverLocation = LatLng(24.8630, 67.0300).obs;
  final markers = <Marker>{}.obs;
  final polylines = <Polyline>{}.obs;

  late GoogleMapController mapController;
  late Timer _moveTimer;
  late Timer _endRideTimer;

  final rideCancelled = false.obs;

  DriverTrackingController({
    required this.driverInfo,
    required this.pickupLocation,
    required this.dropoffLocations,
    required this.pickupAddress,
    required this.dropoffAddresses,
  });

  @override
  void onInit() {
    super.onInit();
    _simulateDriverMovement();
    _endRideTimer = Timer(const Duration(seconds: 30), () {
      if (!rideCancelled.value) endRide();
    });
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _simulateDriverMovement() {
    int i = 0;
    List<LatLng> path = [pickupLocation, ...dropoffLocations];

    _moveTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (i >= path.length) {
        timer.cancel();
        return;
      }

      driverLocation.value = path[i];

      // Route from current driver location to remaining destinations
      List<LatLng> remainingRoute = [driverLocation.value, ...path.sublist(i + 1)];
      _setupMapData(remainingRoute);

      mapController.animateCamera(CameraUpdate.newLatLng(driverLocation.value));
      i++;
    });
  }

  void _setupMapData(List<LatLng> routePoints) {
    final currentMarkers = <Marker>{
      Marker(
        markerId: const MarkerId("driver"),
        position: driverLocation.value,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ),
      Marker(
        markerId: const MarkerId("pickup"),
        position: pickupLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    };

    for (int i = 0; i < dropoffLocations.length; i++) {
      currentMarkers.add(
        Marker(
          markerId: MarkerId("dropoff_$i"),
          position: dropoffLocations[i],
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    markers.value = currentMarkers;

    polylines.value = {
      Polyline(
        polylineId: const PolylineId("route"),
        color: Colors.blue,
        width: 4,
        points: routePoints,
      ),
    };
  }

  void cancelRide() {
    rideCancelled.value = true;
    _endRideTimer.cancel();
    _moveTimer.cancel();

    Get.snackbar("Ride Cancelled", "Your ride has been cancelled.",
        backgroundColor: Colors.blueAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        icon: const Icon(Icons.cancel, color: Colors.white),
        margin: const EdgeInsets.all(16),
        borderRadius: 12);

    Get.offAllNamed('/home');
  }

  void messageDriver() => Get.to(() => DriverChattingScreenView());

  void callDriver() {
    final phone = driverInfo['phoneNumber']?.toString().trim() ?? 'N/A';

    Get.defaultDialog(
      title: "Driver's Phone Number",
      content: Column(
        children: [
          const Text("You can copy this number and call manually:"),
          const SizedBox(height: 10),
          Text(
            phone,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: phone));
              Get.back();
              Get.snackbar("Copied", "Driver's number copied to clipboard");
            },
            icon: const Icon(Icons.copy),
            label: const Text("Copy Number"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ),
        ],
      ),
      confirm: TextButton(
        onPressed: () => Get.back(),
        child: const Text("Close"),
      ),
    );
  }

  void shareRideDetails() {
    final driverName = driverInfo['name'] ?? 'Driver';
    final carInfo = driverInfo['car'] ?? '';
    final phone = driverInfo['phoneNumber'] ?? '';
    final rideId = driverInfo['rideId'] ?? 'RIDE123456';
    final trackingURL = "https://smart-ride.app/track/$rideId";

    final allDropoffs = dropoffAddresses.join('\n📍 ');
    final message = '''
🚗 Ride Details
Driver: $driverName
Car: $carInfo
Phone: $phone

📍 Pickup: $pickupAddress
📍 Drop-off: $allDropoffs

🔗 Track Ride: $trackingURL
''';

    Get.defaultDialog(
      title: "Share Ride Details",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("You can copy this message and share via any app:"),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            constraints: const BoxConstraints(maxHeight: 200),
            child: SingleChildScrollView(child: Text(message)),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: message));
              Get.back();
              Get.snackbar("Copied", "Ride details copied to clipboard");
            },
            icon: const Icon(Icons.copy),
            label: const Text("Copy Message"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
        ],
      ),
      confirm: TextButton(
        onPressed: () => Get.back(),
        child: const Text("Close"),
      ),
    );
  }

  void endRide() {
    if (rideCancelled.value) return;

    Get.to(() => RideSummaryView(
          driverInfo: driverInfo,
          fare: 250,
          pickupLocation: pickupLocation,
          dropoffLocations: dropoffLocations,
          dropoffAddresses: dropoffAddresses,
        ));
  }

  @override
  void onClose() {
    if (_endRideTimer.isActive) _endRideTimer.cancel();
    _moveTimer.cancel();
    super.onClose();
  }
}
