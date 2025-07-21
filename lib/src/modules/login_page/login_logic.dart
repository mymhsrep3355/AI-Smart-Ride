

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_ride/src/general_controller/GeneralController.dart';
import 'package:smart_ride/src/modules/chat_page/chat_page_logic.dart';
import 'package:smart_ride/src/modules/utlis/keys.dart';
import 'package:smart_ride/src/services/url.dart';

class LoginController extends GetxController {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
  void onLoginPressed() {}

  void goToSignUp() {
    Get.toNamed('/passenger-signup');
  }

  void onForgotPassword() {
    Get.toNamed('/passengerForgotPassword');
  }


void loginUser(GlobalKey<FormState> formKey) async {
  if (!formKey.currentState!.validate()) return;

  final phone = '+92${phoneController.text.trim()}';
  final password = passwordController.text.trim();

  final dioClient = dio.Dio();
  dioClient.options.headers = {
    'Content-Type': 'application/json',
  };

  final loginData = {
    'phoneNumber': phone,
    'password': password,
  };

  try {
    final response = await dioClient.post(passengerLogin, data: loginData);

    if (response.statusCode == 200 && response.data['success'] == true) {
      final token = response.data['data']['token'] ?? response.data['data']['contextToken'];
      final user = response.data['data']['passenger'];
      final userId = user['_id'];
      final role = user['userType'];

      final box = Get.find<GeneralController>().box;
      box.write(AppKeys.authToken, token);
      box.write(AppKeys.userId, userId);
      box.write(AppKeys.userRole, role);

      print('📥 Login successful for user: $userId');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      Get.snackbar("Success", "Login successful!",
          backgroundColor: Colors.blue, colorText: Colors.white);

      // Go to home screen first
      await Get.offAllNamed('/home');

      // ✅ Delay and load joined groups
      Future.delayed(Duration(milliseconds: 400), () {
        final groupKey = 'joinedGroups_$userId';
        final storedGroups = box.read(groupKey);
        print('📦 Loaded groups after login: $storedGroups');

        if (Get.isRegistered<ChatPageLogic>()) {
          final chatLogic = Get.find<ChatPageLogic>();
          chatLogic.loadJoinedGroups();
        } else {
          print("❗ ChatPageLogic not registered at login. It will auto-load on home init.");
        }
      });
    } else {
      Get.snackbar("Login Failed", response.data['message'] ?? "Something went wrong",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  } catch (e) {
    Get.snackbar("Error", "Unexpected error", backgroundColor: Colors.orange, colorText: Colors.white);
  }
}

}
