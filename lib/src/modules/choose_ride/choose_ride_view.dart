import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_ride/src/modules/choose_ride/choose_ride_logic.dart';
import 'package:smart_ride/src/modules/customwidget/custom_button.dart';
import 'package:smart_ride/src/modules/Home_Page/homepage_view.dart';

class ChooseRideView extends StatelessWidget {
  final LatLng pickupLocation;
  final String pickupAddress;
  final List<LatLng> dropoffLocations;
  final List<String> dropoffAddresses;
  final String fare;

  final ChooseRideController controller = Get.put(ChooseRideController());

  ChooseRideView({
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
            onMapCreated: controller.onMapCreated,
            initialCameraPosition: CameraPosition(
              target: pickupLocation,
              zoom: 13,
            ),
            markers: {
              Marker(
                markerId: const MarkerId("pickup"),
                position: pickupLocation,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
              ),
              ...List.generate(dropoffLocations.length, (index) {
                return Marker(
                  markerId: MarkerId("dropoff$index"),
                  position: dropoffLocations[index],
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                );
              })
            },
            polylines: {
              Polyline(
                polylineId: const PolylineId("route"),
                points: [pickupLocation, ...dropoffLocations],
                width: 4,
                color: Colors.blue,
              ),
            },
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
                    const Text(
                      "Choose a ride",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          controller.fetchRideOffers();
                        },
                        child: controller.isLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : controller.rideOffers.isEmpty
                                ? const Center(child: Text("No offers yet"))
                                : ListView.builder(
                                    itemCount: controller.rideOffers.length,
                                    itemBuilder: (context, index) {
                                      final offer =
                                          controller.rideOffers[index];
                                      return Card(
                                        elevation: 2,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Driver: ${offer['name']}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                  "Rating: ${offer['rating']}"),
                                              Text(
                                                  "Vehicle: ${offer['car']} - ${offer['brand']} ${offer['model']} (${offer['color']})"),
                                              Text(
                                                  "Driver Fare: PKR ${offer['price']}"),
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
                                                        controller.acceptRide(
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
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
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
                          onPressed: () {
                            Get.to(() => const HomePageView());
                          },
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
