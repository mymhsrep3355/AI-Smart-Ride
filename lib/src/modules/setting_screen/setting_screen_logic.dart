import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_ride/src/general_controller/GeneralController.dart';
import 'package:smart_ride/src/modules/ChoiceScreen/login_choice_view.dart';
import 'package:smart_ride/src/modules/customwidget/dialog.dart';
import 'package:smart_ride/src/modules/utlis/keys.dart';
import 'package:smart_ride/src/services/url.dart';

class SettingsController extends GetxController {
  final dioClient = dio.Dio();

void logout() async {
  final box = Get.find<GeneralController>().box;
  final token = box.read(AppKeys.authToken);
  final userRole = box.read(AppKeys.userRole);
  final userId = box.read(AppKeys.userId);

  if (token == null || token.isEmpty || token == 'undefined') {
    ResponseDialog.showError("Token missing. Please login again.");
    return;
  }

  final endpoint = userRole == "passenger" ? passengerLogout : logoutAccount;

  try {
    final response = await dioClient.post(
      endpoint,
      options: dio.Options(headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      }),
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      // ✅ Preserve joined groups before removing keys
      final groupKey = 'joinedGroups_$userId';
      final savedGroups = box.read(groupKey);

      // ✅ Remove only login-related keys instead of erase
      box.remove(AppKeys.authToken);
      box.remove(AppKeys.userId);
      box.remove(AppKeys.userRole);

      // ✅ Restore joined groups
      if (savedGroups != null) {
        box.write(groupKey, savedGroups);
      }

      // ✅ Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');

      // ✅ Navigate back
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.offAll(() => const UserTypeSelectionView());
      });
    } else {
      ResponseDialog.showError(response.data['message'] ?? "Logout failed");
    }
  } catch (e) {
    print("❗ Logout error: $e");
    ResponseDialog.showError("Unexpected error. Try again.");
  }
}


  void deleteAccount() async {
    final box = Get.find<GeneralController>().box;
    final token = box.read(AppKeys.authToken);
    final userRole = box.read(AppKeys.userRole); // "passenger" or "driver"

    if (token == null || token.isEmpty || token == 'undefined') {
      ResponseDialog.showError("Token missing. Please login again.");
      return;
    }

    final isPassenger = userRole == "passenger";
    final endpoint = isPassenger ? passengerDelete : delete;

    dioClient.options.headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await dioClient.delete(endpoint);

      print("🗑️ Delete response: ${response.data}");

      if (response.statusCode == 200 && response.data['success'] == true) {
        ResponseDialog.showSuccess("Account deleted successfully.");

        box.erase(); // Clear local storage

        Future.delayed(const Duration(milliseconds: 800), () {
          Get.offAll(() => UserTypeSelectionView());
        });
      } else {
        ResponseDialog.showError(response.data['message'] ?? "Delete failed");
      }
    } catch (e) {
      if (e is dio.DioError) {
        print("❗ DioError (Delete): ${e.response?.data}");
        ResponseDialog.showError(e.response?.data['message'] ?? e.message);
      } else {
        print("❗ Unexpected error (Delete): $e");
        ResponseDialog.showError("Unexpected error occurred.");
      }
    }
  }
}
