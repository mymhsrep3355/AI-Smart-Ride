import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_ride/src/general_controller/GeneralController.dart';
import 'package:smart_ride/src/modules/driver_info/driver_info_view.dart';
import 'package:smart_ride/src/services/post_service.dart';
import 'package:smart_ride/src/services/url.dart';
import 'package:smart_ride/src/modules/utlis/keys.dart';

class DriverCreatePasswordController extends GetxController {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  late String phone;
  String? resetToken;

  @override
  void onInit() {
    super.onInit();
    phone = Get.arguments['phone'] ?? '';
    resetToken = Get.arguments['token'];
    debugPrint("🔐 Received resetToken: $resetToken");
  }

  bool isValidPassword(String password) {
    final regex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    );
    return regex.hasMatch(password);
  }

  void onResetPressed() {
    if (formKey.currentState!.validate()) {
      final password = newPasswordController.text.trim();
      final confirmPassword = confirmPasswordController.text.trim();

      if (password != confirmPassword) {
        Get.snackbar("Error", "Passwords do not match",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      if (!isValidPassword(password)) {
        Get.snackbar("Invalid Password",
            "Password must be at least 8 characters long, include upper & lower case letters, a number and a special character.",
            backgroundColor: Colors.orange, colorText: Colors.white);
        return;
      }

      if (resetToken == null || resetToken!.isEmpty) {
        Get.snackbar("Error", "Missing reset token. Please go back and verify again.",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      Map<String, dynamic> postData = {
        "phoneNumber": phone,
        "password": password,
        "confirmPassword": confirmPassword,
      };

      debugPrint("📡 Hitting setPassword API with resetToken: $resetToken");

      postMethod(
        driverSetPassword,
        postData,
        (success, response) {
          debugPrint("📥 SetPassword Response: $response");

          // ✅ Handle token safely
          final token = response['data']?['token'];
          if (token != null) {
            debugPrint("✅ Login token: $token");
            Get.find<GeneralController>().box.write(AppKeys.authToken, token);
          } else {
            debugPrint("⚠️ No token found in response.");
          }

          // ✅ Accept even if 'success' is not strictly true but message is good
          final message = response['message']?.toString().toLowerCase() ?? '';
          if (success || message.contains('success')) {
            Get.snackbar("Success", "Password set successfully!",
                backgroundColor: Colors.blue, colorText: Colors.white);

            Future.delayed(const Duration(milliseconds: 800), () {
              debugPrint("🚀 Navigating to DriverInfoView...");
              Get.offAll(() => DriverInfoView());
            });
          } else {
            Get.snackbar("Failed", response['message'] ?? 'Something went wrong',
                backgroundColor: Colors.red, colorText: Colors.white);
          }
        },
        headers: {
          'Authorization': 'Bearer ${resetToken!}',
        },
      );
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
