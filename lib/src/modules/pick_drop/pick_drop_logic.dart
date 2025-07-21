import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:smart_ride/src/modules/choose_ride/choose_ride_view.dart';
import 'package:dio/dio.dart' as dio;
import 'package:smart_ride/src/services/url.dart';
import 'package:smart_ride/src/general_controller/GeneralController.dart';

import 'package:smart_ride/src/modules/utlis/keys.dart';

class PickDropController extends GetxController {
  final String vehicleType;
  var createdRides = [].obs;

  PickDropController({required this.vehicleType});

  final pickupController = TextEditingController();
  final dropoffControllers = <TextEditingController>[];
  final fareController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  late GoogleMapController mapController;
  LatLng? pickupLatLng;
  final dropoffLatLngs = <LatLng>[];

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  var pickupSuggestions = <String>[].obs;
  var dropoffSuggestions = <List<String>>[].obs;

  final apiKey = 'YOUR_GOOGLE_MAPS_API_KEY';

  void onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    await setCurrentLocation();
  }

  Future<void> setCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) return;
    }

    final position = await Geolocator.getCurrentPosition();
    pickupLatLng = LatLng(position.latitude, position.longitude);
    markers.add(Marker(
      markerId: const MarkerId("pickup"),
      position: pickupLatLng!,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ));
    mapController.animateCamera(CameraUpdate.newLatLngZoom(pickupLatLng!, 15));

    final placemarks = await geo.placemarkFromCoordinates(
        position.latitude, position.longitude);
    final name =
        placemarks.first.street ?? placemarks.first.name ?? 'Current Location';
    pickupController.text = name;

    updatePolylines();
    update();
  }

  Future<void> searchPlace(String query, bool isPickup, [int? index]) async {
    if (query.isEmpty) return;
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$apiKey';
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      final predictions = List<Map<String, dynamic>>.from(data['predictions']);
      final suggestions =
          predictions.map((e) => e['description'] as String).toList();
      if (isPickup) {
        pickupSuggestions.assignAll(suggestions);
      } else if (index != null) {
        while (dropoffSuggestions.length <= index) {
          dropoffSuggestions.add([]);
        }
        dropoffSuggestions[index] = suggestions;
        dropoffSuggestions.refresh();
      }
    }
  }

  Future<void> selectPlace(String place, bool isPickup, [int? index]) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(place)}&key=$apiKey';
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['status'] == 'OK' && data['results'].isNotEmpty) {
      final location = data['results'][0]['geometry']['location'];
      final position = LatLng(location['lat'], location['lng']);

      if (isPickup) {
        pickupLatLng = position;
        pickupController.text = place;
        markers.removeWhere((m) => m.markerId.value == 'pickup');
        markers.add(Marker(
          markerId: const MarkerId("pickup"),
          position: position,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ));
      } else if (index != null) {
        while (dropoffLatLngs.length <= index) {
          dropoffLatLngs.add(position);
        }
        dropoffControllers[index].text = place;
        markers.removeWhere((m) => m.markerId.value == 'dropoff$index');
        markers.add(
            Marker(markerId: MarkerId("dropoff$index"), position: position));
      }

      updatePolylines();
      mapController.animateCamera(CameraUpdate.newLatLngZoom(position, 14));
      update();
    }
  }

  void addDropoff() {
    dropoffControllers.add(TextEditingController());
    dropoffSuggestions.add([]);
    update();
  }

  void removeDropoff(int index) {
    if (index < dropoffControllers.length) {
      dropoffControllers.removeAt(index);
      if (index < dropoffLatLngs.length) dropoffLatLngs.removeAt(index);
      if (index < dropoffSuggestions.length) dropoffSuggestions.removeAt(index);
      markers.removeWhere((m) => m.markerId.value == 'dropoff$index');
      updatePolylines();
      update();
    }
  }

  void selectPlaceFromTap(LatLng position, bool isPickup, [int? index]) async {
    final placemarks = await geo.placemarkFromCoordinates(
        position.latitude, position.longitude);
    final name =
        placemarks.first.street ?? placemarks.first.name ?? 'Selected Location';

    if (isPickup) {
      pickupLatLng = position;
      pickupController.text = name;
      markers.removeWhere((m) => m.markerId.value == 'pickup');
      markers.add(Marker(
        markerId: const MarkerId("pickup"),
        position: position,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ));
    } else if (index != null) {
      while (dropoffLatLngs.length <= index) {
        dropoffLatLngs.add(position);
      }
      dropoffControllers[index].text = name;
      markers.removeWhere((m) => m.markerId.value == 'dropoff$index');
      markers
          .add(Marker(markerId: MarkerId("dropoff$index"), position: position));
    }

    updatePolylines();
    update();
  }

  void updatePolylines() {
    polylines.clear();
    if (pickupLatLng != null && dropoffLatLngs.isNotEmpty) {
      LatLng start = pickupLatLng!;
      for (int i = 0; i < dropoffLatLngs.length; i++) {
        final end = dropoffLatLngs[i];
        polylines.add(Polyline(
          polylineId: PolylineId('route$i'),
          points: [start, end],
          color: Colors.blue,
          width: 5,
        ));
        start = end;
      }
    }
  }

  void handleSearch() async {
    if (pickupLatLng == null || dropoffLatLngs.isEmpty) {
      Get.snackbar(
          "Error", "Please select both pickup and drop-off locations.");
      return;
    }

    final fare = double.tryParse(fareController.text.trim());
    if (fare == null || fare <= 0) {
      Get.snackbar("Error", "Please enter a valid fare.");
      return;
    }

    final token = Get.find<GeneralController>().box.read(AppKeys.authToken);
    if (token == null) {
      Get.snackbar("Error", "User not authenticated");
      return;
    }

    final dioClient = dio.Dio();
    dioClient.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = {
      "vehicleType": vehicleType, // ✅ dynamic from HomePage
      "pickUpLocation": {
        "type": "Point",
        "coordinates": [pickupLatLng!.longitude, pickupLatLng!.latitude],
      },
      "dropOffLocations": dropoffLatLngs.map((latLng) {
        return {
          "type": "Point",
          "coordinates": [latLng.longitude, latLng.latitude],
        };
      }).toList(),
      "fareAmount": fare,
    };

    try {
      final response = await dioClient.post(passengercreateRides, data: body);

      if (response.statusCode == 201 && response.data['success'] == true) {
        // ✅ Only show success
        if (Get.isSnackbarOpen) Get.back(); // close previous snackbar if open
        Get.snackbar("Success", "Ride Created Successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
        await fetchCreatedRides(); // ✅ <--- Add this line

        final ride = response.data['ride'];

        Get.to(() => ChooseRideView(
              pickupLocation: pickupLatLng!,
              dropoffLocations: dropoffLatLngs,
              pickupAddress: pickupController.text,
              dropoffAddresses: dropoffControllers.map((c) => c.text).toList(),
              fare: "Rs. $fare",
            ));
      } else {
        // ✅ Show failure only if really failed
        Get.snackbar(
            "Failed", response.data['message'] ?? "Failed to create ride",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong while creating the ride");
      print("Ride creation error: $e");
    }
  }

  Future<void> fetchCreatedRides() async {
    final token = Get.find<GeneralController>().box.read(AppKeys.authToken);
    if (token == null) {
      Get.snackbar("Error", "User not authenticated");
      return;
    }

    final dioClient = dio.Dio();
    dioClient.options.headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await dioClient.get(getpassengercreateRides);

      if (response.statusCode == 200 && response.data['success'] == true) {
        createdRides.assignAll(response.data['rides']);
      } else {
        Get.snackbar("Failed", "Could not fetch rides",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print("Get rides error: $e");
      Get.snackbar("Error", "Something went wrong while fetching rides",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchCreatedRides(); // fetch rides when screen opens
  }
}
