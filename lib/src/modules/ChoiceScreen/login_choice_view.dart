import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_ride/src/modules/ChoiceScreen/login_choice_logic.dart';
import 'package:smart_ride/src/modules/customwidget/custom_button.dart';
import 'package:smart_ride/src/modules/utlis/app_fonts.dart';
import 'package:smart_ride/src/modules/utlis/app_images.dart';
import 'package:smart_ride/src/modules/utlis/app_colors.dart';

/// UI for selecting between Driver and Passenger with matched styling
class UserTypeSelectionView extends StatelessWidget {
  const UserTypeSelectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GetBuilder<UserTypeSelectionController>(
      init: UserTypeSelectionController(),
      builder: (controller) {
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
                        'Choose Your Role',
                        style: StyleRefer.poppinsSemiBold.copyWith(
                          fontSize: 22,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Get started as a Driver or Passenger',
                        style: StyleRefer.poppinsRegular.copyWith(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 40),

                      // — Driver Button —
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: CustomButton(
                          text: 'Continue as Driver',
                          onPressed: controller.onDriverPressed,
                          backgroundColor: AppColorss.primary,
                          textColor: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // — Passenger Button —
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: CustomButton(
                          text: 'Continue as Passenger',
                          onPressed: controller.onPassengerPressed,
                          backgroundColor: Colors.white,
                          textColor: AppColorss.primary,
                          borderColor: AppColorss.primary,
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
      },
    );
  }
}
