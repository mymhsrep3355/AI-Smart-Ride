import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_ride/src/general_controller/GeneralController.dart';
import 'package:smart_ride/src/modules/utlis/keys.dart';
import 'package:smart_ride/src/services/url.dart';

class DriverLoginController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void goToSignUp() => Get.toNamed('/driver-signup');

  void onForgotPassword() => Get.toNamed('/driverForgotPassword');

  void loginUser() async {
    if (!formKey.currentState!.validate()) return;

    final phone = '+92${phoneController.text.trim()}';
    final password = passwordController.text.trim();

    final dioClient = dio.Dio();
    dioClient.options.headers = {'Content-Type': 'application/json'};

    final loginData = {'phoneNumber': phone, 'password': password};

    try {
      final response = await dioClient.post(driverLogin, data: loginData);
      print('📬 Login Response: ${response.statusCode} - ${response.data}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final token = response.data['data']['token'];
        final user = response.data['data']['driver'];
        final userId = user['_id'];
        final role = user['userType'];

        final box = Get.find<GeneralController>().box;
        box.write(AppKeys.authToken, token);
        box.write(AppKeys.userId, userId);
        box.write(AppKeys.userRole, role);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        Get.snackbar("Success", "Login successful!",
            backgroundColor: Colors.blue, colorText: Colors.white);

        // Delay before navigating to prevent rebuild issues
        Future.delayed(const Duration(milliseconds: 500), () {
          if (Get.isRegistered<DriverLoginController>()) {
            Get.delete<DriverLoginController>();
          }
          Get.offAllNamed('/driver-home');
        });
      } else {
        Get.snackbar("Login Failed", response.data['message'] ?? "Something went wrong",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      if (e is dio.DioError) {
        print("❗ DioError: ${e.response?.data}");
        Get.snackbar("Error", e.response?.data['message'] ?? e.message,
            backgroundColor: Colors.orange, colorText: Colors.white);
      } else {
        print("❗ Unexpected error: ${e.toString()}");
        Get.snackbar("Error", "Unexpected error occurred",
            backgroundColor: Colors.orange, colorText: Colors.white);
      }
    }
  }
}
