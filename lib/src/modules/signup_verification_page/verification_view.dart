import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:smart_ride/src/modules/customwidget/textfields.dart';
import 'package:smart_ride/src/modules/utlis/app_colors.dart';
import 'package:smart_ride/src/modules/utlis/app_fonts.dart';
import 'package:smart_ride/src/modules/utlis/app_images.dart';
import 'package:smart_ride/src/modules/utlis/app_strings.dart';
import 'verification_logic.dart';

class VerificationView extends StatelessWidget {
  const VerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerificationController>(
      init: VerificationController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Image + Back Button
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
                            Texts.verification,
                            style: StyleRefer.poppinsBold.copyWith(
                              fontSize: 22,
                              color: AppColorss.text,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            Texts.belowVerification,
                            style: StyleRefer.poppinsRegular.copyWith(
                              fontSize: 14,
                              color: AppColorss.text.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 24),
Textfield(
  hintKey: AppHints.code,
  controller: controller.codeController,
  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  maxLength: 4,
  inputType: TextInputType.number,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the code';
    } else if (value.length != 4) {
      return 'Code must be exactly 4 digits';
    }
    return null;
  },
),

                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: controller.onContinuePressed,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                Texts.continued,
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
