import 'package:flutter/material.dart';
import 'package:smart_ride/src/modules/customwidget/custom_button.dart';
import 'package:smart_ride/src/modules/setting_screen/setting_screen_logic.dart';
import 'package:smart_ride/src/modules/utlis/app_colors.dart';
import 'package:get/get.dart';

class SettingsView extends StatelessWidget {
  SettingsView({super.key});

  final SettingsController controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            CustomButton(
              text: 'Delete Account',
              backgroundColor: AppColors.primary,
              borderColor: AppColorss.primary,
              onPressed: controller.deleteAccount,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Log Out',
              backgroundColor: AppColors.primary,
              borderColor: AppColors.primary,
              onPressed: controller.logout,
            ),
          ],
        ),
      ),
    );
  }
}
