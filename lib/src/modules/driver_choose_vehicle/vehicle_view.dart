import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_ride/src/modules/driver_choose_vehicle/vehicle_logic.dart';
import 'package:smart_ride/src/modules/customwidget/custom_button.dart';
import 'package:smart_ride/src/modules/customwidget/textfields.dart';

class VehicleSelectionView extends StatelessWidget {
final logic = Get.isRegistered<VehicleSelectionLogic>()
    ? Get.find<VehicleSelectionLogic>()
    : Get.put(VehicleSelectionLogic());

  final _formKey = GlobalKey<FormState>();

  VehicleSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.20,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/bg.png',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Obx(
                  () => DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Choose your vehicle type',
                      border: OutlineInputBorder(),
                    ),
                    value: logic.selectedVehicle.value.isEmpty
                        ? null
                        : logic.selectedVehicle.value,
                    items: logic.vehicleOptions.map((String vehicle) {
                      return DropdownMenuItem<String>(
                        value: vehicle,
                        child: Text(vehicle),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        logic.selectedVehicle.value = value;
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a vehicle type';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Textfield(
                  hintKey: 'Car Brand',
                  controller: logic.brandController,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter car brand' : null,
                ),
              ),
              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Textfield(
                  hintKey: 'Model Name',
                  controller: logic.modelNameController,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter model name' : null,
                ),
              ),
              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Textfield(
                  hintKey: 'Number Plate',
                  controller: logic.numberPlateController,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter number plate' : null,
                ),
              ),
              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Textfield(
                  hintKey: 'Color',
                  controller: logic.colorController,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter vehicle color' : null,
                ),
              ),
              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Textfield(
                  hintKey: 'Model Year',
                  controller: logic.modelYearController,
                  inputType: TextInputType.number,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter model year' : null,
                ),
              ),
              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: CustomButton(
                  text: 'Submit',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      logic.onSubmit();
                    }
                  },
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
