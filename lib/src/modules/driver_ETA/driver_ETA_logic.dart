//

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_ride/src/modules/choose_ride_carpooling/choose_ride_carpooling_view.dart';
import 'package:smart_ride/src/modules/driver_arrived/driver_arrived_view.dart';
import 'package:smart_ride/src/modules/message_driver_screen/message_driver_view.dart';
import 'package:smart_ride/src/services/url.dart';
import 'package:dio/dio.dart';
import 'package:smart_ride/src/general_controller/GeneralController.dart';
import 'package:smart_ride/src/modules/utlis/keys.dart';

class DriverETAController extends GetxController {
  final Map<String, dynamic> driverInfo;
  final LatLng driverLocation;
  final LatLng pickupLocation;
  final List<LatLng> dropoffLocations;
  final String pickupAddress;
  final List<String> dropoffAddresses;

  GoogleMapController? mapController;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  var secondsLeft = 10.obs;
  Timer? _timer;

  DriverETAController({
    required this.driverInfo,
    required this.driverLocation,
    required this.pickupLocation,
    required this.dropoffLocations,
    required this.pickupAddress,
    required this.dropoffAddresses,
  });

  @override
  void onInit() {
    super.onInit();
    _startCountdown();
    _setupMapData();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _setupMapData() {
    markers = {
      Marker(
        markerId: const MarkerId("driver"),
        position: driverLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ),
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
      }),
    };

    polylines.clear();

    // Line from driver to pickup
    polylines.add(Polyline(
      polylineId: const PolylineId("driverToPickup"),
      points: [driverLocation, pickupLocation],
      color: Colors.orange,
      width: 4,
    ));

    // Route from pickup to all drop-offs
    LatLng start = pickupLocation;
    for (int i = 0; i < dropoffLocations.length; i++) {
      final LatLng end = dropoffLocations[i];
      polylines.add(Polyline(
        polylineId: PolylineId("route$i"),
        points: [start, end],
        color: Colors.blue,
        width: 4,
      ));
      start = end;
    }
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft.value == 0) {
        timer.cancel();
        _navigateToDriverArrived();
      } else {
        secondsLeft.value--;
      }
    });
  }

  void _navigateToDriverArrived() {
    Get.off(() => DriverArrivedView(
          driverInfo: driverInfo,
          pickupLocation: pickupLocation,
          dropoffLocations: dropoffLocations,
          pickupAddress: pickupAddress,
          dropoffAddresses: dropoffAddresses,
        ));
  }

  void messageDriver() {
    Get.to(() => DriverChattingScreenView());
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

  void cancelRide() async {
    final rideId = driverInfo['rideId'] ?? '';
    if (rideId == '') {
      Get.snackbar('Error', 'Ride ID not found');
      return;
    }
    final token = Get.find<GeneralController>().box.read(AppKeys.authToken);
    if (token == null) {
      Get.snackbar('Error', 'Not authenticated');
      return;
    }
    try {
      final dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $token',
      };
      final response = await dio.post(passengerCancelRide(rideId));
      if (response.statusCode == 200 && response.data['success'] == true) {
        Get.snackbar('Cancelled', 'Your ride has been cancelled');
        // Get.offAllNamed('/');
        Get.to(() => ChooseRideCarpoolingView(
              pickupLocation: pickupLocation,
              dropoffLocations: dropoffLocations,
              pickupAddress: pickupAddress,
              dropoffAddresses: dropoffAddresses,
            ));
      } else {
        Get.snackbar(
            'Error', response.data['message'] ?? 'Failed to cancel ride');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to cancel ride');
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
