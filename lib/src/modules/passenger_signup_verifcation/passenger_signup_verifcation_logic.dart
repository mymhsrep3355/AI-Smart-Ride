
import 'dart:developer'; // ✅ Added for better console logs

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_ride/src/general_controller/GeneralController.dart';
import 'package:smart_ride/src/modules/customwidget/token_utils.dart';
import 'package:smart_ride/src/modules/utlis/keys.dart';
import 'package:smart_ride/src/services/url.dart';

class PassengerSignUpVerificationController extends GetxController {
  final codeController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  late String phone;
  late String token;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>;

    phone = args['phone'] ?? '';
    token = args['token'] ?? '';

    if (token.isNotEmpty) {
      final box = Get.find<GeneralController>().box;
      box.write(AppKeys.authToken, token);
      log("✅ Token received from signup and stored: $token"); // ✅ Changed from print
    } else {
      final storedToken =
          Get.find<GeneralController>().box.read(AppKeys.authToken);
      log("📦 Token fetched from storage: $storedToken"); // ✅ Changed from print
    }
  }

  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }

  void onContinuePressed() async {
    if (formKey.currentState!.validate()) {
      final verificationCode = codeController.text.trim();

      Map<String, dynamic> postData = {
        "phoneNumber": phone,
        "code": verificationCode,
      };

      Get.find<GeneralController>().changeLoaderCheck(true);

      try {
        final token = await getValidTokenOrLogout(); // token from storage or args
        if (token == null) return;

        log("🚀 Sending verification request with data: $postData"); // ✅ Changed from print
        log("🔐 Using token: $token"); // ✅ Changed from print

        final response = await Dio().post(
          passengerVerify,
          data: postData,
          options: Options(headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          }),
        );

        Get.find<GeneralController>().changeLoaderCheck(false);

        final responseData = response.data;
        log("📥 FULL Verification API Response: $responseData"); // ✅ Added

        // ✅ Check if contextToken or token exists in response
        if (responseData.containsKey('token') || responseData.containsKey('contextToken')) {
          final newToken = responseData['token'] ?? responseData['contextToken'];
          log("✅ Token received after verification: $newToken"); // ✅ Added

          final box = Get.find<GeneralController>().box;
          box.write(AppKeys.authToken, newToken);
        } else {
          log("⚠️ No token returned in verification response"); // ✅ Added
        }

        // ✅ Save user role
        Get.find<GeneralController>().box.write(AppKeys.userRole, "passenger");

        // ✅ Go to password screen
        Get.toNamed('/passengerCreatePassword', arguments: {
          'phone': phone,
        });
      } catch (e) {
        Get.find<GeneralController>().changeLoaderCheck(false);

        final errorResponse = e is DioError && e.response != null
            ? e.response!.data
            : {'message': 'Verification failed. Try again later.'};

        log("❌ Verification error: $e"); // ✅ Added
        log("❌ Error response body: $errorResponse"); // ✅ Added
        Get.snackbar("Verification Failed", errorResponse['message']);
      }
    }
  }

  void goBack() {
    Get.back();
  }
}

