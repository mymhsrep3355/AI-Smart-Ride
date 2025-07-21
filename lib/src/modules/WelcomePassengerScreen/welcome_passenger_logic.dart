import 'package:get/get.dart';
import 'package:smart_ride/src/modules/login_page/login_view.dart';
import 'package:smart_ride/src/modules/passenger-signup/passenger_signup_view.dart';


/// Handles all user‑interaction logic for the Welcome screen.
class WelcomePassengerController extends GetxController {
  /// Navigate to the login choice page.
  void goToLogin() {
    Get.to(() => LoginView());
  }

  /// Navigate to the passenger / driver sign‑up flow.
  void goToSignUp() {
    Get.to(() => PassengerSignUpView());
  }
}
