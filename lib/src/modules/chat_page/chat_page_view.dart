import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_ride/src/modules/chat_page/chat_page_logic.dart';

import 'package:smart_ride/src/modules/group_posting/group_posting_logic.dart';
import 'package:smart_ride/src/modules/group_posting/group_posting_view.dart';
import 'package:smart_ride/src/modules/utlis/app_fonts.dart';
import 'package:smart_ride/src/modules/utlis/app_images.dart';

class GroupChatScreen extends StatelessWidget {
  GroupChatScreen({super.key});
  final postLogic = Get.put(GroupPostingLogic());
  final controller = Get.put(ChatPageLogic());

  @override
  Widget build(BuildContext context) {
    // ✅ Only fetch groups if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (postLogic.postedGroups.isEmpty) {
        postLogic.fetchAllGroups();
        print("📡 Triggered fetchAllGroups from GroupChatScreen");
      }
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: Image.asset(
                    AppImages.top,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    children: [
                      Text(
                        'SmartRide',
                        style: StyleRefer.poppinsBold.copyWith(
                          fontSize: 22,
                          color: Colors.white,
                          shadows: const [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 4,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your groups',
                          style:
                              StyleRefer.poppinsSemiBold.copyWith(fontSize: 20),
                        ),
                        const SizedBox(height: 12),
                        Obx(() {
                          return Column(
                            children: controller.joinedGroups
                                .map((group) => buildGroupButton(group))
                                .toList(),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Recommendations',
                style: StyleRefer.poppinsSemiBold.copyWith(fontSize: 20),
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => SizedBox(
                  height: 180,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: postLogic.postedGroups.map((group) {
                      // ✅ Add this
                      final name = group['name'] ?? 'Unnamed';
                      final time = group['time'] ?? 'Unknown time';
                      final details = group['details'] ?? 'No details';
                      final venue = group['venue'] ?? 'No venue';
                      final days = group['days'] ?? 'N/A';
                      final groupId =
                          group['id']?.toString() ?? ''; // ✅ correct

                      print('🧪 Group Map: $group');
                      print('📦 Extracted groupId: $groupId');

                      return _buildRecommendationCard(
                        context,
                        name,
                        time,
                        details,
                        venue,
                        days,
                        groupId,
                        group['members'] ?? '0', // <-- Pass this to widget
                      );
                    }).toList(),
                  ),
                )),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GroupPostingView()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Create Group'),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context,
    String name,
    String time,
    String details,
    String venue,
    String days,
    String groupId,
    String memberCount,
  ) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.group_add, size: 50, color: Colors.blue),
          const SizedBox(height: 6),
          Column(
            children: [
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.info_outline, color: Colors.blue),
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Group Details'),
                      content: Text(
                        '📍 Venue: $venue\n🗓️ Date & Time: $time\n📅 Days: $days\n📝 Details: $details',
                      ),
                      actions: [
                        TextButton(
                          child: const Text('Close'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Obx(() {
                  // ✅ Updated check
                  bool isJoined =
                      controller.joinedGroups.any((g) => g['id'] == groupId);

                  return ElevatedButton(
                    onPressed: isJoined
                        ? null
                        : () {
                            if (groupId.trim().isNotEmpty) {
                              controller.joinGroup(groupId);
                            } else {
                              print('❌ groupId passed to joinGroup is EMPTY');
                              Get.snackbar("Error", "Group ID missing",
                                  backgroundColor: Colors.red);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isJoined ? Colors.grey : Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(60, 30),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(isJoined ? 'Joined' : 'Join'),
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildGroupButton(Map<String, String> group) {
    final title = group['name'] ?? '';
    final groupId = group['id'] ?? ''; // ✅

    if (groupId.isEmpty) {
      print('❌ ERROR: groupId missing in group: $group');
    }

    return InkWell(
      onTap: () {
        if (groupId.isNotEmpty) {
          Get.toNamed('/chatting-screen', arguments: {
            'groupId': groupId,
            'groupName': title,
          });
          print('👀 Navigating to ChattingScreen with ID: $groupId');
        } else {
          Get.snackbar("Error", "Group ID missing",
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.group, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: StyleRefer.poppinsSemiBold.copyWith(
                  fontSize: 18,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.white70, size: 16),
          ],
        ),
      ),
    );
  }
}
