import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_ride/src/modules/message_driver_screen/message_driver_view.dart';


class CarpoolingDriverArrivedController extends GetxController {
  final Map<String, dynamic> driverInfo;
  final LatLng pickupLocation;
  final List<LatLng> dropoffLocations;
  final String pickupAddress;
  final List<String> dropoffAddresses;

  CarpoolingDriverArrivedController({
    required this.driverInfo,
    required this.pickupLocation,
    required this.dropoffLocations,
    required this.pickupAddress,
    required this.dropoffAddresses,
  });

  final RxInt secondsLeft = 300.obs;
  Timer? _timer;

  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxSet<Polyline> polyLines = <Polyline>{}.obs;

  GoogleMapController? mapController;

  @override
  void onInit() {
    super.onInit();
    _setupMapData();
    _startCountdown();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _setupMapData() {
    final markerSet = <Marker>{
      Marker(
        markerId: const MarkerId('pickup'),
        position: pickupLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    };

    for (int i = 0; i < dropoffLocations.length; i++) {
      markerSet.add(
        Marker(
          markerId: MarkerId('drop_$i'),
          position: dropoffLocations[i],
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    markers.value = markerSet;

    polyLines.value = {
      Polyline(
        polylineId: const PolylineId('route'),
        points: [pickupLocation, ...dropoffLocations],
        color: Colors.blue,
        width: 5,
      ),
    };
  }

  void _startCountdown() {
    print("⏳ Countdown started");
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft.value <= 0) {
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

  void stopCountdown() {
    _timer?.cancel();
  }

  void messageDriver() {
    Get.to(() => DriverChattingScreenView());
  }

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

  // void shareRideDetails() {
  //   final rideId = driverInfo['rideId'] ?? 'RIDE123456';
  //   final trackingURL = "https://smart-ride.app/track/$rideId";

  //   Get.to(() => RideShareCarpoolingView(
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
