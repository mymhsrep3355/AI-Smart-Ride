import 'dart:async';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_ride/src/general_controller/GeneralController.dart';
import 'package:smart_ride/src/services/url.dart';
import 'package:smart_ride/src/modules/utlis/keys.dart';
import 'package:smart_ride/src/modules/driver_ETA/driver_ETA_view.dart';

class ChooseRideController extends GetxController {
  var isLoading = true.obs;
  var rideOffers = <Map<String, dynamic>>[].obs;
  late GoogleMapController mapController;

  Timer? _refreshTimer;

  @override
  void onInit() {
    super.onInit();
    fetchRideOffers();
    startAutoRefresh();
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    super.onClose();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      fetchRideOffers();
    });
  }

  void fetchRideOffers() async {
    isLoading.value = true;

    final token = Get.find<GeneralController>().box.read(AppKeys.authToken);
    if (token == null) {
      Get.snackbar("Error", "Passenger not authenticated");
      return;
    }

    try {
      final dioClient = Dio();
      dioClient.options.headers = {
        'Authorization': 'Bearer $token',
      };

      final response = await dioClient.get(getpassengercreateRides);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List rides = response.data['rides'];

        final newOffers = rides
            .where((r) =>
                r['status'] == 'offered' &&
                r['driver'] != null &&
                r['fareAmountDriver'] != null)
            .map<Map<String, dynamic>>((ride) {
          final driver = ride['driver'];
          final vehicle = driver?['vehicle'] ?? {};

          return {
            'rideId': ride['_id'],
            'driverId': driver['_id'] ?? 'Unknown',
            'name': driver['name'] ?? 'Unknown',
            'rating': 'N/A', // Add real rating if available
            'phoneNumber': driver['phoneNumber'] ?? 'N/A',
            'profileImage': driver['profileImage'] ?? '', // ✅ add this
            'car': vehicle['type'] ?? '',
            'brand': vehicle['brand'] ?? '',
            'model': vehicle['name'] ?? '',
            'color': vehicle['color'] ?? '',
            'price': ride['fareAmountDriver'].toString(),
            'pickup': ride['pickUpLocation']['coordinates'],
            'dropoffs': ride['dropOffLocations'].map<LatLng>((loc) {
              final coords = loc['coordinates'];
              return LatLng(coords[1], coords[0]);
            }).toList(),
          };
        }).toList();

        rideOffers.value = newOffers;
      }
    } catch (e) {
      print("Ride offer fetch error: $e");
      Get.snackbar("Error", "Failed to fetch ride offers");
    } finally {
      isLoading.value = false;
    }
  }

  void acceptRide(
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

    final rideId = offer['rideId'];
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
        // Use the rideId from the API response if available
        final acceptedRideId = response.data['ride']?['_id'] ?? rideId;
        final updatedOffer = Map<String, dynamic>.from(offer);
        updatedOffer['rideId'] = acceptedRideId;
        Get.to(() => DriverETAView(
              driverInfo: updatedOffer,
              driverLocation: pickupLocation,
              pickupLocation: pickupLocation,
              dropoffLocations: dropoffLocations,
              pickupAddress: pickupAddress,
              dropoffAddresses: dropoffAddresses,
            ));
      } else {
        Get.snackbar(
            "Error", response.data['message'] ?? "Failed to accept ride");
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
