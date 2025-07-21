import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_ride/src/modules/ride_end/ride_end_view.dart';
import 'package:flutter/services.dart';

class RideStartLogic extends GetxController {
  late final LatLng yourLocation;
  late final LatLng destinationLocation;
  
  late final String pickup;
  late final String dropoff;
  late final String riderName;
  late final String eta;
  late final String riderImage;
  late final String offeredPrice;
  late final String passengerPhone;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;

    yourLocation = args['pickupLocation'];
    destinationLocation = args['dropoffLocation'];
    pickup = args['pickup'];
    dropoff = args['dropoff'];
    riderName = args['riderName'];
    eta = args['eta'];
    riderImage = args['riderImage'];
    offeredPrice = args['offeredPrice'];
    passengerPhone = args['passengerPhone'] ?? '';
  }

  void startRide() {
    Get.snackbar(
      "Ride Started",
      "You have begun the ride.",
      backgroundColor: Colors.blueAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      icon: const Icon(Icons.directions_car, color: Colors.white),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );

    Get.to(() => RideEndView(), arguments: {
      'pickupLocation': yourLocation,
      'dropoffLocation': destinationLocation,
      'pickup': pickup,
      'dropoff': dropoff,
      'riderName': riderName,
      'riderImage': riderImage,
      'offeredPrice': offeredPrice,
      'eta': eta,
      'passengerPhone': passengerPhone,
    });
  }

  void callPassenger() {
    if (passengerPhone.isEmpty) {
      Get.snackbar("No Phone", "Passenger's number not available");
    } else {
      Get.defaultDialog(
        title: "Passenger's Phone Number",
        content: Column(
          children: [
            Text(passengerPhone, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: passengerPhone));
                Get.back();
                Get.snackbar("Copied", "Passenger's number copied to clipboard");
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
  }
}
