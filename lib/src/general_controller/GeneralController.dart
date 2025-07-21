import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_ride/src/modules/customwidget/dialog.dart';

class GeneralController extends GetxController {
  // 📦 Local storage box
  final box = GetStorage();

  // 🔄 Observable variables to store driver info globally
  var driverName = ''.obs;
  var driverCNIC = ''.obs;
  @override
void onInit() {
  super.onInit();
  driverName.value = box.read('driverName') ?? '';
  driverCNIC.value = box.read('driverCNIC') ?? '';
}

  ///-------------------------------------------

  // GetStorage box = GetStorage(); // Already defined above

  ///-------------------------------------------
  ///-------------------------------internet-check
  bool showErrorLoading = true;

  ///-------------------------------internet-check
  bool internetChecker = true;

  changeInternetCheckerState(bool value) {
    internetChecker = value;
    update();
  }

  ///----internet-settings-------------
  String connectionStatus = 'Unknown';
  final Connectivity connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? connectivitySubscription;
  bool internetCheck = true;
  bool errorBoxShow = false;

  //---------internet-checker-functions----------------------

  Future<void> initConnectivity() async {
    ConnectivityResult? result;
    try {
      result = (await connectivity.checkConnectivity()) as ConnectivityResult?;
      update();
    } on PlatformException catch (e) {
      log(e.toString());
    }
    log('updateConnectionStatus');
    return updateConnectionStatus(result!);
  }

  Future<void> updateConnectionStatus(ConnectivityResult result) async {
    log('updateConnectionStatus  $result');
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        connectionStatus = result.toString();
        if (result != ConnectivityResult.none) {
          internetCheck = true;
        } else {
          internetCheck = false;
          ResponseDialog.showError("checkInternet");
          log('InternetOFF');
        }
        update();
        break;
      default:
        connectionStatus = 'Failed to get connectivity.';
        update();
        break;
    }
  }

  ///------------------------------App Direction Check
  bool isDirectionRTL(BuildContext context) {
    final TextDirection currentDirection = Directionality.of(context);
    final bool isRTL = currentDirection == TextDirection.rtl;
    return isRTL;
  }

  ///------------------------------- loader-check
  bool loaderCheck = false;

  changeLoaderCheck(bool value) {
    loaderCheck = value;
    update();
  }

  ///------------------------------- Server-check
  bool serverCheck = true;

  changeServerCheck(bool value) {
    serverCheck = value;
    update();
  }

  printToken() {}
}
