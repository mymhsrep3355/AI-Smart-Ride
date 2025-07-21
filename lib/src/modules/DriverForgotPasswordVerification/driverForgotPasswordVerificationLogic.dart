import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverForgotPasswordVerificationController extends GetxController {
  final codeController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }

void onContinuePressed() {
  if (formKey.currentState!.validate()) {
    Get.delete<DriverForgotPasswordVerificationController>();
    Get.toNamed('/DriverResetPassword', arguments: {
      'code': codeController.text.trim(),
    });
  }
}

void goBack() {
  Get.delete<DriverForgotPasswordVerificationController>();
  Get.back();
}

}
