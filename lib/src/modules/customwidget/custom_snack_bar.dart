import 'package:get/get.dart';
import 'package:smart_ride/src/modules/utlis/app_colors.dart';


showSnackBar({
  String title = 'Message',
  required String subTitle,
}) {
  Get.snackbar(
    title,
    subTitle,
    backgroundColor:
        Get.isDarkMode ? AppColors.primary : AppColors.primary,
    colorText: Get.isDarkMode ? AppColors.textLight : AppColors.textLight,
  );
}
