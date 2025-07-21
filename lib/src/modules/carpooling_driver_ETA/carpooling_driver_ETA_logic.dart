
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // ✅ Use only this LatLng

import 'package:smart_ride/src/modules/carpooling_driver_arrived/carpooling_driver_arrived_view.dart';

import 'package:smart_ride/src/modules/message_driver_screen/message_driver_view.dart';


class CarpoolingDriverETAController extends GetxController {
  final Map<String, dynamic> driverInfo;
  final LatLng driverLocation;
  final LatLng pickupLocation;
  final List<LatLng> dropoffLocations;
  final String pickupAddress;
  final List<String> dropoffAddresses;

  var secondsLeft = 10.obs;
  Timer? _timer;

  CarpoolingDriverETAController({
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
  Get.off(() => CarpoolingDriverArrivedView(
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

  // void shareRideDetails() {
  //   Get.to(() => RideShareCarpoolingView(
  //         driverInfo: Map<String, dynamic>.from(driverInfo),
  //         pickupAddress: pickupAddress,
  //         dropoffAddress: dropoffAddresses.join(", "),
  //         trackingURL: "https://www.uber.com/track/abcdef123456",
  //       ));
  // }

  // void callDriver() {
  //   Get.snackbar(
  //     "Calling",
  //     "Calling ${driverInfo['name']}...",
  //     backgroundColor: Colors.blueAccent,
  //     colorText: Colors.white,
  //     snackPosition: SnackPosition.BOTTOM,
  //     icon: const Icon(Icons.phone, color: Colors.white),
  //     margin: const EdgeInsets.all(16),
  //     borderRadius: 12,
  //     duration: const Duration(seconds: 2),
  //   );
  // }
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

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
