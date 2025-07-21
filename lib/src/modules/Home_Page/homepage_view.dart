import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_ride/src/modules/History_screen/history_view.dart';
import 'package:smart_ride/src/modules/Home_Page/homepage_logic.dart';

import 'package:smart_ride/src/modules/carpooling_pick_drop/carpooling_pick_drop_view.dart';
import 'package:smart_ride/src/modules/chat_page/chat_page_view.dart';
import 'package:smart_ride/src/modules/customwidget/custom_bottom_navbar.dart';
import 'package:smart_ride/src/modules/customwidget/custom_button.dart';

import 'package:smart_ride/src/modules/passengerToDriver/passengerToDriverLogic.dart';
import 'package:smart_ride/src/modules/passengerToDriver/passengerToDriverView.dart';
import 'package:smart_ride/src/modules/pick_drop/pick_drop_view.dart';
import 'package:smart_ride/src/modules/setting_screen/setting_screen_view.dart';

import 'package:smart_ride/src/modules/utlis/app_fonts.dart';
import 'package:smart_ride/src/modules/utlis/app_images.dart';
import 'package:get/get.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePageController>(
      init: HomePageController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else {
              exit(0);
            }
            return false;
          },
          child: Scaffold(
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: Colors.blue),
                    child: Text(
                      'User Menu',
                      style: StyleRefer.poppinsBold.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text('Home'),
                    onTap: () {
                      Navigator.pop(context);
                      controller.onNavTapped(0); // Go to Home
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.history),
                    title: Text('History'),
                    onTap: () {
                      Navigator.pop(context);
                      controller.onNavTapped(1); // Go to HistoryView
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.chat_bubble),
                    title: Text('Chat'),
                    onTap: () {
                      Navigator.pop(context);
                      controller.onNavTapped(2); // Go to Chat Page
                    },
                  ),
                  Divider(),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: CustomButton(
                      text: 'Settings',
                      backgroundColor: Colors.blue,
                      onPressed: () {
                        Navigator.pop(context); // Close the drawer first
                        Future.delayed(const Duration(milliseconds: 250), () {
                          Get.to(() =>
                              SettingsView()); // Navigate to settings screen
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: CustomButton(
                      text: 'Driver Mode',
                      backgroundColor: Colors.blue,
                      onPressed: () {
                        Navigator.pop(context); // Close the drawer
                        Future.delayed(const Duration(milliseconds: 250), () {
                          Get.lazyPut(() =>
                              PassengerToDriverController()); // ✅ Inject controller
                          Get.offAll(() =>
                              PassengerToDriverView()); // ✅ Navigate to view
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            body: SafeArea(
              child: Obx(() {
                switch (controller.selectedIndex.value) {
                  case 0:
                    return _buildHomeContent(context);
                  case 1:
                    return HistoryView();
                  case 2:
                    return GroupChatScreen();
                  default:
                    return _buildHomeContent(context);
                }
              }),
            ),
            bottomNavigationBar: Obx(() => CustomBottomNavBar(
                  currentIndex: controller.selectedIndex.value,
                  onTap: controller.onNavTapped,
                )),
          ),
        );
      },
    );
  }

  Widget _buildHomeContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 200,
                child: Image.asset(AppImages.top, fit: BoxFit.cover),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
              ),
              Positioned(
                left: 60,
                bottom: 145,
                child: Text(
                  'Welcome to SmartRide',
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
              ),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Services',
              style: StyleRefer.poppinsSemiBold.copyWith(fontSize: 20),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                _buildServiceButton(
                    'mini car', Icons.local_taxi, Colors.blue, context),
                const SizedBox(width: 12),
                _buildServiceButton(
                    'ac car', Icons.ac_unit, Colors.blue, context),
                const SizedBox(width: 12),
                _buildServiceButton(
                    'bike', Icons.pedal_bike, Colors.blue, context),
                const SizedBox(width: 12),
                _buildServiceButton(
                    'auto', Icons.electric_rickshaw, Colors.blue, context),
                const SizedBox(width: 12),
                _buildServiceButton(
                    'tourbus', Icons.group, Colors.blue, context),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'AI Recommendations',
              style: StyleRefer.poppinsSemiBold.copyWith(fontSize: 20),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                _buildRecommendationCard('Explore City Tours'),
                const SizedBox(width: 12),
                _buildRecommendationCard('Try SmartRide Carpool'),
                const SizedBox(width: 12),
                _buildRecommendationCard('Discounted AC Rides'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceButton(
      String label, IconData icon, Color color, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                if (label.toLowerCase() == 'carpooling' ||
                    label.toLowerCase() == 'tourbus') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CarpoolingPickDropView()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PickDropView(vehicleType: label),
                    ),
                  );
                }
              },
              child: Center(
                child: Icon(icon, color: Colors.white, size: 36),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: StyleRefer.poppinsRegular.copyWith(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildRecommendationCard(String title) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          title,
          style: StyleRefer.poppinsRegular.copyWith(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
