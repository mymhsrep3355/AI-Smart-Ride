import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordVerificationController extends GetxController {
  final codeController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }

  void onContinuePressed() {
    if (formKey.currentState!.validate()) {
      Get.toNamed('/resetPassword');
    }
  }

  void goBack() {
    Get.back();
  }
}
