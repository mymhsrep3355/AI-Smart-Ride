
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:smart_ride/src/modules/choose_ride_carpooling/choose_ride_carpooling_view.dart';
import 'package:smart_ride/src/services/get_service.dart';
import 'package:smart_ride/src/services/post_service.dart';
import 'package:smart_ride/src/services/url.dart';

class PickDropcontroller extends GetxController {
  final pickupController = TextEditingController();
  final dropoffControllers = <TextEditingController>[];
  final fareController = TextEditingController();
  final passengerController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  late GoogleMapController mapController;
  LatLng? pickupLatLng;
  final dropoffLatLngs = <LatLng>[];

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  final apiKey = 'YOUR_GOOGLE_MAPS_API_KEY'; // Replace this!

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

  void addDropoff() {
    dropoffControllers.add(TextEditingController());
    update();
  }

  void removeDropoff(int index) {
    if (index < dropoffControllers.length) {
      dropoffControllers.removeAt(index);
      if (index < dropoffLatLngs.length) dropoffLatLngs.removeAt(index);
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
      markers.add(
        Marker(
          markerId: MarkerId("dropoff$index"),
          position: position,
        ),
      );
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

  void pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      dateController.text = "${picked.toLocal()}".split(' ')[0];
      update();
    }
  }

  void pickTime(BuildContext context) async {
    TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      timeController.text = picked.format(context);
      update();
    }
  }


  Future<void> fetchGroupIdAndBookRide() async {
    await getMethod(
      getGroupsURL, 
      null,
      (success, data) async {
        if (success && data != null && data['data'] != null && data['data'].isNotEmpty) {

          final groupId = data['data'][0]['_id'];
          await bookCarpoolingRide(groupId);
        } else {
          Get.snackbar("Error", "No group found for booking.");
        }
      },
      authHeader: true,
    );
  }


  Future<void> bookCarpoolingRide(String groupId) async {
    final payload = {
      "pickUpLocation": {
        "type": "Point",
        "coordinates": [
          pickupLatLng?.longitude,
          pickupLatLng?.latitude
        ]
      },
      "dropOffLocation": {
        "type": "Point",
        "coordinates": [
          dropoffLatLngs.isNotEmpty ? dropoffLatLngs[0].longitude : null,
          dropoffLatLngs.isNotEmpty ? dropoffLatLngs[0].latitude : null
        ]
      },
      "fareAmount": int.tryParse(fareController.text) ?? 0,
      "vehicleType": "tourbus", 
      "numberOfPassengers": int.tryParse(passengerController.text) ?? 1,
      "dateOfDeparture": dateController.text,
      "timeOfDeparture": timeController.text
    };

    final url = bookRideURL(groupId);
    bool success = false;
    await postMethod(
      url,
      payload,
      (success, data) {
       
        print('Book ride API callback: success=$success, data=$data, data.runtimeType=${data != null ? data.runtimeType.toString() : 'null'}');

        if (success || success == true) {
 
          Get.snackbar("Success", "Ride booked successfully!");
          Get.to(() => ChooseRideCarpoolingView(
            pickupLocation: pickupLatLng!,
            dropoffLocations: dropoffLatLngs,
            pickupAddress: pickupController.text,
            dropoffAddresses: dropoffControllers.map((c) => c.text).toList(),
            fare: "Rs. ${fareController.text}",
          ));
        } else {
         
          String errorMsg = "Failed to book ride";
          if (data != null && data is Map && data['message'] != null) {
            errorMsg = data['message'];
          }
          Get.snackbar("Error", errorMsg);
          Get.to(() => ChooseRideCarpoolingView(
            pickupLocation: pickupLatLng!,
            dropoffLocations: dropoffLatLngs,
            pickupAddress: pickupController.text,
            dropoffAddresses: dropoffControllers.map((c) => c.text).toList(),
            fare: "Rs. ${fareController.text}",
          ));
        }
      },
      authHeader: true,
    );
  }
  void handleSearch() {
    // if (formKey.currentState!.validate()) {
    //   if (pickupLatLng != null && dropoffLatLngs.isNotEmpty) {
        
    //   }
    // }
    fetchGroupIdAndBookRide();
  }
}

