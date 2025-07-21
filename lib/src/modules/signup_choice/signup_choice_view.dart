import 'package:flutter/material.dart';
import 'package:smart_ride/src/modules/signup_choice/signup_choice_logic.dart';
import 'package:get/get.dart';
import 'package:smart_ride/src/modules/customwidget/custom_button.dart';
import 'package:smart_ride/src/modules/utlis/app_images.dart';
import 'package:smart_ride/src/modules/utlis/app_colors.dart';

class SignUpTypeSelectionView extends StatelessWidget {
  const SignUpTypeSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpTypeSelectionController>(
      init: SignUpTypeSelectionController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // Top background image with back arrow
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 800 / 230,
                      child: Image.asset(
                        AppImages.bg,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    Positioned(
                        top: 16,
                        left: 16,
                        child: GestureDetector(
                          onTap: () => Get.back(),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                // Centered buttons
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: CustomButton(
                          text: 'Continue as Driver',
                          backgroundColor: AppColorss.primary,
                          textColor: Colors.white,
                          onPressed: controller.onDriverPressed,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: CustomButton(
                          text: 'Continue as Passenger',
                          backgroundColor: AppColorss.primary,
                          textColor: Colors.white,
                          onPressed: controller.onPassengerPressed,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
