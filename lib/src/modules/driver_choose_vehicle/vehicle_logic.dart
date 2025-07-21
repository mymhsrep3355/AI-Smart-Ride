import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

import 'package:smart_ride/src/modules/driver_login/driver_login_view.dart';
import 'package:smart_ride/src/services/url.dart';
import 'package:smart_ride/src/general_controller/GeneralController.dart';
import 'package:smart_ride/src/modules/utlis/keys.dart';

class VehicleSelectionLogic extends GetxController {
  final RxString selectedVehicle = ''.obs;

  final TextEditingController brandController = TextEditingController();
  final TextEditingController modelNameController = TextEditingController();
  final TextEditingController numberPlateController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController modelYearController = TextEditingController();

  final List<String> vehicleOptions = [
    'mini car',
    'bike',
    'auto',
    'ac car',
    'tourbus',
  ];

  final Map<String, String> vehicleTypeMap = {
    'mini car': 'mini car',
    'bike': 'bike',
    'auto': 'auto',
    'ac car': 'ac car',
    'tourbus':'tourbus',
  };

  String token = '';
  final dioClient = dio.Dio();

  @override
  void onInit() {
    super.onInit();

    token = Get.find<GeneralController>().box.read(AppKeys.authToken) ?? '';
    print('🔐 Token in VehicleSelectionLogic: $token');

    if (token.isNotEmpty) {
      dioClient.options.headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
    }
  }

  void onSubmit() async {
    if (selectedVehicle.value.isEmpty ||
        brandController.text.isEmpty ||
        modelNameController.text.isEmpty ||
        numberPlateController.text.isEmpty ||
        colorController.text.isEmpty ||
        modelYearController.text.isEmpty) {
      Get.snackbar('Missing Info', 'Please fill in all fields',
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    if (token.isEmpty) {
      Get.snackbar('Error', 'Authorization token is missing',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final postData = {
      "type": vehicleTypeMap[selectedVehicle.value],
      "brand": brandController.text.trim(),
      "name": modelNameController.text.trim(),
      "modelYear": int.tryParse(modelYearController.text.trim()) ?? 0,
      "numberPlate": numberPlateController.text.trim(),
      "color": colorController.text.trim(),
    };

    print('🚀 Submitting vehicle info: $postData');
    print('🔐 Token: $token');

    try {
      final response =
          await dioClient.post(driverVehicleSelection, data: postData);

      print('✅ Vehicle response: ${response.statusCode}');
      print('✅ Response body: ${response.data}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        Get.snackbar('✅ Success',
            response.data['message'] ?? 'Vehicle registered successfully',
            backgroundColor: Colors.green, colorText: Colors.white);

        Get.offAll(() => DriverLoginView());
      } else {
        Get.snackbar('❌ Failed',
            response.data['message'] ?? 'Vehicle registration failed',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      if (e is dio.DioError) {
        print("❗ DioError: ${e.response?.data}");
        Get.snackbar("Error", e.response?.data['message'] ?? e.message,
            backgroundColor: Colors.orange, colorText: Colors.white);
      } else {
        print("❗ Unexpected error: $e");
        Get.snackbar("Error", "Unexpected error occurred",
            backgroundColor: Colors.orange, colorText: Colors.white);
      }
    }
  }

  @override
  void onClose() {
    brandController.dispose();
    modelNameController.dispose();
    numberPlateController.dispose();
    colorController.dispose();
    modelYearController.dispose();
    super.onClose();
  }
}
