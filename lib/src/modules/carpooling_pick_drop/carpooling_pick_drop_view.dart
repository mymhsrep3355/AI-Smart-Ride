import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_ride/src/modules/customwidget/custom_button.dart';
import 'carpooling_pick_drop_logic.dart';
import 'package:smart_ride/src/modules/customwidget/textfields.dart';
import 'package:flutter/services.dart';

class CarpoolingPickDropView extends StatelessWidget {
  const CarpoolingPickDropView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PickDropcontroller>(
      init: PickDropcontroller(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 280,
                  child: GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(24.8607, 67.0011),
                      zoom: 12,
                    ),
                    onMapCreated: controller.onMapCreated,
                    markers: controller.markers,
                    polylines: controller.polylines,
                    myLocationEnabled: true,
                    onTap: (position) {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.location_on),
                              title: const Text("Set as Pickup Location"),
                              onTap: () {
                                controller.selectPlaceFromTap(position, true);
                                Navigator.pop(context);
                              },
                            ),
                            for (int i = 0;
                                i < controller.dropoffControllers.length;
                                i++)
                              ListTile(
                                leading: const Icon(Icons.flag),
                                title: Text("Set as Dropoff ${i + 1}"),
                                onTap: () {
                                  controller.selectPlaceFromTap(
                                      position, false, i);
                                  Navigator.pop(context);
                                },
                              )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: controller.setCurrentLocation,
                            child: AbsorbPointer(
                              child: Textfield(
                                hintKey: "Pickup Location",
                                controller: controller.pickupController,
                                icon: Icons.location_on,
                                validator: (val) =>
                                    val!.isEmpty ? 'Required' : null,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          for (int i = 0;
                              i < controller.dropoffControllers.length;
                              i++)
                            Row(
                              children: [
                                Expanded(
                                  child: Textfield(
                                    hintKey: "Dropoff ${i + 1}",
                                    controller:
                                        controller.dropoffControllers[i],
                                    icon: Icons.flag,
                                    validator: (val) =>
                                        val!.isEmpty ? 'Required' : null,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      controller.removeDropoff(i),
                                  icon: const Icon(Icons.close),
                                )
                              ],
                            ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: controller.addDropoff,
                              icon: const Icon(Icons.add_location_alt),
                              label: const Text("Add Dropoff"),
                            ),
                          ),
                          Textfield(
                            hintKey: "Fare",
                            controller: controller.fareController,
                            inputType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) =>
                                value!.isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: 5),
                          Textfield(
                            hintKey: "Number of passengers",
                            controller: controller.passengerController,
                            inputType: TextInputType.number,
                            validator: (value) =>
                                value!.isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: 5),
                          GestureDetector(
                            onTap: () => controller.pickDate(context),
                            child: AbsorbPointer(
                              child: Textfield(
                                hintKey: "Select Date",
                                controller: controller.dateController,
                                icon: Icons.calendar_today,
                                validator: (value) =>
                                    value!.isEmpty ? 'Required' : null,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          GestureDetector(
                            onTap: () => controller.pickTime(context),
                            child: AbsorbPointer(
                              child: Textfield(
                                hintKey: "Select Time",
                                controller: controller.timeController,
                                icon: Icons.access_time,
                                validator: (value) =>
                                    value!.isEmpty ? 'Required' : null,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          CustomButton(
                            text: "Search",
                            onPressed: controller.handleSearch,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            borderRadius: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
