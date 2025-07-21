import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'driver_info_logic.dart';

import 'package:smart_ride/src/modules/customwidget/custom_button.dart';
import 'package:smart_ride/src/modules/customwidget/textfields.dart';

class DriverInfoView extends StatelessWidget {
final logic = Get.isRegistered<DriverInfoLogic>()
    ? Get.find<DriverInfoLogic>()
    : Get.put(DriverInfoLogic());


  DriverInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: logic.formKey,
          child: Column(
            children: [
              // Header background
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                width: double.infinity,
                child: Image.asset('assets/images/bg.png', fit: BoxFit.cover),
              ),

              const SizedBox(height: 20),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Personal Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Selfie Capture
              Obx(() {
                return GestureDetector(
                  onTap: () {
                    if (logic.selectedImage.value != null) {
                      _showDeleteDialog(context);
                    } else {
                      logic.takeSelfie();
                    }
                  },
                  child: logic.selectedImage.value == null
                      ? CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.grey.shade300,
                          child: const Icon(Icons.camera_alt, size: 40, color: Colors.black54),
                        )
                      : CircleAvatar(
                          radius: 55,
                          backgroundImage: FileImage(logic.selectedImage.value!),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.blue,
                              child: const Icon(Icons.close, color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                );
              }),

              const SizedBox(height: 25),

              // Name Input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Textfield(
                  hintKey: 'Driver Name',
                  controller: logic.nameController,
                  inputType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 20),

              // CNIC Input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Textfield(
                  hintKey: 'Driver CNIC Number',
                  controller: logic.cnicController,
                  inputType: TextInputType.number,
                  maxLength: 13,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter CNIC number';
                    } else if (!RegExp(r'^\d{13}$').hasMatch(value)) {
                      return 'CNIC must be exactly 13 digits';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 10),

              // Selfie Error
              Obx(() => logic.errorText.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        logic.errorText.value,
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  : const SizedBox()),

              const SizedBox(height: 20),

              // Submit Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: CustomButton(
                    text: "Next",
                    onPressed: () {
                      if (logic.formKey.currentState!.validate() &&
                          logic.validateSelfie()) {
                        logic.submitDriverInfo();
                      }
                    }),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    Get.defaultDialog(
      title: 'Remove Selfie?',
      middleText: 'Do you want to delete the selfie?',
      textCancel: 'Cancel',
      textConfirm: 'Delete',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        logic.deleteSelfie();
      },
    );
  }
}
