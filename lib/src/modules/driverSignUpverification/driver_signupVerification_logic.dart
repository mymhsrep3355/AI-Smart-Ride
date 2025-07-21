import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_ride/src/general_controller/GeneralController.dart';
import 'package:smart_ride/src/modules/utlis/keys.dart';
import 'package:smart_ride/src/services/post_service.dart';
import 'package:smart_ride/src/services/url.dart';

class DriverSignUpVerificationController extends GetxController {
  final codeController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  late String phone;
  late String phoneContextToken;

  @override
  void onInit() {
    super.onInit();
    phone = Get.arguments['phone'] ?? '';
    phoneContextToken = Get.arguments['token'] ?? '';

    debugPrint('🪪 Received phoneContextToken for verification: $phoneContextToken');
  }

  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }

void onContinuePressed() {
  if (formKey.currentState!.validate()) {
    Map<String, dynamic> postData = {
      "phoneNumber": phone,
      "code": codeController.text.trim(),
    };

    postMethod(
      driverVerify,
      postData,
      (success, response) {
        debugPrint('📥 Verification API Response: $response');

        if (success) {
          final resetToken = response['resetToken'];
          if (resetToken != null) {
            // ✅ Save the reset token
            Get.find<GeneralController>().box.write(AppKeys.authToken, resetToken);
            debugPrint("✅ Token saved after verification: $resetToken");

            // ✅ Navigate to password screen with phone + token
            Get.toNamed('/driverCreatePassword', arguments: {
              'phone': phone,
              'token': resetToken,
            });
          } else {
            debugPrint("⚠️ resetToken not found in response");
            Get.snackbar("Error", "Token missing in response");
          }
        } else {
          Get.snackbar("Verification Failed", response['message'] ?? 'Invalid code');
        }
      },
      headers: {
        'Authorization': 'Bearer $phoneContextToken',
      },
    );
  }
}


  void goBack() {
    Get.back();
  }
}
