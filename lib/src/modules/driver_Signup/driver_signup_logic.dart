import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_ride/src/modules/utlis/keys.dart';
import 'package:smart_ride/src/services/post_service.dart';
import 'package:smart_ride/src/services/url.dart';
import 'package:smart_ride/src/general_controller/GeneralController.dart';
import 'dart:convert'; // For debug print formatting

class DriverSignUpController extends GetxController {
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  void onSignUpPressed(BuildContext context) {
    if (formKey.currentState!.validate()) {
      String formattedPhone = '+92${phoneController.text.trim()}';

      Map<String, dynamic> postData = {
        "phoneNumber": formattedPhone,
      };

      postMethod(
        driverRegister,
        postData,
        (success, response) {
          debugPrint(
            '📥 API Response:\n${const JsonEncoder.withIndent('  ').convert(response)}',
          );

          if (success) {
            final token = response['phoneContextToken'];
            final phone = response['data']['phoneNumber'];

            if (token != null) {
              Get.find<GeneralController>().box.write(AppKeys.authToken, token);
              debugPrint("🪪 Token saved after signup: $token");
            }

            Get.toNamed('/driver-signup-verification', arguments: {
              'phone': phone,
              'token': token,
            });
          } else {
            Get.snackbar("Error", response['message'] ?? 'Signup failed');
          }
        },
      );
    }
  }

  void goBack() {
    Get.back();
  }
}
