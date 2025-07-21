import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smart_ride/src/modules/customwidget/textfields.dart';
import 'package:flutter/services.dart';
import 'active_request_logic.dart';
import 'package:intl/intl.dart';

class DriverActiveRequestView extends StatelessWidget {
  final DriverActiveRequestLogic logic = Get.put(DriverActiveRequestLogic());

  DriverActiveRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F8FB),
      body: SafeArea(
        child: Obx(() {
          final ride = logic.activeRide.value;
          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16, left: 8),
                          child: GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () => Get.back(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 32,
                      bottom: 32,
                      child: Text(
                        'Active Ride',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 6,
                              color: Colors.black26,
                              offset: Offset(1, 2),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (ride != null)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.10),
                              blurRadius: 18,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.directions_car, color: Colors.blue, size: 28),
                                SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    'Ride ID: ${ride.id}',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Icon(Icons.location_pin, color: Colors.redAccent, size: 22),
                                SizedBox(width: 8),
                                Text(
                                  'Pickup: ',
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                                ),
                                Flexible(
                                  child: Text(
                                    '${ride.stops.first.latitude.toStringAsFixed(5)}, ${ride.stops.first.longitude.toStringAsFixed(5)}',
                                    style: TextStyle(fontSize: 15, color: Colors.black87),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.directions_car_filled, color: Colors.teal, size: 22),
                                SizedBox(width: 8),
                                Text('Vehicle: ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                                Flexible(
                                  child: Text(
                                    ride.vehicleType,
                                    style: TextStyle(fontSize: 15, color: Colors.black87),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.attach_money, color: Colors.green, size: 22),
                                SizedBox(width: 8),
                                Text('Passenger Fare: ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                                Flexible(
                                  child: Text(
                                    'Rs. ${ride.fare}',
                                    style: TextStyle(fontSize: 15, color: Colors.black87),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.monetization_on, color: Colors.orange, size: 22),
                                SizedBox(width: 8),
                                Text('Your Fare: ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                                Flexible(
                                  child: Text(
                                    'Rs. ${Get.arguments != null && Get.arguments['fareAmountDriver'] != null ? Get.arguments['fareAmountDriver'] : '-'}',
                                    style: TextStyle(fontSize: 15, color: Colors.black87),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Text('Status: ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                                SizedBox(width: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.orange[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Offered',
                                    style: TextStyle(
                                      color: Colors.orange[800],
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.person, color: Colors.blueGrey, size: 22),
                                SizedBox(width: 8),
                                Text('Passenger ID: ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                                Flexible(
                                  child: Text(
                                    ride.phoneNumber,
                                    style: TextStyle(fontSize: 15, color: Colors.black87),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (ride == null)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Text(
                        'No active ride found.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
