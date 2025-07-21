import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_ride/src/modules/WelcomeDriverScreen/welcome_driver_logic.dart';
import 'package:smart_ride/src/modules/customwidget/custom_button.dart';
import 'package:smart_ride/src/modules/utlis/app_colors.dart';
import 'package:smart_ride/src/modules/utlis/app_fonts.dart';
import 'package:smart_ride/src/modules/utlis/app_images.dart';

/// Pure UI layer. No business logic here – we delegate that to [WelcomeController].
class WelcomeDriverView extends GetView<WelcomeDriverController> {
  const WelcomeDriverView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 60, bottom: 20),
              child: Column(
                children: [
                  // — Logo —
                  Image.asset(AppImages.logo, height: 80),

                  const SizedBox(height: 20),

                  // — Headline —
                  Text(
                    'Welcome to SmartRide',
                    style: StyleRefer.poppinsSemiBold.copyWith(
                      fontSize: 22,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Join SmartRide – your journey, your fare, your choice!',
                    style: StyleRefer.poppinsRegular.copyWith(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  // — Login —
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: CustomButton(
                      text: 'Login',
                      onPressed: controller.goToLogin,
                      backgroundColor: AppColors.primary,
                      textColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // — Sign‑up —
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: CustomButton(
                      text: 'Sign Up',
                      onPressed: controller.goToSignUp,
                      backgroundColor: Colors.white,
                      textColor: AppColors.primary,
                      borderColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // — Bottom Illustration —
          SizedBox(
            height: size.height * 0.2,
            width: double.infinity,
            child: Image.asset(
              AppImages.background,
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
          ),
        ],
      ),
    );
  }
}
