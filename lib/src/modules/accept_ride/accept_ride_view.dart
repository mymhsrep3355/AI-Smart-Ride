// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:smart_ride/src/modules/accept_ride/accept_ride_logic.dart';
// import 'package:smart_ride/src/modules/customwidget/custom_button.dart';
// import 'package:smart_ride/src/modules/driver_homepage/driver_home_view.dart';
// import 'package:smart_ride/src/modules/MessagePassenger/message_passenger_view.dart';

// class UserInformationView extends StatelessWidget {
//   final logic = Get.put(UserInformationLogic());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             SizedBox(
//               height: 300,
//               width: double.infinity,
//               child: GoogleMap(
//                 initialCameraPosition: CameraPosition(
//                   target: logic.pickupLocation,
//                   zoom: 13,
//                 ),
//                 markers: {
//                   Marker(markerId: MarkerId("pickup"), position: logic.pickupLocation),
//                   Marker(markerId: MarkerId("dropoff"), position: logic.dropoffLocation),
//                 },
//                 polylines: {
//                   Polyline(
//                     polylineId: PolylineId("route"),
//                     color: Colors.blue,
//                     width: 5,
//                     points: [logic.pickupLocation, logic.dropoffLocation],
//                   )
//                 },
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 margin: const EdgeInsets.all(16),
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Ride Information", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//                     SizedBox(height: 8),
//                     Row(
//                       children: [
//                         CircleAvatar(radius: 28, backgroundImage: AssetImage(logic.riderImage)),
//                         SizedBox(width: 12),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(logic.riderName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//                             Text(logic.eta, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
//                           ],
//                         ),
//                         Spacer(),
//                         IconButton(
//                           icon: Icon(Icons.message),
//                           onPressed: () => Get.to(() => PassengerChattingScreenView()),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.phone),
//                           onPressed: logic.callPassenger,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 16),
//                     Text("Order Information", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                     SizedBox(height: 10),
//                     Text("Pick-up Location: ${logic.pickup}"),
//                     Text("Drop-off Location: ${logic.dropoff}"),
//                     SizedBox(height: 10),
//                     Text("Offered Price: Rs. ${logic.offeredPrice}", style: TextStyle(fontWeight: FontWeight.bold)),
//                     Spacer(),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: CustomButton(
//                             text: "Arrived",
//                             onPressed: logic.goToRideStart,
//                             backgroundColor: Colors.blue,
//                             textColor: Colors.white,
//                           ),
//                         ),
//                         SizedBox(width: 12),
//                         Expanded(
//                           child: CustomButton(
//                             text: "Cancel",
//                             onPressed: () => Get.offAll(() => DriverHomePageView()),
//                             backgroundColor: Colors.red,
//                             textColor: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_ride/src/modules/accept_ride/accept_ride_logic.dart';
import 'package:smart_ride/src/modules/customwidget/custom_button.dart';
import 'package:smart_ride/src/modules/driver_homepage/driver_home_view.dart';
import 'package:smart_ride/src/modules/MessagePassenger/message_passenger_view.dart';

class UserInformationView extends StatelessWidget {
  final logic = Get.put(UserInformationLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: logic.pickupLocation,
                  zoom: 13,
                ),
                markers: {
                  Marker(
                      markerId: MarkerId("pickup"),
                      position: logic.pickupLocation),
                  Marker(
                      markerId: MarkerId("dropoff"),
                      position: logic.dropoffLocation),
                },
                polylines: {
                  Polyline(
                    polylineId: PolylineId("route"),
                    color: Colors.blue,
                    width: 5,
                    points: [logic.pickupLocation, logic.dropoffLocation],
                  )
                },
              ),
            ),
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
                    Text("Ride Information",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: AssetImage(logic.riderImage),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(logic.riderName,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                            Text(logic.eta,
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[600])),
                          ],
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.message),
                          onPressed: () =>
                              Get.to(() => PassengerChattingScreenView()),
                        ),
                        IconButton(
                          icon: Icon(Icons.phone),
                          onPressed: logic.callPassenger,
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text("Order Information",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 10),
                    Text("Pick-up Location: ${logic.pickup}"),
                    Text("Drop-off Location: ${logic.dropoff}"),
                    SizedBox(height: 10),
                    Text(
                      "Offered Price: Rs. ${logic.offeredPrice.isNotEmpty ? logic.offeredPrice : 'N/A'}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: "Arrived",
                            onPressed: logic.goToRideStart,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: CustomButton(
                            text: "Cancel",
                            onPressed: logic.cancelRide,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
