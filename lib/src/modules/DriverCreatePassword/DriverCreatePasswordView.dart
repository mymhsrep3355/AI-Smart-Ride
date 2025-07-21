import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_ride/src/modules/DriverCreatePassword/DriverCreatePasswordLogic.dart';
import 'package:smart_ride/src/modules/customwidget/textfields.dart';
import 'package:smart_ride/src/modules/utlis/app_colors.dart';
import 'package:smart_ride/src/modules/utlis/app_fonts.dart';
import 'package:smart_ride/src/modules/utlis/app_images.dart';


class DriverCreatePasswordView extends StatelessWidget {
  const DriverCreatePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
final controller = Get.isRegistered<DriverCreatePasswordController>()
    ? Get.find<DriverCreatePasswordController>()
    : Get.put(DriverCreatePasswordController());

return GetBuilder<DriverCreatePasswordController>(
  builder: (_)  {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Top header image
                      AspectRatio(
                        aspectRatio: 800 / 230,
                        child: Image.asset(
                          AppImages.bg,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                        child: Form(
                          key: controller.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Create Password',
                                style: StyleRefer.poppinsBold.copyWith(
                                  fontSize: 22,
                                  color: AppColorss.text,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Your new password must be different from your old password.',
                                style: StyleRefer.poppinsRegular.copyWith(
                                  fontSize: 14,
                                  color: AppColorss.text.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Textfield(
                                hintKey: 'New Password',
                                icon: Icons.lock,
                                controller: controller.newPasswordController,
                                isPassword: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a new password';
                                  } else if (!controller.isValidPassword(value)) {
                                    return 'Password must be 8+ chars,\ncontain upper, lower, digit & symbol';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              Textfield(
                                hintKey: 'Confirm Password',
                                icon: Icons.lock_outline,
                                controller: controller.confirmPasswordController,
                                isPassword: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  } else if (value != controller.newPasswordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: controller.onResetPressed,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColorss.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    'Set Password',
                                    style: StyleRefer.poppinsSemiBold.copyWith(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ],
        );
      },
    );
  }
}
