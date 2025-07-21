import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_ride/src/modules/DriverResetPassword/driverResetPasswordLogic.dart';
import 'package:smart_ride/src/modules/customwidget/textfields.dart';
import 'package:smart_ride/src/modules/utlis/app_colors.dart';
import 'package:smart_ride/src/modules/utlis/app_fonts.dart';
import 'package:smart_ride/src/modules/utlis/app_images.dart';

class DriverResetPasswordView extends StatelessWidget {
  const DriverResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverResetPasswordController>(
      init: DriverResetPasswordController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Top image
                  AspectRatio(
                    aspectRatio: 800 / 230,
                    child: Image.asset(
                      AppImages.bg,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),

                  // Form Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 32),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create New Password',
                            style: StyleRefer.poppinsBold.copyWith(
                              fontSize: 22,
                              color: AppColorss.text,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your new password must be different from the old one.',
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
                                return 'Password must be at least 8 characters,\ninclude upper & lower case, number & symbol';
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
                              } else if (value !=
                                  controller.newPasswordController.text) {
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
                                'Reset Password',
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
        );
      },
    );
  }
}
