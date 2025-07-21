
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:smart_ride/src/modules/ride_start/ride_start_view.dart';
// import 'package:flutter/services.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class UserInformationLogic extends GetxController {
//   late LatLng pickupLocation;
//   late LatLng dropoffLocation;
//   late String pickup;
//   late String dropoff;
//   late String riderName;
//   late String eta;
//   late String riderImage;
//   late String offeredPrice;
//   late String passengerPhone;

//   void goToRideStart() {
//     Get.to(() => RideStartView(), arguments: {
//       'pickup': pickup,
//       'dropoff': dropoff,
//       'pickupLocation': pickupLocation,
//       'dropoffLocation': dropoffLocation,
//       'riderName': riderName,
//       'riderImage': riderImage,
//       'offeredPrice': offeredPrice,
//       'eta': eta,
//       'passengerPhone': passengerPhone, 
//     });
//   }

//   void callPassenger() {
//     final phone = passengerPhone.trim();
//     if (phone.isEmpty) {
//       Get.snackbar("No Phone", "Passenger's number not available");
//     } else {
//       Get.defaultDialog(
//         title: "Passenger's Phone Number",
//         content: Column(
//           children: [
//             Text(phone, style: const TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//             ElevatedButton.icon(
//               onPressed: () {
//                 Clipboard.setData(ClipboardData(text: phone));
//                 Get.back();
//                 Get.snackbar("Copied", "Passenger's number copied to clipboard");
//               },
//               icon: const Icon(Icons.copy),
//               label: const Text("Copy Number"),
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//             ),
//           ],
//         ),
//         confirm: TextButton(
//           onPressed: () => Get.back(),
//           child: const Text("Close"),
//         ),
//       );
//     }
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     final args = Get.arguments as Map<String, dynamic>;
//     pickupLocation = args['driverLocation'];
//     dropoffLocation = args['passengerLocation'];
//     pickup = args['pickup'];
//     dropoff = args['dropoff'];
//     riderName = args['riderName'];
//     eta = args['eta'];
//     riderImage = args['riderImage'];
//     offeredPrice = args['offeredPrice'];
//     passengerPhone = args['passengerPhone'] ?? '';
//   }
// }
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_ride/src/modules/ride_start/ride_start_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_ride/src/modules/ride_start/ride_start_view.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import 'package:smart_ride/src/services/url.dart';
import 'package:smart_ride/src/general_controller/GeneralController.dart';
import 'package:smart_ride/src/modules/driver_homepage/driver_home_view.dart';
import 'package:smart_ride/src/modules/utlis/keys.dart';

class UserInformationLogic extends GetxController {
  late LatLng pickupLocation;
  late LatLng dropoffLocation;
  late String pickup;
  late String dropoff;
  late String riderName;
  late String eta;
  late String riderImage;
  late String offeredPrice;
  late String passengerPhone;
  late String rideId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;

    pickupLocation = args['driverLocation'] ?? const LatLng(0, 0);
    dropoffLocation = args['passengerLocation'] ?? const LatLng(0, 0);
    pickup = args['pickup'] ?? 'Not provided';
    dropoff = args['dropoff'] ?? 'Not provided';
    riderName = args['riderName'] ?? 'Unknown Rider';
    eta = args['eta'] ?? 'ETA not available';
    riderImage = args['riderImage'] ?? 'assets/images/user.jpeg';
    offeredPrice = args['offeredPrice']?.toString() ?? 'N/A';
    passengerPhone = args['passengerPhone'] ?? '';
    rideId = args['rideId'] ?? '';
  }

  void goToRideStart() async {
    if (rideId.isEmpty) {
      Get.snackbar("Error", "Ride ID not found");
      return;
    }
    final token = Get.find<GeneralController>().box.read(AppKeys.authToken);
    if (token == null) {
      Get.snackbar("Error", "Not authenticated");
      return;
    }
    try {
      final dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $token',
      };
      final response = await dio.post(driverArriveRide(rideId));
      if (response.statusCode == 200 && response.data['success'] == true) {
        Get.snackbar("Arrived", "You have arrived at the pickup location");
        Get.to(() => RideStartView(), arguments: {
          'pickup': pickup,
          'dropoff': dropoff,
          'pickupLocation': pickupLocation,
          'dropoffLocation': dropoffLocation,
          'riderName': riderName,
          'riderImage': riderImage,
          'offeredPrice': offeredPrice,
          'eta': eta,
          'passengerPhone': passengerPhone,
        });
      } else {
        Get.snackbar("Error", response.data['message'] ?? "Failed to mark as arrived");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to mark as arrived");
    }
  }

  void cancelRide() async {
    if (rideId.isEmpty) {
      Get.snackbar("Error", "Ride ID not found");
      return;
    }
    final token = Get.find<GeneralController>().box.read(AppKeys.authToken);
    if (token == null) {
      Get.snackbar("Error", "Not authenticated");
      return;
    }
    try {
      final dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $token',
      };
      final response = await dio.post(driverCancelRide(rideId));
      if (response.statusCode == 200 && response.data['success'] == true) {
        Get.snackbar("Cancelled", "Ride has been cancelled");
        Get.offAll(() => DriverHomePageView());
      } else {
        Get.snackbar("Error", response.data['message'] ?? "Failed to cancel ride");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to cancel ride");
    }
  }

  void callPassenger() {
    final phone = passengerPhone.trim();
    if (phone.isEmpty) {
      Get.snackbar("No Phone", "Passenger's number not available");
    } else {
      Get.defaultDialog(
        title: "Passenger's Phone Number",
        content: Column(
          children: [
            Text(phone, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: phone));
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
