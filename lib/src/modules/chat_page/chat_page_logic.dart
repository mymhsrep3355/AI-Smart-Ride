import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_ride/src/general_controller/GeneralController.dart';
import 'package:smart_ride/src/modules/Home_Page/homepage_view.dart';
import 'package:smart_ride/src/modules/History_screen/history_view.dart';
import 'package:smart_ride/src/modules/chatting_screen/chatting_screen_logic.dart';
import 'package:smart_ride/src/modules/customwidget/token_utils.dart';

import 'package:smart_ride/src/modules/utlis/keys.dart';
import 'package:smart_ride/src/services/url.dart';

class ChatPageLogic extends GetxController {
  var currentIndex = 2;

  var joinedGroups = <Map<String, String>>[].obs;
  var groupMembers = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadJoinedGroups(); // ✅ Load saved groups on startup
  }

  void onNavTapped(int index, BuildContext context) {
    if (index == currentIndex) return;
    currentIndex = index;
    switch (index) {
      case 0:
        Get.off(() => const HomePageView());
        break;
      case 1:
        Get.off(() => HistoryView());
        break;
    }
  }

  Future<void> joinGroup(String groupId) async {
    final box = Get.find<GeneralController>().box;
    final token = box.read(AppKeys.authToken);
    final userId = box.read(AppKeys.userId) ?? '';

    if (token == null ||
        token == 'undefined' ||
        token.isEmpty ||
        userId.isEmpty) {
      Get.snackbar("Error", "Login required to join group",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      final token = await getValidTokenOrLogout();
      if (token == null) return;

      print('🔐 Token used for joinGroup API: $token'); // ✅ ADD HERE
      final response = await Dio().post(
        joinGroupURL(groupId),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data['success'] == true) {
        final joinedGroupData = response.data['data'];
        final groupName = joinedGroupData['name'] ?? '';
        final groupId = joinedGroupData['_id'] ?? '';
        final members = joinedGroupData['members'] as List<dynamic>? ?? [];

        // 🧮 Count members
        final memberCount = members.length;

        // Update in memory
        if (!joinedGroups.any((g) => g['id'] == groupId)) {
          joinedGroups.add({
            'name': groupName,
            'id': groupId, // ✅ correct key
          });
          ;
        }

        // Save locally for current user
        final userKey = 'joinedGroups_$userId';
        List storedGroups = box.read(userKey) ?? [];
        if (!storedGroups.any((g) => g['id'] == groupId)) {
          storedGroups.add({'name': groupName, 'id': groupId}); // ✅ use 'id'
          ;
          box.write(userKey, storedGroups);
        }
        print('➡️ Joining groupId: $groupId'); // For debugging

        Get.snackbar("Joined!", "You have successfully joined the group.",
            backgroundColor: Colors.blue, colorText: Colors.white);

        Get.toNamed('/chatting-screen', arguments: {
          'groupId': groupId,
          'groupName': groupName,
        });
        // ✅ Force refresh member count after joining
        Future.delayed(const Duration(milliseconds: 300), () {
          if (Get.isRegistered<ChattingScreenController>()) {
            final chattingController = Get.find<ChattingScreenController>();
            chattingController.fetchMemberCount(groupId);
          }
        });
      } else {
        Get.snackbar(
            "Failed", response.data['message'] ?? "Could not join group.",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Server error: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }


 // ChatPageLogic.dart

void loadJoinedGroups() {
  final box = Get.find<GeneralController>().box;
  final userId = box.read(AppKeys.userId) ?? '';

  final userKey = 'joinedGroups_$userId';
  print('🧠 Trying to load: $userKey');
  final storedGroups = box.read(userKey) ?? [];
  print('📦 Loaded from box: $storedGroups');

  joinedGroups.value = storedGroups
      .map<Map<String, String>>((e) => {
            'name': e['name']?.toString() ?? '',
            'id': e['id']?.toString() ?? '',
          })
      .toList();
}



  void leaveGroup(String groupName) {
    joinedGroups.removeWhere((group) => group['name'] == groupName);
    groupMembers.remove(groupName);

    final box = Get.find<GeneralController>().box;
    final userId = box.read(AppKeys.userId) ?? '';
    final userKey = 'joinedGroups_$userId';
    List storedGroups = box.read(userKey) ?? [];

    storedGroups.removeWhere((group) => group['name'] == groupName);
    box.write(userKey, storedGroups);

    // ✅ Also refresh member count (if in ChattingScreen)
    final chattingController = Get.isRegistered<ChattingScreenController>()
        ? Get.find<ChattingScreenController>()
        : null;

    if (chattingController != null) {
      chattingController.fetchMemberCount(chattingController.groupId);
    }
  }
}
