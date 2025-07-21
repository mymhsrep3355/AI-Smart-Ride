import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_ride/src/modules/MessagePassenger/message_passenger_view.dart';
import 'package:smart_ride/src/modules/customwidget/custom_button.dart';
import 'ride_start_logic.dart';

class RideStartView extends StatelessWidget {
  final logic = Get.put(RideStartLogic());

  @override
  Widget build(BuildContext context) {
    final LatLng yourLocation = logic.yourLocation;
    final LatLng destinationLocation = logic.destinationLocation;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 🗺️ Google Map
            SizedBox(
              height: 300,
              width: double.infinity,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: yourLocation,
                  zoom: 13,
                ),
                markers: {
                  Marker(markerId: MarkerId("pickup"), position: yourLocation),
                  Marker(markerId: MarkerId("dropoff"), position: destinationLocation),
                },
                polylines: {
                  Polyline(
                    polylineId: PolylineId("route"),
                    color: Colors.blue,
                    width: 5,
                    points: [yourLocation, destinationLocation],
                  )
                },
              ),
            ),

            // 👇 Info Panel
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Ride Started", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        CircleAvatar(radius: 28, backgroundImage: AssetImage(logic.riderImage)),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(logic.riderName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            Text(logic.eta, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                          ],
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.message),
                          onPressed: () => Get.to(() => PassengerChattingScreenView()),
                        ),
                        IconButton(
                          icon: Icon(Icons.phone),
                          onPressed: logic.callPassenger,
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text("Destination", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 10),
                    Text("Pick-up Location: ${logic.pickup}"),
                    Text("Drop-off Location: ${logic.dropoff}"),
                    SizedBox(height: 10),
                    Text("Offered Price: Rs. ${logic.offeredPrice}", style: TextStyle(fontWeight: FontWeight.bold)),
                    Spacer(),
                    CustomButton(
                      text: "Ride Start",
                      onPressed: logic.startRide,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
