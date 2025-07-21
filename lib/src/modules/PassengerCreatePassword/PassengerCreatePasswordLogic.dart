
import 'dart:developer'; // ✅ Added for logging in debug console

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:smart_ride/src/general_controller/GeneralController.dart';
import 'package:smart_ride/src/modules/customwidget/token_utils.dart';

import 'package:smart_ride/src/services/url.dart';
import 'package:smart_ride/src/modules/utlis/keys.dart';

class PassengerCreatePasswordController extends GetxController {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();


  late String phone;

  @override
  void onInit() {
    super.onInit();
    phone = Get.arguments['phone'] ?? '';
    log("📲 Phone received in password screen: $phone"); // ✅ Log phone passed in arguments

    final token = Get.find<GeneralController>().box.read(AppKeys.authToken);
    if (token != null && token.isNotEmpty) {
      log("🔐 Token available before setting password: $token"); // ✅ Log token received after verification
    } else {
      log("⚠️ No token found in storage before setting password");
    }
  }

  bool isValidPassword(String password) {
    final regex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    );
    return regex.hasMatch(password);
  }

  void onResetPressed(GlobalKey<FormState> formKey) async {
  if (!formKey.currentState!.validate()) return;
    final password = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (!isValidPassword(password)) {
      Get.snackbar("Invalid Password",
          "Password must be at least 8 characters long, include upper & lowercase letters, a number, and a special character.",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    Map<String, dynamic> postData = {
      "phoneNumber": phone,
      "password": password,
      "confirmPassword": confirmPassword,
    };

    Get.find<GeneralController>().changeLoaderCheck(true);

    try {
      final token = await getValidTokenOrLogout();
      if (token == null) return;

      log("🔐 Using token to set password: $token"); // ✅ Log token being used

      final response = await Dio().post(
        passengerSetPassword,
        data: postData,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }),
      );

      Get.find<GeneralController>().changeLoaderCheck(false);

      final responseData = response.data;
      log('📥 Set Password API Response: $responseData'); // ✅ Log response body

      final newToken = responseData['token'] ?? responseData['contextToken'];
      if (newToken != null && newToken.isNotEmpty) {
        final box = Get.find<GeneralController>().box;
        box.write(AppKeys.authToken, newToken);
        log('✅ Token saved after password setup: $newToken');
        final user = responseData['data']['passenger'];
  if (user != null) {
    box.write(AppKeys.userId, user['_id']);
    box.write(AppKeys.userRole, user['userType']);
    log('👤 Saved userId: ${user['_id']} and userType: ${user['userType']}');
  }


      } else {
        log('ℹ️ No new token returned, using existing token');
      }

      Get.find<GeneralController>().box.write(AppKeys.userRole, 'passenger');

      Get.snackbar("Success", "Password set successfully!",
          backgroundColor: Colors.green, colorText: Colors.white);

      Future.delayed(const Duration(milliseconds: 800), () {
        Get.offAllNamed('/passengerLogin');
      });
    } catch (e) {
      Get.find<GeneralController>().changeLoaderCheck(false);
      final errorMsg = e is DioError && e.response != null
          ? e.response!.data['message'] ?? 'Something went wrong'
          : 'Something went wrong';

      log("❌ Password setup failed: $e"); // ✅ Log error
      Get.snackbar("Failed", errorMsg,
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
