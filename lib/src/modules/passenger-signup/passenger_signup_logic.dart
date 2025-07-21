import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_ride/src/services/post_service.dart';
import 'package:smart_ride/src/services/url.dart';
import 'package:smart_ride/src/general_controller/GeneralController.dart';
import 'package:smart_ride/src/modules/utlis/keys.dart';

class PassengerSignUpController extends GetxController {
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  void onSignUpPressed(BuildContext context, GlobalKey<FormState> formKey) {
    if (!formKey.currentState!.validate()) return;
    if (formKey.currentState!.validate()) {
      String formattedPhone = '+92${phoneController.text.trim()}';

      Map<String, dynamic> postData = {
        "phoneNumber": formattedPhone,
      };

      print("🚀 SignUp pressed. Sending data: $postData");

      // ✅ Show loader
      Get.find<GeneralController>().changeLoaderCheck(true);

      postMethod(
        passengerRegister,
        postData,
        (success, response) {
          // ✅ Hide loader
          Get.find<GeneralController>().changeLoaderCheck(false);

          print("✅ Callback hit");
          print("🔁 Full response: $response");

          if (success) {
            final token = response['token'] ?? response['contextToken'];
            print("📦 Token received: $token");

            if (token != null) {
              final box = Get.find<GeneralController>().box;
              box.write(AppKeys.authToken, token);
              box.write(AppKeys.userRole, "passenger");
            }

            // ✅ Navigate to OTP verification screen
            Get.toNamed('/passenger-signup-verification', arguments: {
              'phone': formattedPhone,
              'token': token,
            });
          } else {
            print("❌ Signup failed: ${response['message']}");
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
