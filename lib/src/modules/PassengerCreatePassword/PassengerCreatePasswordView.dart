import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_ride/src/modules/PassengerCreatePassword/PassengerCreatePasswordLogic.dart';
import 'package:smart_ride/src/modules/customwidget/textfields.dart';
import 'package:smart_ride/src/modules/utlis/app_colors.dart';
import 'package:smart_ride/src/modules/utlis/app_fonts.dart';
import 'package:smart_ride/src/modules/utlis/app_images.dart';
import 'package:smart_ride/src/modules/customwidget/app_loading.dart';

class PassengerCreatePasswordView extends StatelessWidget {
  const PassengerCreatePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return GetBuilder<PassengerCreatePasswordController>(
      init: PassengerCreatePasswordController(),
      builder: (controller) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Header image
                      AspectRatio(
                        aspectRatio: 800 / 230,
                        child: Image.asset(
                          AppImages.bg,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),

                      // Form
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 32),
                        child: Form(
                          key: _formKey,
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
                                  } else if (!controller
                                      .isValidPassword(value)) {
                                    return 'Must be 8+ chars, include upper, lower,\nnumber & special character';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              Textfield(
                                hintKey: 'Confirm Password',
                                icon: Icons.lock_outline,
                                controller:
                                    controller.confirmPasswordController,
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
                                  onPressed: () =>
                                      controller.onResetPressed(_formKey),
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

            // ✅ Loader overlay
            AppLoadingWidget.loadingBar(),
          ],
        );
      },
    );
  }
}
