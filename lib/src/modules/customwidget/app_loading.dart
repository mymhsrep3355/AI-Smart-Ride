import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_ride/src/modules/utlis/app_colors.dart';
import 'package:smart_ride/src/general_controller/GeneralController.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Platform.isAndroid
          ? const Center(
              child: CircularProgressIndicator(
              color:  AppColors.primary,
            ))
          : const Center(
              child: CupertinoActivityIndicator(
                radius: 20,
                color: AppColors.primary,
              ),
            ),
    );
  }
}

// class AppLoadingWidget {
//   static GetBuilder<GeneralController> loadingBar() {
//     return GetBuilder<GeneralController>(
//       builder: (controller) {
//         return controller.loaderCheck ? const AppLoading() : const Offstage();
//       },
//     );
//   }
// }

class AppLoadingWidget {
  static GetBuilder<GeneralController> loadingBar() {
    return GetBuilder<GeneralController>(
      builder: (controller) {
        return controller.loaderCheck ? const AppLoading() : const Offstage();
      },
    );
  }

  // static GetBuilder<GeneralController> buttonLoader(
  //     {double size = 24, Color color = Colors.white}) {
  //   return GetBuilder<GeneralController>(
  //     builder: (controller) {
  //       return controller.buttonLoaderCheck
  //           ? SizedBox(
  //               height: size,
  //               width: size,
  //               child: CircularProgressIndicator(
  //                 strokeWidth: 2.5,
  //                 valueColor: AlwaysStoppedAnimation<Color>(color),
  //               ),
  //             )
  //           : const SizedBox.shrink();
  //     },
  //   );
  }


class SmoothLoadingOverlay extends StatelessWidget {
  final String? message;
  final double? padding;

  const SmoothLoadingOverlay({super.key, this.message, this.padding});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(
      builder: (controller) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: controller.loaderCheck ? 1.0 : 0.0,
          curve: Curves.easeInOut,
          child: controller.loaderCheck
              ? Container(
                  color: Colors.black26,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          color: Colors.transparent,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: padding ?? 0),
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        if (message != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            message!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}

class AppLoadingIcon extends StatelessWidget {
  const AppLoadingIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? const Center(
            child: CircularProgressIndicator(color: AppColors.primary))
        : const Center(
            child: CupertinoActivityIndicator(
              radius: 20,
              color: AppColors.primary,
            ),
          );
  }
}
