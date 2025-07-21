import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_ride/src/modules/passenger-signup/passenger_signup_logic.dart';
import 'package:smart_ride/src/modules/customwidget/textfields.dart';
import 'package:smart_ride/src/modules/utlis/app_colors.dart';
import 'package:smart_ride/src/modules/utlis/app_fonts.dart';
import 'package:smart_ride/src/modules/utlis/app_icons.dart';
import 'package:smart_ride/src/modules/utlis/app_images.dart';
import 'package:smart_ride/src/modules/utlis/app_strings.dart';
import 'package:smart_ride/src/modules/customwidget/app_loading.dart';

class PassengerSignUpView extends StatelessWidget {
  const PassengerSignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return GetBuilder<PassengerSignUpController>(
      init: PassengerSignUpController(),
      builder: (controller) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Header Image + Back Button
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
                              onTap: controller.goBack,
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

                      // Signup Form
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
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Texts.signUp,
                                style: StyleRefer.poppinsBold.copyWith(
                                  fontSize: 22,
                                  color: AppColorss.text,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                Texts.belowLogin,
                                style: StyleRefer.poppinsRegular.copyWith(
                                  fontSize: 14,
                                  color: AppColorss.text.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Textfield(
                                hintKey: 'Phone Number',
                                icon: AppIconss.phone,
                                controller: controller.phoneController,
                                inputType: TextInputType.phone,
                                isPhone: true,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter phone number';
                                  } else if (value.length != 10) {
                                    return 'Phone number must be 10 digits after +92';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: () => controller.onSignUpPressed(
                                      context, _formKey),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    Texts.signUp,
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

            // ✅ Loading overlay
            AppLoadingWidget.loadingBar(),
          ],
        );
      },
    );
  }
}
