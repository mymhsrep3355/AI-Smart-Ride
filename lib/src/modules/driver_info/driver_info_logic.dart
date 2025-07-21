import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_ride/src/services/url.dart';
import 'package:dio/dio.dart' as dio;
import 'package:smart_ride/src/general_controller/GeneralController.dart';
import 'package:smart_ride/src/modules/utlis/keys.dart';

import '../driver_doc_upload/driver_doc_view.dart';

class DriverInfoLogic extends GetxController {
  final Rx<File?> selectedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController cnicController = TextEditingController();

  final RxString errorText = ''.obs;
  final formKey = GlobalKey<FormState>();
  final dioClient = dio.Dio();
  String token = '';

  @override
  void onInit() {
    super.onInit();

    // ✅ Load token from GetStorage
    token = Get.find<GeneralController>().box.read(AppKeys.authToken) ?? '';
    print('🔐 Token loaded from storage in DriverInfoLogic: $token');

    if (token.isNotEmpty) {
      dioClient.options.headers['Authorization'] = 'Bearer $token';
    } else {
      print('⚠️ No token found in storage');
    }
  }

  Future<void> takeSelfie() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
      errorText.value = '';
    } else {
      errorText.value = 'Selfie not taken.';
    }
  }

  void deleteSelfie() {
    selectedImage.value = null;
  }

  bool validateSelfie() {
    if (selectedImage.value == null) {
      errorText.value = 'Please upload a selfie.';
      return false;
    }
    errorText.value = '';
    return true;
  }

  Future<void> submitDriverInfo() async {
    print('🚀 submitDriverInfo: using token -> $token');

    dioClient.options.headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final body = {
      "name": nameController.text.trim(),
      "cnic": cnicController.text.trim(),
    };

    try {
      final response = await dioClient.post(driverInfo, data: body);

      print('✅ Response status: ${response.statusCode}');
      print('✅ Response body: ${response.data}');

      if (response.statusCode == 200 && response.data['success'] == true) {
  final generalController = Get.find<GeneralController>();

  // ✅ Save to observable variables
  generalController.driverName.value = nameController.text.trim();
  generalController.driverCNIC.value = cnicController.text.trim();

  // ✅ Also save to GetStorage so it's available later
  generalController.box.write('driverName', nameController.text.trim());
  generalController.box.write('driverCNIC', cnicController.text.trim());
        await uploadSelfie();
      } else {
        print('❌ Response: ${response.data}');
        Get.snackbar(
            "Failed", response.data['message'] ?? "Something went wrong",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      if (e is dio.DioError) {
        print('❗ DioError: ${e.message}');
        print('❗ Response: ${e.response?.data}');
      } else {
        print('❗ Error: $e');
      }

      Get.snackbar("Error", "Failed to submit driver info",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> uploadSelfie() async {
    if (selectedImage.value == null) {
      Get.snackbar("Error", "Please select a selfie first",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      final filePath = selectedImage.value!.path;
      final fileName = filePath.split('/').last;

      print('📤 Uploading selfie...');
      print('📸 File path: $filePath');
      print('📎 File name: $fileName');
      print('🔐 Token: $token');

      dioClient.options.headers = {
        'Authorization': 'Bearer $token', // ✅ No manual content-type
      };

      final formData = dio.FormData.fromMap({
        "selfie": await dio.MultipartFile.fromFile(
          filePath,
          filename: fileName,
          contentType: MediaType("image", "jpeg"),
        ),
      });

      final response = await dioClient.post(driverSelfie, data: formData);

      print('✅ Response Code: ${response.statusCode}');
      print('✅ Response Data: ${response.data}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        Get.snackbar("Success", "Selfie uploaded successfully",
            backgroundColor: Colors.blue, colorText: Colors.white);
        Get.to(() => DocVerificationView());
      } else {
        Get.snackbar(
            "Upload Failed", response.data['message'] ?? "Upload failed",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      if (e is dio.DioError) {
        print('❗ DioError: ${e.message}');
        print('❗ DioError response: ${e.response?.data}');
        Get.snackbar("Upload Error", e.response?.data['message'] ?? e.message,
            backgroundColor: Colors.orange, colorText: Colors.white);
      } else {
        print('❗ Unexpected error: $e');
        Get.snackbar("Upload Error", "Unexpected error",
            backgroundColor: Colors.orange, colorText: Colors.white);
      }
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    cnicController.dispose();
    super.onClose();
  }
}
