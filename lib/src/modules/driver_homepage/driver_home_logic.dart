import 'package:dio/dio.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart_ride/src/services/url.dart';
import 'package:smart_ride/src/general_controller/GeneralController.dart';
import 'package:smart_ride/src/modules/utlis/keys.dart';
import 'package:smart_ride/src/modules/driver_activerequestpage/active_request_view.dart';

class Ride {
  final String id;
  final String route;
  final String fare;
  final String phoneNumber;
  final String distance;
  final List<LatLng> stops;
  final String vehicleType;

  Ride({
    required this.id,
    required this.route,
    required this.fare,
    required this.phoneNumber,
    required this.distance,
    required this.stops,
    required this.vehicleType,
  });
}

class DriverHomeLogic extends GetxController {
  var rideList = <Ride>[].obs;
  Timer? _autoRefreshTimer;

  @override
  void onInit() {
    super.onInit();
    fetchAvailableRides();
    startAutoRefresh();
  }

  @override
  void onClose() {
    _autoRefreshTimer?.cancel();
    super.onClose();
  }

  void startAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      fetchAvailableRides();
    });
  }

  Future<String> calculateDistance(LatLng start, LatLng end) async {
    final distanceInMeters = Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
    return (distanceInMeters / 1000).toStringAsFixed(1);
  }

  Future<void> fetchAvailableRides() async {
    final token = Get.find<GeneralController>().box.read(AppKeys.authToken);
    print('fetchAvailableRides: token = $token');
    if (token == null) {
      print('fetchAvailableRides: No token found!');
      Get.snackbar("Error", "Driver not authenticated");
      return;
    }

    final dioClient = Dio();
    dioClient.options.headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await dioClient.get(getdriverAvailableRides);
      print('fetchAvailableRides: API response = \n${response.data}');
      print('fetchAvailableRides: Status code = ${response.statusCode}');
      if (response.statusCode == 200 && response.data['success'] == true) {
        final ridesRaw = response.data['rides'];
        print('fetchAvailableRides: ridesRaw type = \n${ridesRaw.runtimeType}');
        if (ridesRaw is List && ridesRaw.isNotEmpty) {
          final previousCount = rideList.length;
          rideList.clear();
          for (var ride in ridesRaw) {
            try {
              final pickup = ride['pickUpLocation']['coordinates'];
              final dropoffs = ride['dropOffLocations'] as List? ?? [];
              final pickupLatLng = LatLng(pickup[1], pickup[0]);
              List dropoffCoords = dropoffs.isNotEmpty ? dropoffs.map((d) => d['coordinates']).toList() : [];
              LatLng lastDropoffLatLng = pickupLatLng;
              if (dropoffCoords.isNotEmpty) {
                lastDropoffLatLng = LatLng(dropoffCoords.last[1], dropoffCoords.last[0]);
              }
              final distance = await calculateDistance(pickupLatLng, lastDropoffLatLng);
              final pickupText = "(${pickup[1]}, ${pickup[0]})";
              final dropoffTextList = dropoffs.map((d) {
                final coords = d['coordinates'];
                return "(${coords[1]}, ${coords[0]})";
              }).toList();
              final routeString = dropoffTextList.isNotEmpty ? '$pickupText → ${dropoffTextList.join(" → ")}' : pickupText;
              rideList.add(Ride(
                id: ride['_id'],
                route: routeString,
                fare: ride['fareAmount'].toString(),
                phoneNumber: ride['passenger'] ?? 'Unknown',
                distance: distance,
                stops: [
                  pickupLatLng,
                  ...dropoffCoords.map((c) => LatLng(c[1], c[0])),
                ],
                vehicleType: ride['vehicleType'] ?? '-',
              ));
            } catch (parseError) {
              print('fetchAvailableRides: Error parsing ride: $parseError');
              print('fetchAvailableRides: Raw ride data: $ride');
            }
          }
          print('fetchAvailableRides: rideList length = ${rideList.length}');
          if (rideList.length > previousCount) {
            Get.snackbar("🔄 New Ride", "New ride(s) available",
                backgroundColor: Colors.green, colorText: Colors.white);
          }
        } else {
          print('fetchAvailableRides: ridesRaw is not a non-empty List. Value: $ridesRaw');
          rideList.clear();
        }
      } else {
        print('fetchAvailableRides: API error or success==false. Data: ${response.data}');
        Get.snackbar("Failed", "Could not fetch available rides",
            backgroundColor: Colors.red, colorText: Colors.white);
        rideList.clear();
      }
    } catch (e, stack) {
      print("Error fetching rides: $e");
      print("Stack trace: $stack");
      Get.snackbar("Error", "Something went wrong",
          backgroundColor: Colors.red, colorText: Colors.white);
      rideList.clear();
    }
  }

  void rejectRide(Ride ride) async {
  final token = Get.find<GeneralController>().box.read(AppKeys.authToken);
  if (token == null) {
    Get.snackbar("Error", "Driver not authenticated");
    return;
  }

  final dioClient = Dio();
  dioClient.options.headers = {
    'Authorization': 'Bearer $token',
  };

  try {
    final response = await dioClient.post(driverrejectRides(ride.id));

    if (response.statusCode == 200 && response.data['success'] == true) {
      rideList.remove(ride); // ✅ Only remove on success
      Get.snackbar("Success", "Ride rejected",
          backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar("Failed", "Could not reject the ride",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  } catch (e) {
    print("Error rejecting ride: $e");
    Get.snackbar("Error", "Something went wrong",
        backgroundColor: Colors.red, colorText: Colors.white);
  }
}

  // Accept ride method
  void acceptRide(Ride ride, double fareAmountDriver) async {
    final token = Get.find<GeneralController>().box.read(AppKeys.authToken);
    print('acceptRide: token = $token');
    print('acceptRide: fareAmountDriver = $fareAmountDriver');
    if (token == null) {
      Get.snackbar("Error", "Driver not authenticated");
      return;
    }
    final dioClient = Dio();
    try {
      final response = await dioClient.post(
        acceptRideURL(ride.id),
        data: {"fareAmountDriver": fareAmountDriver},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      print('acceptRide: response = \n${response.data}');
      if (response.statusCode == 200 && response.data['success'] == true) {
        rideList.remove(ride);
        Get.snackbar("Success", "Ride accepted",
            backgroundColor: Colors.green, colorText: Colors.white);
        // Navigate to DriverActiveRequestView and pass all ride params
        Get.to(() => DriverActiveRequestView(), arguments: {
          'ride': ride,
          'fareAmountDriver': fareAmountDriver,
        });
      } else {
        print('acceptRide: API error: ${response.data}');
        Get.snackbar("Failed", "Could not accept the ride",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      if (e is DioError) {
        print("❗ DioError: \n${e.response?.data}");
        print("❗ DioError: ${e.message}");
      } else {
        print("❗ Unexpected error: ${e.toString()}");
      }
      Get.snackbar("Error", "Something went wrong",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

}
