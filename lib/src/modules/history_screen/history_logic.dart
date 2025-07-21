// history_logic.dart

import 'package:flutter/material.dart';
import 'package:smart_ride/src/modules/Home_Page/homepage_view.dart';

import 'package:smart_ride/src/modules/chat_page/chat_page_view.dart';

class HistoryLogic {
  int currentIndex = 1;

  final List<Map<String, String>> historyList = List.generate(
    6,
    (index) => {
      "name": "Muhammad",
      "rideId": "IDR 1243",
      "route": "From Township to Gulberg",
    },
  );

  void handleNavigation(int index, BuildContext context) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePageView()),
        );
        break;
      case 1:
        // Already on HistoryView
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GroupChatScreen()),
        );
        break;
    }
  }
}
