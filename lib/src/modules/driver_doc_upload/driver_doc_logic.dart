import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http_parser/http_parser.dart';
import 'package:smart_ride/src/services/url.dart';
import 'package:dio/dio.dart' as dio;
import 'package:smart_ride/src/modules/driver_choose_vehicle/vehicle_view.dart';
import 'package:smart_ride/src/general_controller/GeneralController.dart';
import 'package:smart_ride/src/modules/utlis/keys.dart';

class DocVerificationLogic extends GetxController {
  final uploadFrontController = TextEditingController();
  final uploadBackController = TextEditingController();

  final Rx<File?> selectedFrontImage = Rx<File?>(null);
  final Rx<File?> selectedBackImage = Rx<File?>(null);

  final RxString frontErrorText = ''.obs;
  final RxString backErrorText = ''.obs;
  final frontFocusNode = FocusNode();
  final backFocusNode = FocusNode();

  final dioClient = dio.Dio();

  @override
  void onInit() {
    super.onInit();

    // ✅ Set auth header on init
    final token = Get.find<GeneralController>().box.read(AppKeys.authToken) ?? '';
    print('🔐 Using token for license upload: $token');

    dioClient.options.headers = {
      'Authorization': 'Bearer $token',
    };
  }

  Future<void> pickImageFromCamera({required bool isFront}) async {
    final status = await Permission.camera.request();

    if (!status.isGranted) {
      (isFront ? frontErrorText : backErrorText).value =
          'Camera permission is required to take a photo.';
      return;
    }

    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      if (isFront) {
        selectedFrontImage.value = File(pickedFile.path);
        uploadFrontController.text = pickedFile.name;
        frontErrorText.value = '';
      } else {
        selectedBackImage.value = File(pickedFile.path);
        uploadBackController.text = pickedFile.name;
        backErrorText.value = '';
      }
    } else {
      (isFront ? frontErrorText : backErrorText).value = 'No photo taken.';
    }
  }

  Future<void> pickImageFromGallery({required bool isFront}) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      final permission = sdkInt >= 33 ? Permission.photos : Permission.storage;
      final status = await permission.request();

      if (!status.isGranted) {
        (isFront ? frontErrorText : backErrorText).value =
            'Permission is required to select an image.';
        return;
      }
    } else {
      final status = await Permission.photos.request();
      if (!status.isGranted) {
        (isFront ? frontErrorText : backErrorText).value =
            'Permission is required to select an image.';
        return;
      }
    }

    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (isFront) {
        selectedFrontImage.value = File(pickedFile.path);
        uploadFrontController.text = pickedFile.name;
        frontErrorText.value = '';
      } else {
        selectedBackImage.value = File(pickedFile.path);
        uploadBackController.text = pickedFile.name;
        backErrorText.value = '';
      }
    } else {
      (isFront ? frontErrorText : backErrorText).value = 'No image selected.';
    }
  }

  void showImageSourceSelection({required bool isFront}) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Get.back();
                pickImageFromCamera(isFront: isFront);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Get.back();
                pickImageFromGallery(isFront: isFront);
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Cancel'),
              onTap: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> uploadLicenseImages() async {
    final token = Get.find<GeneralController>().box.read(AppKeys.authToken) ?? '';

    if (token.isEmpty) {
      Get.snackbar("Error", "Authorization token is missing",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      final frontPath = selectedFrontImage.value!.path;
      final backPath = selectedBackImage.value!.path;

      final formData = dio.FormData.fromMap({
        "front-page": await dio.MultipartFile.fromFile(
          frontPath,
          filename: frontPath.split('/').last,
          contentType: MediaType("image", "jpeg"),
        ),
        "back-page": await dio.MultipartFile.fromFile(
          backPath,
          filename: backPath.split('/').last,
          contentType: MediaType("image", "jpeg"),
        ),
      });

      final response = await dioClient.post(driverLicenseUpload, data: formData);

      print("✅ License upload response: ${response.data}");

      if (response.statusCode == 200 && response.data['success'] == true) {
        Get.snackbar("Success", "License uploaded successfully!",
            backgroundColor: Colors.blue, colorText: Colors.white);
        Get.to(() => VehicleSelectionView());
      } else {
        Get.snackbar("Upload Failed", response.data['message'] ?? "Upload failed",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      if (e is dio.DioError) {
        print("❗ DioError: ${e.response?.data}");
        Get.snackbar("Error", e.response?.data['message'] ?? e.message,
            backgroundColor: Colors.orange, colorText: Colors.white);
      } else {
        print("❗ Unexpected error: $e");
        Get.snackbar("Error", "Unexpected error occurred",
            backgroundColor: Colors.orange, colorText: Colors.white);
      }
    }
  }

  @override
  void onClose() {
    uploadFrontController.dispose();
    uploadBackController.dispose();
    frontFocusNode.dispose();
    backFocusNode.dispose();
    super.onClose();
  }
}
