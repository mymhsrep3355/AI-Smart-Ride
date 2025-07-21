import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_ride/src/modules/customwidget/custom_button.dart';
import 'group_posting_logic.dart';

class GroupPostingView extends GetView<GroupPostingLogic> {
  const GroupPostingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  "assets/images/top.png",
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                ),
                const Positioned(
                  top: 100,
                  left: 16,
                  child: Text(
                    'Create a group!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    buildTextField(
                      controller: controller.groupNameController,
                      label: "Group Name",
                      errorText: controller.groupNameError,
                    ),
                    buildTextField(
                      controller: controller.venueController,
                      label: "Venue",
                      errorText: controller.venueError,
                    ),
                    buildTextField(
                      controller: controller.daysController,
                      label: "Number of Days",
                      keyboardType: TextInputType.number,
                      errorText: controller.daysError,
                    ),
                    GestureDetector(
                      onTap: () => controller.pickDate(context),
                      child: AbsorbPointer(
                        child: buildTextField(
                          controller: controller.dateController,
                          label: "Select Date",
                          errorText: controller.dateError,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.pickTime(context),
                      child: AbsorbPointer(
                        child: buildTextField(
                          controller: controller.timeController,
                          label: "Select Time",
                          errorText: controller.timeError,
                        ),
                      ),
                    ),
                    buildTextField(
                      controller: controller.descriptionController,
                      label: "Trip Description",
                      maxLines: 5,
                      errorText: controller.descriptionError,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CustomButton(
                text: "Post",
                onPressed: () {
                  controller.postGroup();
                },
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CustomButton(
                text: "Explore All Groups",
                onPressed: () => Get.back(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    RxString? errorText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    if (errorText == null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
      );
    } else {
      return Obx(() => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
                errorText:
                    errorText.value.isEmpty ? null : errorText.value,
              ),
            ),
          ));
    }
  }
}
