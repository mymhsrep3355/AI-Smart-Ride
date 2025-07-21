import 'package:flutter/material.dart';
import 'package:smart_ride/src/modules/driver_histroypage/driver_histroy_logic.dart';
import 'package:smart_ride/src/modules/utlis/app_fonts.dart';
import 'package:get/get.dart';

class DriverHistoryPage extends StatelessWidget {
  final logic = Get.put(DriverHistoryLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top image and header
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 220,
                  child: Image.asset('assets/images/top.png', fit: BoxFit.cover),
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "History",
                        style: StyleRefer.poppinsBold.copyWith(
                          fontSize: 26,
                          color: Colors.white,
                          shadows: const [
                            Shadow(offset: Offset(0, 1), blurRadius: 4, color: Colors.black54),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(() => Text(
                            "Total rides: ${logic.rides.length}",
                            style: StyleRefer.poppinsRegular.copyWith(
                              fontSize: 16,
                              color: Colors.white,
                              shadows: const [
                                Shadow(offset: Offset(0, 1), blurRadius: 4, color: Colors.black54),
                              ],
                            ),
                          )),
                      Text(
                        "Stars: 4",
                        style: StyleRefer.poppinsRegular.copyWith(
                          fontSize: 16,
                          color: Colors.white,
                          shadows: const [
                            Shadow(offset: Offset(0, 1), blurRadius: 4, color: Colors.black54),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Expanded ListView to show all rides
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: logic.rides.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final ride = logic.rides[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Name & duration
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ride.name,
                                    style: StyleRefer.poppinsSemiBold.copyWith(fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Approx ${ride.duration}",
                                    style: StyleRefer.poppinsRegular.copyWith(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              // Fare badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade900,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  ride.fare,
                                  style: StyleRefer.poppinsSemiBold.copyWith(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
