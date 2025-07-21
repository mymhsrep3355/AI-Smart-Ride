import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  bool isValidPassword(String password) {
    // Must be at least 8 chars, contain upper, lower, digit and special character
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    return regex.hasMatch(password);
  }

  void onResetPressed() {
    if (formKey.currentState!.validate()) {
      Get.snackbar(
        "Password Reset",
        "Your password has been successfully updated.",
        backgroundColor: Colors.blueAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
      );

      Future.delayed(const Duration(milliseconds: 800), () {
        Get.offAllNamed('/home');
      });
    }
  }
}
