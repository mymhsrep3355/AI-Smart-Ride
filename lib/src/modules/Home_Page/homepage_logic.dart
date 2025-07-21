import 'package:get/get.dart';

class HomePageController extends GetxController {
  var selectedIndex = 0.obs;
  var username = 'John Doe'.obs;

  void onNavTapped(int index) {
    selectedIndex.value = index;
  }

  void toggleDriverMode() {
    print('Driver Mode toggled!');
  }
}
