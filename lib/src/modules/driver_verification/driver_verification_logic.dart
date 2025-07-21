import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverVerificationController extends GetxController {
  final codeController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }

  void onContinuePressed() {
    if (formKey.currentState!.validate()) {
        Get.offAllNamed('/driver-home');
    }
  }

  void goBack() {
    Get.back();
  }
}
