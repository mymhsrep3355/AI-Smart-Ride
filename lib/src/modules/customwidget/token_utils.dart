import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:smart_ride/src/general_controller/GeneralController.dart';
import 'package:smart_ride/src/modules/utlis/keys.dart';

/// Validates and returns a safe JWT token
/// If expired/invalid → clears token and redirects to login
Future<String?> getValidTokenOrLogout() async {
  final box = Get.find<GeneralController>().box;
  final token = box.read(AppKeys.authToken);

  if (token == null || token.isEmpty || token == 'undefined' || JwtDecoder.isExpired(token)) {
    // 🔐 Clear session info
    box.remove(AppKeys.authToken);
    box.remove(AppKeys.userId);
    box.remove(AppKeys.userRole);

    // ❌ Notify user
    Get.snackbar(
      "Session Expired",
      "Please login again",
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
    );

    // ⏳ Delay for user to see snackbar, then logout
    await Future.delayed(const Duration(milliseconds: 800));
    Get.offAllNamed('/login');
    return null;
  }

  return token;
}
