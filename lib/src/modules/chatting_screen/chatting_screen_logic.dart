import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:smart_ride/src/modules/customwidget/token_utils.dart';
import 'package:smart_ride/src/services/url.dart';

import 'package:smart_ride/src/modules/chat_page/chat_page_logic.dart';

class ChattingScreenController extends GetxController {
  late final ChatPageLogic chatLogic;
  var messages = <Map<String, String>>[].obs;
  var messageController = ''.obs;
  RxInt memberCount = 1.obs;

  late String groupId;
  var groupName = ''.obs;

  late final Rx<Duration> refreshInterval = const Duration(seconds: 5).obs;
  late final Rxn<Worker> refreshWorker = Rxn<Worker>();

  @override
  void onInit() {
    super.onInit();
    chatLogic = Get.find<ChatPageLogic>();

    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      groupId = args['groupId'] ?? '';
      groupName.value = args['groupName'] ?? '';
      if (groupId.isNotEmpty) {
        fetchMessages(); // 🆕 Load initial messages
        fetchMemberCount(groupId);

        refreshWorker.value = ever(refreshInterval, (_) {
          fetchMessages(); 
          fetchMemberCount(groupId);
        });
      } else {
        print(' Missing groupId in arguments');
      }
    } else {
      print('Get.arguments is not a valid Map');
    }
  }

  @override
  void onClose() {
    refreshWorker.value?.dispose();
    super.onClose();
  }

  Future<void> fetchMessages() async {
    try {
      final token = await getValidTokenOrLogout();
      if (token == null) return;

      print('🔐 Token used for fetch msg: $token'); // ✅ ADD HERE

      final response = await Dio().get(
        groupchatsURL(groupId),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List data = response.data['data'];
        messages.value = data
            .where((msg) => msg is Map<String, dynamic>)
            .map<Map<String, String>>((msg) {
          return {
            'sender': msg['senderName']?.toString() ?? 'Unknown',
            'message': msg['content']?.toString() ?? '',
          };
        }).toList();
      }
    } catch (e) {
      print('❌ Error fetching messages: $e');
    }
  }

  Future<void> sendMessage(String senderName, String text) async {
    if (text.trim().isEmpty) return;

    try {
      // final token = Get.find<GeneralController>().box.read(AppKeys.authToken);
      final token = await getValidTokenOrLogout();
      if (token == null) return;

      print('🔐 Token used for send msg: $token'); // ✅ ADD HERE
      final response = await Dio().post(
        groupchatsURL(groupId),
        data: {'content': text},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        fetchMessages(); // Refresh messages after sending
        messageController.value = '';
      } else {
        print('❌ Message not sent');
      }
    } catch (e) {
      print('❌ Error sending message: $e');
    }
  }

 Future<void> leaveGroup(String groupName) async {
    print('leaveGroup called for: $groupId ($groupName)');

    final token = await getValidTokenOrLogout();
    if (token == null) {
      print('No valid token');
      return;
    }

    try {
      print('📡 Calling leaveGroupURL with token: $token');

      final response = await Dio().post(
        leaveGroupURL(groupId),
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      print('📬 Response received: ${response.statusCode}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        chatLogic.leaveGroup(groupName);
        messages.clear();
        Get.snackbar("Left Group", "Successfully left the group.",
            backgroundColor: Colors.orange, colorText: Colors.white);
        Get.back();
      } else {
        print('❌ Backend response: ${response.data}');
        Get.snackbar("Error", response.data['message'] ?? "Failed to leave group.",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print('❌ Dio error: $e');
      Get.snackbar("Error", "Server error: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
  Future<void> fetchMemberCount(String groupId) async {
    try {
      final token = await getValidTokenOrLogout();
      if (token == null) return;

      print('🔐 Token used for fetchmembercount: $token'); // ✅ ADD HERE

      final response = await Dio().get(
        getGroupsURL,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List groups = response.data['data'];
        final group = groups.firstWhere(
          (g) => g['_id'] == groupId,
          orElse: () => null,
        );

        if (group != null) {
          final rawMembers = group['members'] as List<dynamic>? ?? [];
          final uniqueMembers =
              rawMembers.map((m) => m.toString()).toSet().toList();
          memberCount.value = uniqueMembers.length;
        }
      }
    } catch (e) {
      print('❌ Error fetching member count: $e');
    }
  }
}
