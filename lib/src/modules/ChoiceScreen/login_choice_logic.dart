import 'package:get/get.dart';
import 'package:smart_ride/src/modules/WelcomeDriverScreen/welcome_driver_logic.dart';
import 'package:smart_ride/src/modules/WelcomeDriverScreen/welcome_driver_view.dart';
import 'package:smart_ride/src/modules/WelcomePassengerScreen/welcome_passenger_logic.dart';
import 'package:smart_ride/src/modules/WelcomePassengerScreen/welcome_passenger_view.dart';

class UserTypeSelectionController extends GetxController {
  void onDriverPressed() {
    // Manually put the controller since you're skipping named route binding
    Get.put(WelcomeDriverController());
    Get.to(() => const WelcomeDriverView());
  }

  void onPassengerPressed() {
    Get.put(WelcomePassengerController()); // ✅ Add this line
    Get.to(() => const WelcomePassengerView());
  }
}
