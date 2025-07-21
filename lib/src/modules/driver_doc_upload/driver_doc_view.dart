import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smart_ride/src/modules/customwidget/custom_button.dart';
import 'package:smart_ride/src/modules/driver_doc_upload/driver_doc_logic.dart';
import 'package:smart_ride/src/modules/driver_doc_upload/image_preview.dart';

class DocVerificationView extends StatelessWidget {
final logic = Get.isRegistered<DocVerificationLogic>()
    ? Get.find<DocVerificationLogic>()
    : Get.put(DocVerificationLogic());


  DocVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload License'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Front Side of License',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(() => GestureDetector(
                  onTap: () {
                    if (logic.selectedFrontImage.value != null) {
                      Get.to(() => ImagePreviewView(
                            imageFile: logic.selectedFrontImage.value!,
                            onDelete: () {
                              logic.selectedFrontImage.value = null;
                              Get.back();
                              Future.delayed(const Duration(milliseconds: 300),
                                  () {
                                FocusScope.of(context)
                                    .requestFocus(logic.frontFocusNode);
                              });
                            },
                          ));
                    } else {
                      logic.showImageSourceSelection(isFront: true);
                    }
                  },
                  onLongPress: () {
                    if (logic.selectedFrontImage.value != null) {
                      Get.defaultDialog(
                        title: 'Delete Image?',
                        middleText: 'Do you want to delete the front image?',
                        textConfirm: 'Yes',
                        textCancel: 'No',
                        confirmTextColor: Colors.white,
                        onConfirm: () {
                          logic.selectedFrontImage.value = null;
                          Get.back();
                        },
                      );
                    }
                  },
                  child: logic.selectedFrontImage.value == null
                      ? Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.add_a_photo, size: 50),
                        )
                      : Image.file(
                          logic.selectedFrontImage.value!,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                )),
            Obx(() => logic.frontErrorText.value.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      logic.frontErrorText.value,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : const SizedBox()),
            const SizedBox(height: 24),
            const Text(
              'Back Side of License',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(() => GestureDetector(
                  onTap: () {
                    if (logic.selectedBackImage.value != null) {
                      Get.to(() => ImagePreviewView(
                            imageFile: logic.selectedBackImage.value!,
                            onDelete: () {
                              logic.selectedBackImage.value = null;
                              Get.back();
                              Future.delayed(const Duration(milliseconds: 300),
                                  () {
                                FocusScope.of(context)
                                    .requestFocus(logic.backFocusNode);
                              });
                            },
                          ));
                    } else {
                      logic.showImageSourceSelection(isFront: false);
                    }
                  },
                  onLongPress: () {
                    if (logic.selectedBackImage.value != null) {
                      Get.defaultDialog(
                        title: 'Delete Image?',
                        middleText: 'Do you want to delete the back image?',
                        textConfirm: 'Yes',
                        textCancel: 'No',
                        confirmTextColor: Colors.white,
                        onConfirm: () {
                          logic.selectedBackImage.value = null;
                          Get.back();
                        },
                      );
                    }
                  },
                  child: logic.selectedBackImage.value == null
                      ? Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.add_a_photo, size: 50),
                        )
                      : Image.file(
                          logic.selectedBackImage.value!,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                )),
            Obx(() => logic.backErrorText.value.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      logic.backErrorText.value,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : const SizedBox()),
            const SizedBox(height: 30),
            CustomButton(
              text: "Submit",
              onPressed: () {
                // Simple validation before calling API
                bool isValid = true;

                if (logic.selectedFrontImage.value == null) {
                  logic.frontErrorText.value =
                      'Please upload front side image.';
                  isValid = false;
                }
                if (logic.selectedBackImage.value == null) {
                  logic.backErrorText.value = 'Please upload back side image.';
                  isValid = false;
                }

                if (isValid) {
                  logic.uploadLicenseImages();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
