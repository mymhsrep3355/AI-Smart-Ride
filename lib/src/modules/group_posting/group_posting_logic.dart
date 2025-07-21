import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_ride/src/modules/customwidget/token_utils.dart';
import 'package:smart_ride/src/services/url.dart';
import 'package:smart_ride/src/modules/chat_page/chat_page_logic.dart';


class GroupPostingLogic extends GetxController {
  final groupNameController = TextEditingController();
  final venueController = TextEditingController();
  final daysController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  RxString groupNameError = ''.obs;
  RxString venueError = ''.obs;
  RxString daysError = ''.obs;
  RxString descriptionError = ''.obs;
  RxString dateError = ''.obs;
  RxString timeError = ''.obs;

  var postedGroups = <Map<String, String>>[].obs;

  Future<void> pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> pickTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) {
      timeController.text = picked.format(context);
    }
  }

  void postGroup() async {
    final name = groupNameController.text.trim();
    final venue = venueController.text.trim();
    final days = daysController.text.trim();
    final description = descriptionController.text.trim();
    final date = dateController.text.trim();
    final time = timeController.text.trim();

    groupNameError.value = '';
    venueError.value = '';
    daysError.value = '';
    descriptionError.value = '';
    dateError.value = '';
    timeError.value = '';

    bool hasError = false;

    if (name.isEmpty) {
      groupNameError.value = 'Group name is required';
      hasError = true;
    }
    if (venue.isEmpty) {
      venueError.value = 'Venue is required';
      hasError = true;
    }
    if (days.isEmpty || int.tryParse(days) == null) {
      daysError.value = 'Enter valid number of days';
      hasError = true;
    }
    if (description.isEmpty) {
      descriptionError.value = 'Description is required';
      hasError = true;
    }
    if (date.isEmpty) {
      dateError.value = 'Date is required';
      hasError = true;
    }
    if (time.isEmpty) {
      timeError.value = 'Time is required';
      hasError = true;
    }

    if (hasError) return;
    final token = await getValidTokenOrLogout();
    if (token == null) return;
    print('🔐 Token used for CreateGroup API: $token'); // ✅ NEW LINE HERE

    final body = {
      "name": name,
      "tripDetails": {
        "date": date,
        "time": time,
        "venue": venue,
        "days": int.parse(days),
        "description": description,
      }
    };

    try {
      final response = await Dio().post(
        creategroup,
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.data['success'] == true) {
        final groupData = response.data['data'];
        final groupId = groupData['_id']?.toString() ?? '';

        postedGroups.add({
          'name': name,
          'time': '$date at $time',
          'details': description,
          'venue': venue,
          'days': days,
          'id': groupId, // ✅ Correct key
        });

        groupNameController.clear();
        venueController.clear();
        daysController.clear();
        descriptionController.clear();
        dateController.clear();
        timeController.clear();

        final chatLogic = Get.find<ChatPageLogic>();
        chatLogic.currentIndex = 2;

        Get.snackbar(
          "Group Created",
          "Group '$name' has been posted.",
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        );

        await Future.delayed(const Duration(seconds: 2));
        Get.back();
      } else {
        Get.snackbar("Error", "Failed to create group");
      }
    } catch (e) {
      Get.snackbar("Error", "Server error: ${e.toString()}");
    }
  }

  Future<void> fetchAllGroups() async {
      final token = await getValidTokenOrLogout();
  if (token == null) return;


    try {
      final response = await Dio().get(
        getGroupsURL,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List data = response.data['data'];

        postedGroups.value = data.map<Map<String, String>>((group) {
          final trip = group['tripDetails'] ?? {};
          final id = group['_id']?.toString() ?? '';
          final members = group['members'] ?? [];
          final memberCount = members.length.toString();

          return {
            'name': group['name'] ?? '',
            'time': '${trip['date'] ?? ''} at ${trip['time'] ?? ''}',
            'details': trip['description'] ?? '',
            'venue': trip['venue'] ?? '',
            'days': (trip['days'] ?? '').toString(),
            'id': group['_id'],
            // ✅ Fix: use 'id' instead of '_id'
            'members': memberCount,
          };
        }).toList();
      } else {
        print('❌ Failed to fetch groups: ${response.data}');
      }
    } catch (e) {
      print('❌ Error fetching groups: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchAllGroups(); // 👈 fetch shared groups on startup
  }

  void onClose() {
    groupNameController.dispose();
    venueController.dispose();
    daysController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.onClose();
  }
}
