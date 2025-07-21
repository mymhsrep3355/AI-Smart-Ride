import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_ride/src/general_controller/GeneralController.dart';
import 'package:smart_ride/src/modules/carpooling_driver_ETA/carpooling_driver_ETA_logic.dart';
import 'package:smart_ride/src/modules/carpooling_driver_ETA/carpooling_driver_ETA_view.dart';
import 'package:dio/dio.dart';
import 'package:smart_ride/src/services/url.dart';
import 'package:smart_ride/src/modules/utlis/keys.dart';
import 'package:smart_ride/src/services/get_service.dart';
import 'package:smart_ride/src/services/post_service.dart';

class ChooseRideCarpoolingController extends GetxController {
  var isLoading = true.obs;
  var rideOffers = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPassengerRides();
  }

  void fetchPassengerRides() async {
    isLoading.value = true;
    final token = Get.find<GeneralController>().box.read(AppKeys.authToken);
    if (token == null) {
      Get.snackbar("Error", "Passenger not authenticated");
      isLoading.value = false;
      return;
    }
    try {
      final dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $token',
      };
      final response = await dio.get(passengerRides);
      if (response.statusCode == 200 && response.data['success'] == true) {
        final rides = response.data['rides'] as List;
        final offeredRides = rides.where((r) => r['status'] == 'offered').toList();
        rideOffers.value = offeredRides.cast<Map<String, dynamic>>();
      } else {
        Get.snackbar("Failed", "Could not fetch rides");
        rideOffers.clear();
      }
    } catch (e) {
      print("Error fetching passenger rides: $e");
      Get.snackbar("Error", "Something went wrong");
      rideOffers.clear();
    }
    isLoading.value = false;
  }

  Future<void> acceptPassengerRide(
    Map<String, dynamic> offer,
    LatLng pickupLocation,
    List<LatLng> dropoffLocations,
    String pickupAddress,
    List<String> dropoffAddresses,
  ) async {
    final token = Get.find<GeneralController>().box.read(AppKeys.authToken);
    if (token == null) {
      Get.snackbar("Error", "Passenger not authenticated");
      return;
    }
    final rideId = offer['_id'];
    if (rideId == null) {
      Get.snackbar("Error", "Invalid ride ID");
      return;
    }
    try {
      final dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $token',
      };
      final response = await dio.post(passengerAcceptRideURL(rideId));
      if (response.statusCode == 200 && response.data['success'] == true) {
        Get.to(() => const CarpoolingDriverETAView(), arguments: {
          'driverInfo': offer,
          'driverLocation': pickupLocation,
          'pickupLocation': pickupLocation,
          'dropoffLocations': dropoffLocations,
          'pickupAddress': pickupAddress,
          'dropoffAddresses': dropoffAddresses,
        });
      } else {
        Get.snackbar("Error", response.data['message'] ?? "Failed to accept ride");
      }
    } catch (e) {
      print("Accept ride error: $e");
      Get.snackbar("Error", "Failed to accept ride");
    }
  }

  void declineRide(int index) {
    rideOffers.removeAt(index);
  }
}
