import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_ride/src/modules/ai_chatbot/ai_chatbot_logic.dart';
import 'package:smart_ride/src/modules/chat-bot/ai_chatbot_logic.dart';

class AIChatBotView extends StatelessWidget {
  const AIChatBotView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GetBuilder<AIChatBotLogic>(
      init: AIChatBotLogic(),
      builder: (_) {
        final controller = Get.find<AIChatBotLogic>();
        return Scaffold(
          backgroundColor: const Color(0xFFF9F9F9),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            title: const Text(
              "AI Assistant",
              style: TextStyle(color: Colors.black),
            ),
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: Column(
            children: [
              // Message List
              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final msg = controller.messages[index];
                    return Align(
                      alignment: msg.isBot
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(12),
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.8),
                        decoration: BoxDecoration(
                          color: msg.isBot
                              ? Colors.grey.shade200
                              : Colors.blueAccent,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: Radius.circular(msg.isBot ? 4 : 16),
                            bottomRight: Radius.circular(msg.isBot ? 16 : 4),
                          ),
                        ),
                        child: Text(
                          msg.text,
                          style: TextStyle(
                            color: msg.isBot ? Colors.black87 : Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const Divider(height: 1),

              // Predefined questions as horizontal chips
              if (controller.suggestions.isNotEmpty)
                Container(
                  height: 48,
                  margin: const EdgeInsets.only(top: 4, left: 8),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.suggestions.length,
                    padding: const EdgeInsets.only(right: 12),
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final suggestion = controller.suggestions[index];
                      return ActionChip(
                        backgroundColor: Colors.blueGrey.shade50,
                        label: Text(
                          suggestion,
                          style: const TextStyle(fontSize: 13),
                        ),
                        onPressed: () => controller.askQuestion(suggestion),
                      );
                    },
                  ),
                ),

              // Input field
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.userInputController,
                        decoration: InputDecoration(
                          hintText: 'Ask something...',
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide:
                                const BorderSide(color: Colors.blueAccent),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.blueAccent,
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: () {
                          controller.sendCustomPrompt();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
