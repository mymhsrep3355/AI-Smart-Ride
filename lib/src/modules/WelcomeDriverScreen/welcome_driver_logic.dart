import 'package:get/get.dart';
import 'package:smart_ride/src/modules/driver_Signup/driver_signup_view.dart';
import 'package:smart_ride/src/modules/driver_login/driver_login_view.dart';


/// Handles all user‑interaction logic for the Welcome screen.
class WelcomeDriverController extends GetxController {
  /// Navigate to the login choice page.
  void goToLogin() {
    Get.to(() => DriverLoginView());
  }

  /// Navigate to the passenger / driver sign‑up flow.
  void goToSignUp() {
    Get.to(() => DriverSignUpView());
  }
}
