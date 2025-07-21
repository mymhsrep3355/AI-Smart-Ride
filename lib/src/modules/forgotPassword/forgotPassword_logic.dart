import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  void onNextPressed(BuildContext context) {
    if (formKey.currentState!.validate()) {
      final formattedPhone = '+92${phoneController.text.trim()}';

      // Navigate to verification screen with phone number
      Get.toNamed('/ForgotPaswordPassengerVerification', arguments: {
        'phone': formattedPhone,
      });
    }
  }

  
}
