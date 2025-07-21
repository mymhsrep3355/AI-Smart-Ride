import 'package:flutter/material.dart';
import 'package:smart_ride/src/modules/History_screen/history_logic.dart';
import 'package:smart_ride/src/modules/utlis/app_fonts.dart';

class HistoryView extends StatelessWidget {
  HistoryView({super.key});

  final HistoryLogic logic = HistoryLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Show full image without cropping
          SizedBox(
            width: double.infinity,
            height: 200, // or the exact height of your image aspect ratio
            child: Image.asset(
              "assets/images/top.png",
              fit: BoxFit.fitWidth, // Shows full width without cropping height
              alignment: Alignment.topCenter,
            ),
          ),

          // Foreground content
          SafeArea(
            child: Column(
              children: [
                // AppBar / Title
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    children: [
                      Text(
                        'History',
                        style:StyleRefer.poppinsBold.copyWith(
                          fontSize: 22,
                          color: Colors.white,
                          shadows: const [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 4,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Make space to fully reveal the image
                const SizedBox(height: 100), // Adjust based on image height

                // Main white container
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: logic.historyList.length,
                      itemBuilder: (context, index) {
                        final ride = logic.historyList[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.directions_car,
                                  size: 36, color: Colors.blue),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ride["name"]!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    ride["rideId"]!,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    ride["route"]!,
                                    style:
                                        const TextStyle(color: Colors.black87),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
