import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_ride/src/modules/Home_Page/homepage_view.dart';
import 'package:smart_ride/src/modules/customwidget/custom_button.dart';
import 'package:smart_ride/src/modules/setting_screen/setting_screen_view.dart';
import 'package:smart_ride/src/modules/utlis/app_fonts.dart';
import 'package:smart_ride/src/modules/utlis/app_images.dart';
import '../driver_histroypage/driver_history_view.dart';
import 'driver_home_logic.dart';

class DriverHomePageView extends StatelessWidget {
  final logic = Get.isRegistered<DriverHomeLogic>()
      ? Get.find<DriverHomeLogic>()
      : Get.put(DriverHomeLogic());

  final RxInt _selectedIndex = 0.obs;

  final List<Widget> _pages = [
    HomePageBody(),
    DriverHistoryPage(),
  ];

  void _onItemTapped(int index) {
    _selectedIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          resizeToAvoidBottomInset: true, // ✅ Add this line
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Text(
                    'Driver Menu',
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
                    _onItemTapped(0);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.list_alt),
                  title: Text('History'),
                  onTap: () {
                    _onItemTapped(1);
                    Navigator.pop(context);
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
                      Navigator.pop(context);
                      Future.delayed(const Duration(milliseconds: 250), () {
                        Get.to(() => SettingsView());
                      });
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: CustomButton(
                    text: 'Passenger Mode',
                    backgroundColor: Colors.blue,
                    onPressed: () {
                      Navigator.pop(context);
                      Future.delayed(const Duration(milliseconds: 250), () {
                        Get.offAll(() => const HomePageView());
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          body: _pages[_selectedIndex.value],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex.value,
            onTap: _onItemTapped,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home,
                    color:
                        _selectedIndex.value == 0 ? Colors.blue : Colors.grey),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt,
                    color:
                        _selectedIndex.value == 1 ? Colors.blue : Colors.grey),
                label: 'History',
              ),
            ],
          ),
        ));
  }
}

class HomePageBody extends StatelessWidget {
  final logic = Get.find<DriverHomeLogic>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() => Container(
            color: Color(0xFFF6F8FB),
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
                        builder: (context) => GestureDetector(
                          onTap: () => Scaffold.of(context).openDrawer(),
                          child: Row(
                            children: [
                              Icon(Icons.menu, color: Colors.white, size: 28),
                              SizedBox(width: 10),
                              Text(
                                'Home',
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
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await logic.fetchAvailableRides(); // 🔁 Manual refresh
                    },
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                      child: logic.rideList.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 64),
                                child: Text(
                                  'No ride requests available.',
                                  style: TextStyle(fontSize: 18, color: Colors.grey),
                                ),
                              ),
                            )
                          : Column(
                              children: logic.rideList.map((ride) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(18),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.location_pin, color: Colors.redAccent, size: 22),
                                              SizedBox(width: 8),
                                              Text(
                                                'Pickup: ',
                                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                                              ),
                                              Text(
                                                '${ride.stops.first.latitude.toStringAsFixed(5)}, ${ride.stops.first.longitude.toStringAsFixed(5)}',
                                                style: TextStyle(fontSize: 15, color: Colors.black87),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Icon(Icons.attach_money, color: Colors.green, size: 22),
                                              SizedBox(width: 8),
                                              Text('Fare: ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                                              Text('Rs. ${ride.fare}', style: TextStyle(fontSize: 15, color: Colors.black87)),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Text('Status: ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                                              SizedBox(width: 8),
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.orange[100],
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  'Pending',
                                                  style: TextStyle(
                                                    color: Colors.orange[800],
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Divider(height: 28, thickness: 1.1),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              ElevatedButton.icon(
                                                icon: Icon(Icons.check, color: Colors.white, size: 18),
                                                label: Text('Accept'),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.blue,
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                                  textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                ),
                                                onPressed: () async {
                                                  // Show dialog to enter fare amount
                                                  final fareController = TextEditingController();
                                                  final result = await showDialog<double>(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text('Enter Fare Amount'),
                                                        content: TextField(
                                                          controller: fareController,
                                                          keyboardType: TextInputType.number,
                                                          decoration: InputDecoration(hintText: 'Fare Amount'),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () => Navigator.of(context).pop(),
                                                            child: Text('Cancel'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              final value = double.tryParse(fareController.text);
                                                              if (value != null) {
                                                                Navigator.of(context).pop(value);
                                                              }
                                                            },
                                                            child: Text('OK'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  if (result != null) {
                                                    logic.acceptRide(ride, result);
                                                  }
                                                },
                                              ),
                                              SizedBox(width: 12),
                                              ElevatedButton.icon(
                                                icon: Icon(Icons.close, color: Colors.white, size: 18),
                                                label: Text('Reject'),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                                  textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                ),
                                                onPressed: () {
                                                  logic.rejectRide(ride);
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
