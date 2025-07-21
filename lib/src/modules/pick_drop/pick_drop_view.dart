import 'package:smart_ride/src/modules/customwidget/custom_button.dart';
import 'package:smart_ride/src/modules/pick_drop/pick_drop_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_ride/src/modules/utlis/app_colors.dart';

class PickDropView extends StatelessWidget {
  final String vehicleType;

  const PickDropView({super.key, required this.vehicleType});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PickDropController>(
      init: PickDropController(vehicleType: vehicleType),
      builder: (controller) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 300,
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
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 20),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: controller.pickupController,
                              decoration: const InputDecoration(
                                labelText: 'Pickup Location',
                                prefixIcon: Icon(Icons.my_location),
                              ),
                              onChanged: (val) =>
                                  controller.searchPlace(val, true),
                            ),
                            Obx(() => controller.pickupSuggestions.isEmpty
                                ? const SizedBox.shrink()
                                : DropdownButton<String>(
                                    value: null,
                                    isExpanded: true,
                                    hint: const Text("Select Pickup"),
                                    items:
                                        controller.pickupSuggestions.map((e) {
                                      return DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        controller.selectPlace(value, true);
                                      }
                                    },
                                  )),
                            const SizedBox(height: 10),
                            for (int i = 0;
                                i < controller.dropoffControllers.length;
                                i++) ...[
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller:
                                          controller.dropoffControllers[i],
                                      decoration: InputDecoration(
                                        labelText: 'Dropoff ${i + 1}',
                                        prefixIcon:
                                            const Icon(Icons.location_on),
                                      ),
                                      onChanged: (val) =>
                                          controller.searchPlace(val, false, i),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () =>
                                        controller.removeDropoff(i),
                                  )
                                ],
                              ),
                              Obx(() => controller.dropoffSuggestions.length >
                                          i &&
                                      controller
                                          .dropoffSuggestions[i].isNotEmpty
                                  ? DropdownButton<String>(
                                      value: null,
                                      isExpanded: true,
                                      hint: Text("Select Dropoff ${i + 1}"),
                                      items: controller.dropoffSuggestions[i]
                                          .map((e) => DropdownMenuItem(
                                              value: e, child: Text(e)))
                                          .toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          controller.selectPlace(
                                              value, false, i);
                                        }
                                      },
                                    )
                                  : const SizedBox.shrink()),
                            ],
                            ElevatedButton.icon(
                              onPressed: controller.addDropoff,
                              icon: const Icon(Icons.add_location_alt),
                              label: const Text("Add Dropoff"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: controller.fareController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Fare (Rs)',
                                prefixIcon: Icon(Icons.money),
                              ),
                            ),
                            const SizedBox(height: 16),
                            CustomButton(
                              text: "Search",
                              onPressed: () {
                                if (controller.formKey.currentState!
                                    .validate()) {
                                  controller.handleSearch();
                                }
                              },
                              backgroundColor: Colors.blue,
                              textColor: Colors.white,
                              borderRadius: 12,
                            ),
                          ],
                        ),
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
