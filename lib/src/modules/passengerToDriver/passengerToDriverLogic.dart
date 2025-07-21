import 'package:get/get.dart';
import 'package:smart_ride/src/modules/driver_homepage/driver_home_view.dart';
import 'package:smart_ride/src/modules/driver_info/driver_info_view.dart';



/// Handles all user‑interaction logic for the Welcome screen.
class PassengerToDriverController extends GetxController {
  /// Navigate to the login choice page.
  void goToLogin() {
    Get.to(() => DriverHomePageView());
  }

  /// Navigate to the passenger / driver sign‑up flow.
  void goToSignUp() {
    Get.to(() => DriverInfoView());
  }
}
