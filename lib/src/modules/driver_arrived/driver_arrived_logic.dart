import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../message_driver_screen/message_driver_view.dart';

import 'package:dio/dio.dart';
import 'package:smart_ride/src/general_controller/GeneralController.dart';
import 'package:smart_ride/src/modules/utlis/keys.dart';
import 'package:smart_ride/src/services/url.dart';


class DriverArrivedController extends GetxController {
  final Map<String, dynamic> driverInfo;
  final LatLng pickupLocation;
  final List<LatLng> dropoffLocations;
  final String pickupAddress;
  final List<String> dropoffAddresses;

  GoogleMapController? mapController;
  Set<Marker> markers = {};
  late Polyline routePolyline;
  var secondsLeft = 300.obs;
  Timer? _timer;

  DriverArrivedController({
    required this.driverInfo,
    required this.pickupLocation,
    required this.dropoffLocations,
    required this.pickupAddress,
    required this.dropoffAddresses,
  });

  @override
  void onInit() {
    super.onInit();
    _setupMap();
    _startCountdown();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void stopCountdown() {
    _timer?.cancel();
  }

  void _setupMap() {
    markers = {
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

    routePolyline = Polyline(
      polylineId: const PolylineId("route"),
      color: Colors.blue,
      width: 4,
      points: [pickupLocation, ...dropoffLocations],
    );
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft.value == 0) {
        timer.cancel();
        Get.snackbar("Timeout", "Your ride may be canceled soon.",
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP);
      } else {
        secondsLeft.value--;
      }
    });
  }


  void messageDriver() {
    Get.to(() => DriverChattingScreenView());
  }

  // void shareRideDetails() {
  //   final driverName = driverInfo['name'] ?? 'Driver';
  //   final carInfo = driverInfo['car'] ?? '';
  //   final phone = driverInfo['phoneNumber'] ?? '';
  //   final rideId = driverInfo['rideId'] ?? 'RIDE123456';
  //   final trackingURL = "https://smart-ride.app/track/$rideId";

  //   Get.to(() => RideShareView(
  //         driverInfo: driverInfo,
  //         pickupAddress: pickupAddress,
  //         dropoffAddress: dropoffAddresses.join(', '),
  //         trackingURL: trackingURL,
  //       ));
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
    final phone = driverInfo['phoneNumber']?.toString().trim() ?? '';
    if (phone.isEmpty) {
      Get.snackbar("No Phone", "Driver's number not available");
    } else {
      Get.defaultDialog(
        title: "Driver's Phone Number",
        content: Column(
          children: [
            Text(phone, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
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
  }

  Future<void> markDriverArrived() async {
  final token = Get.find<GeneralController>().box.read(AppKeys.authToken);
  final rideId = driverInfo['rideId'];

  if (token == null || rideId == null) {
    Get.snackbar("Error", "Missing auth token or ride ID",
        backgroundColor: Colors.red, colorText: Colors.white);
    return;
  }

  final dio = Dio();
  dio.options.headers = {
    'Authorization': 'Bearer $token',
  };

  try {
    final response = await dio.post(driverArriveRide(rideId)); // uses url.dart

    if (response.statusCode == 200 && response.data['success'] == true) {
      Get.snackbar("Success", "Marked as arrived",
          backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar("Failed", response.data['message'] ?? "Something went wrong",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  } catch (e) {
    print("🚨 Error marking as arrived: $e");
    Get.snackbar("Error", "Network error or unexpected issue",
        backgroundColor: Colors.red, colorText: Colors.white);
  }
}
  Future<void> markPassengerComing() async {
    final token = Get.find<GeneralController>().box.read(AppKeys.authToken);
    final rideId = driverInfo['rideId'];

    if (token == null || rideId == null) {
      Get.snackbar("Error", "Missing auth token or ride ID",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final dio = Dio();
    dio.options.headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await dio.post(passengerComingRide(rideId)); // uses url.dart

      if (response.statusCode == 200 && response.data['success'] == true) {
        Get.snackbar("Success", "You have confirmed you are coming",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Failed", response.data['message'] ?? "Something went wrong",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print("🚨 Error marking passenger coming: $e");
      Get.snackbar("Error", "Network error or unexpected issue",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
