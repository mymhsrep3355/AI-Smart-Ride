import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_ride/src/modules/home_page/homepage_view.dart';
import 'package:smart_ride/src/modules/message_driver_screen/message_driver_view.dart';

import 'package:smart_ride/src/modules/ride_summary/ride_summary_view.dart';
import 'package:flutter/material.dart';

class DriverTrackingCarpoolingController extends GetxController {
  final markers = <Marker>{}.obs;
  final polylines = <Polyline>{}.obs;

  late Map<String, dynamic> driverInfo;
  late LatLng pickupLocation;
  late List<LatLng> dropoffLocations;
  late String pickupAddress;
  late List<String> dropoffAddresses;

  final rideCancelled = false.obs;
  final driverLocation = Rx<LatLng>(const LatLng(0, 0));

  GoogleMapController? mapController;
  late Timer _moveTimer;
  late Timer _endRideTimer;

  void initialize(
    Map<String, dynamic> driverData,
    LatLng pickup,
    List<LatLng> dropoffs,
    String pickupAddr,
    List<String> dropoffAddrs,
  ) {
    driverInfo = driverData;
    pickupLocation = pickup;
    dropoffLocations = dropoffs;
    pickupAddress = pickupAddr;
    dropoffAddresses = dropoffAddrs;

    driverLocation.value =
        LatLng(pickup.latitude + 0.003, pickup.longitude + 0.003);

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
    List<LatLng> fullPath = [pickupLocation, ...dropoffLocations];

    _moveTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (i >= fullPath.length) {
        timer.cancel();
        return;
      }

      driverLocation.value = fullPath[i];

      // Rebuild route from current driver position to remaining stops
      List<LatLng> remainingRoute = [driverLocation.value, ...fullPath.sublist(i + 1)];
      _setupMapData(remainingRoute);

      mapController?.animateCamera(CameraUpdate.newLatLng(driverLocation.value));
      i++;
    });
  }

  void _setupMapData(List<LatLng> routePoints) {
    final currentMarkers = <Marker>{
      Marker(
        markerId: const MarkerId('driver'),
        position: driverLocation.value,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ),
      Marker(
        markerId: const MarkerId('pickup'),
        position: pickupLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    };

    for (int i = 0; i < dropoffLocations.length; i++) {
      currentMarkers.add(
        Marker(
          markerId: MarkerId('drop_$i'),
          position: dropoffLocations[i],
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    markers.value = currentMarkers;

    polylines.value = {
      Polyline(
        polylineId: const PolylineId("route"),
        points: routePoints,
        color: Colors.blue,
        width: 5,
      ),
    };
  }

  void cancelRide() {
    rideCancelled.value = true;
    _moveTimer.cancel();
    _endRideTimer.cancel();

    Get.snackbar("Ride Cancelled", "Your ride has been cancelled.",
        backgroundColor: Colors.blueAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        icon: const Icon(Icons.cancel, color: Colors.white),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 3));

    Get.offAll(() => const HomePageView());
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

  void messageDriver() {
    Get.to(() => DriverChattingScreenView());
  }

  // void callDriver() {
  //   Get.snackbar("Calling Driver", "Calling ${driverInfo['name']}...",
  //       backgroundColor: Colors.blueAccent,
  //       colorText: Colors.white,
  //       snackPosition: SnackPosition.BOTTOM,
  //       icon: const Icon(Icons.phone_forwarded, color: Colors.white),
  //       margin: const EdgeInsets.all(16),
  //       borderRadius: 12,
  //       duration: const Duration(seconds: 2));
  // }
//     void shareRideDetails() {
//     final driverName = driverInfo['name'] ?? 'Driver';
//     final carInfo = driverInfo['car'] ?? '';
//     final phone = driverInfo['phoneNumber'] ?? '';
//     final rideId = driverInfo['rideId'] ?? 'RIDE123456';
//     final trackingURL = "https://smart-ride.app/track/$rideId";

//     final allDropoffs = dropoffAddresses.join('\n📍 ');
//     final message = '''
// 🚗 Ride Details
// Driver: $driverName
// Car: $carInfo
// Phone: $phone

// 📍 Pickup: $pickupAddress
// 📍 Drop-off: $allDropoffs

// 🔗 Track Ride: $trackingURL
// ''';

//     Get.defaultDialog(
//       title: "Share Ride Details",
//       content: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text("You can copy this message and share via any app:"),
//           const SizedBox(height: 10),
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Colors.grey[200],
//               borderRadius: BorderRadius.circular(8),
//             ),
//             constraints: const BoxConstraints(maxHeight: 200),
//             child: SingleChildScrollView(child: Text(message)),
//           ),
//           const SizedBox(height: 16),
//           ElevatedButton.icon(
//             onPressed: () {
//               Clipboard.setData(ClipboardData(text: message));
//               Get.back();
//               Get.snackbar("Copied", "Ride details copied to clipboard");
//             },
//             icon: const Icon(Icons.copy),
//             label: const Text("Copy Message"),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//           ),
//         ],
//       ),
//       confirm: TextButton(
//         onPressed: () => Get.back(),
//         child: const Text("Close"),
//       ),
//     );
//   }

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

  // void shareRideDetails() {
  //   final rideId = driverInfo['rideId'] ?? 'RIDE123456';
  //   final trackingURL = "https://smart-ride.app/track/$rideId";

  //   Get.to(() => RideShareCarpoolingView(
  //         driverInfo: Map<String, dynamic>.from(driverInfo),
  //         pickupAddress: pickupAddress,
  //         dropoffAddress: dropoffAddresses.join(", "),
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

  @override
  void onClose() {
    _moveTimer.cancel();
    _endRideTimer.cancel();
    super.onClose();
  }
}




