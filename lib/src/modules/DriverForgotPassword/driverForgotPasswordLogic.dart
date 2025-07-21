import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_ride/src/services/post_service.dart';
import 'package:smart_ride/src/services/url.dart';
import 'package:smart_ride/src/general_controller/GeneralController.dart';
import 'package:smart_ride/src/modules/utlis/keys.dart';

class DriverForgotPasswordController extends GetxController {
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

@override
void onClose() {
  phoneController.clear();
  phoneController.dispose();
  super.onClose();
}


  void onNextPressed(BuildContext context) {
    if (formKey.currentState!.validate()) {
      final formattedPhone = '+92${phoneController.text.trim()}';

      postMethod(
        driverForgotPassword,
        {"phoneNumber": formattedPhone},
        (bool status, dynamic response) {
          if (status) {
            // Clear token to avoid errors in next flow after password reset
            Get.find<GeneralController>().box.remove(AppKeys.authToken);

            // Navigate to OTP verification screen
Get.delete<DriverForgotPasswordController>();
Get.toNamed(
  '/DriverForgotPaswordPassengerVerification',
  arguments: {'phone': formattedPhone},
);

          } else {
            Get.snackbar(
              "Error",
              response?['message'] ?? "Something went wrong",
              backgroundColor: Colors.red.withOpacity(0.8),
              colorText: Colors.white,
            );
          }
        },
        authHeader: false,
      );
    }
  }
}
