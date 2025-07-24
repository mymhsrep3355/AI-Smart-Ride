import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIChatMessage {
  final String text;
  final bool isBot;

  AIChatMessage({required this.text, required this.isBot});
}

class AIChatBotLogic extends GetxController {
  final List<AIChatMessage> messages = [];
  final TextEditingController userInputController = TextEditingController();

  final List<String> suggestions = [
    "How to book a ride?",
    "How much does it cost?",
    "Is it safe for women?",
    "How do I cancel a ride?",
  ];

  final Map<String, String> answers = {
    "How to book a ride?":
        "Open the app, choose pickup and dropoff, then confirm your ride.",
    "How much does it cost?":
        "It depends on distance, vehicle type, and traffic conditions.",
    "Is it safe for women?":
        "Yes. We offer women-only rides and 24/7 emergency support.",
    "How do I cancel a ride?":
        "Go to your bookings and tap cancel before the driver arrives.",
  };

  late final GenerativeModel _geminiModel;

  @override
  void onInit() {
    super.onInit();

    _geminiModel = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: 'AIzaSyD4Bsv6dceQDPFXbE_tshGI1KIV7XPA1yE',
    );
  }

  void askQuestion(String question) {
    messages.add(AIChatMessage(text: question, isBot: false));
    final answer = answers[question] ?? "I'm still learning to answer that.";
    messages.add(AIChatMessage(text: answer, isBot: true));
    update();
  }

  Future<void> sendCustomPrompt() async {
    final input = userInputController.text.trim();
    if (input.isEmpty) return;

    messages.add(AIChatMessage(text: input, isBot: false));
    update();
    userInputController.clear();

    try {
      final prompt = """
You are SmartRide’s AI assistant, helping users with ride-booking, carpooling, safety, and travel information.
Stay helpful, simple, and relevant to SmartRide's context.

User asked: "$input"
""";

      final response =
          await _geminiModel.generateContent([Content.text(prompt)]);
      final reply =
          response.text?.trim() ?? "I'm sorry, I didn't understand that.";

      messages.add(AIChatMessage(text: reply, isBot: true));
    } catch (e) {
      print("Gemini API error: $e");
      messages.add(AIChatMessage(
          text: "Failed to get response. Please try again.", isBot: true));
    }

    update();
  }
}
