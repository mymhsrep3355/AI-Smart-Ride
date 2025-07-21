import 'package:get/get.dart';

class PassengerChattingScreenController extends GetxController {
  var messages = <Map<String, String>>[].obs;

  void sendMessage(String sender, String text) {
    if (text.trim().isNotEmpty) {
      messages.add({'sender': sender, 'message': text});
    }
  }
}
