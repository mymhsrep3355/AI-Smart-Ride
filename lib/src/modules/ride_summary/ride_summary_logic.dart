import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RideSummaryController extends GetxController {
  var rating = 0.obs;
  var commentController = TextEditingController();

  void setRating(int newRating) {
    rating.value = newRating;
  }

  void submitRating() {
  String comment = commentController.text.trim();
  int finalRating = rating.value;

  // Simulate backend submission
  print("Rating Submitted: $finalRating");
  print("Comment: $comment");

  // Styled snackbar
  Get.snackbar(
    "Thank you!",
    "Your feedback has been submitted.",
    backgroundColor: Colors.blueAccent,
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    icon: const Icon(Icons.star_rate, color: Colors.white),
    margin: const EdgeInsets.all(16),
    borderRadius: 12,
    duration: const Duration(seconds: 2),
  );

  // Optional delay to let user read the snackbar
  Future.delayed(const Duration(seconds: 1), () {
    Get.offAllNamed('/home'); // Navigate to home
  });
}

}
