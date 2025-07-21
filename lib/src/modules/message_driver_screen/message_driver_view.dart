import 'package:flutter/material.dart';
import 'package:smart_ride/src/modules/customwidget/textfields.dart';
import 'package:get/get.dart';
import 'package:smart_ride/src/modules/message_driver_screen/message_driver_logic.dart';



class DriverChattingScreenView extends StatelessWidget {
  final DriverChattingScreenController controller = Get.put(DriverChattingScreenController());
  final TextEditingController textController = TextEditingController();

  DriverChattingScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Column(
          children: [
            // Top Image with Title & Back Button
            Stack(
              children: [
                Image.asset(
                  'assets/images/top.png', // Make sure this path is correct
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 16,
                  left: 8,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                ),
                const Positioned(
                  top: 20,
                  left: 50,
                  child: Text(
                    "Chat with driver!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            // Message List
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 4),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            backgroundImage: NetworkImage("https://randomuser.me/api/portraits/men/1.jpg"),
                            radius: 22,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(message['sender'] ?? '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 14)),
                              const SizedBox(height: 4),
                              Text(message['message'] ?? '',
                                  style: const TextStyle(fontSize: 14)),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
              }),
            ),

            // Custom Textfield
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Textfield(
                      hintKey: "Type a message...",
                      controller: textController,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      controller.sendMessage("Muhammad", textController.text);
                      textController.clear();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
