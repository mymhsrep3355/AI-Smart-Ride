import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_ride/src/modules/customwidget/custom_button.dart';
import 'package:smart_ride/src/modules/home_page/homepage_view.dart';
import 'choose_ride_carpooling_logic.dart';

class ChooseRideCarpoolingView extends StatelessWidget {
  final LatLng pickupLocation;
  final List<LatLng> dropoffLocations;
  final String pickupAddress;
  final List<String> dropoffAddresses;
  final String fare;

  final ChooseRideCarpoolingController controller =
      Get.put(ChooseRideCarpoolingController());

  ChooseRideCarpoolingView({
    super.key,
    required this.pickupLocation,
    required this.dropoffLocations,
    required this.pickupAddress,
    required this.dropoffAddresses,
    this.fare = "Rs. 0",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: pickupLocation, zoom: 13),
            markers: {
              Marker(
                markerId: const MarkerId('pickup'),
                position: pickupLocation,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
              ),
              ...List.generate(
                  dropoffLocations.length,
                  (index) => Marker(
                        markerId: MarkerId('dropoff$index'),
                        position: dropoffLocations[index],
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueRed),
                      )),
            },
            polylines: {
              Polyline(
                polylineId: const PolylineId('route'),
                points: [pickupLocation, ...dropoffLocations],
                color: Colors.blue,
                width: 5,
              ),
            },
            myLocationEnabled: true,
            zoomControlsEnabled: false,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 300,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Choose a ride",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Expanded(
                      child: controller.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : controller.rideOffers.isEmpty
                              ? const Center(child: Text("No offers yet"))
                              : ListView.builder(
                                  itemCount: controller.rideOffers.length,
                                  itemBuilder: (context, index) {
                                    final offer = controller.rideOffers[index];
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Vehicle: ${offer['vehicleType'] ?? '-'}',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold)),
                                            Text('Fare: Rs. ${offer['fareAmount'] ?? '-'}'),
                                            Text('Status: ${offer['status'] ?? '-'}'),
                                            Text('Pickup: ${offer['pickUpLocation'] != null && offer['pickUpLocation']['coordinates'] != null ? offer['pickUpLocation']['coordinates'].join(", ") : '-'}'),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                CustomButton(
                                                  text: "Decline",
                                                  onPressed: () => controller
                                                      .declineRide(index),
                                                  backgroundColor:
                                                      Colors.red.shade100,
                                                  textColor:
                                                      Colors.red.shade800,
                                                  width: 100,
                                                  height: 30,
                                                  fontSize: 12,
                                                ),
                                                const SizedBox(width: 8),
                                                CustomButton(
                                                  text: "Accept",
                                                  onPressed: () =>
                                                      controller.acceptPassengerRide(
                                                        offer,
                                                        pickupLocation,
                                                        dropoffLocations,
                                                        pickupAddress,
                                                        dropoffAddresses,
                                                      ),
                                                  backgroundColor:
                                                      Colors.green.shade100,
                                                  textColor:
                                                      Colors.green.shade800,
                                                  width: 100,
                                                  height: 30,
                                                  fontSize: 12,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.credit_card, size: 18),
                            const SizedBox(width: 5),
                            Text(fare, style: const TextStyle(fontSize: 15)),
                          ],
                        ),
                        CustomButton(
                          text: "Stop Search",
                          onPressed: () =>
                              Get.offAll(() => const HomePageView()),
                          width: 200,
                          height: 40,
                          fontSize: 14,
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
