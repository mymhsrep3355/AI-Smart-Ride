import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smart_ride/src/modules/accept_ride/accept_ride_view.dart';
import 'package:smart_ride/src/modules/driver_homepage/driver_home_logic.dart';
import 'package:dio/dio.dart';
import 'package:smart_ride/src/services/url.dart';
import 'package:smart_ride/src/general_controller/GeneralController.dart';
import 'package:smart_ride/src/modules/utlis/keys.dart';

class DriverActiveRequestLogic extends GetxController {
  var activeRide = Rxn<Ride>();
  final priceController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map?;
    if (args != null && args['ride'] != null) {
      activeRide.value = args['ride'] as Ride;
      // Optionally store fareAmountDriver if needed:
      // final fareAmountDriver = args['fareAmountDriver'];
    }
  }

  void onNextStepPressed() async {
    final offeredPrice = priceController.text.trim();

    if (offeredPrice.isEmpty) {
      Get.snackbar("Error", "Please enter a price",
          backgroundColor: Colors.blueAccent, colorText: Colors.white);
      return;
    }

    final ride = activeRide.value;
    if (ride == null) return;

    final token = Get.find<GeneralController>().box.read(AppKeys.authToken);
    if (token == null) {
      Get.snackbar("Error", "Driver not authenticated",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      final dioClient = Dio();
      dioClient.options.headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await dioClient.post(
        acceptRideURL(ride.id), // ✅ use ride ID
        data: {"fareAmountDriver": int.parse(offeredPrice)},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        Get.snackbar("Success", "Ride accepted",
            backgroundColor: Colors.green, colorText: Colors.white);

        // Continue to next screen
        Get.to(() => UserInformationView(), arguments: {
          'driverLocation': ride.stops.first,
          'passengerLocation': ride.stops[1],
          'pickup': ride.stops.first.toString(),
          'dropoff': ride.stops.last.toString(),
          'eta': 'Approx 20 minutes',
          'riderImage': 'assets/images/user.jpeg',
          'offeredPrice': offeredPrice,
          'passengerPhone': ride.phoneNumber,
          'rideId': ride.id,
        });
      } else {
        Get.snackbar(
            "Error", response.data['message'] ?? 'Failed to accept ride',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print("Ride accept error: $e");
      Get.snackbar("Error", "Something went wrong",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  void onClose() {
    priceController.dispose();
    super.onClose();
  }
}
