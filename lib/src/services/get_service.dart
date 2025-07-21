import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart' as dio_instance;
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:smart_ride/src/general_controller/GeneralController.dart';
import 'package:smart_ride/src/modules/customwidget/dialog.dart';
import 'package:smart_ride/src/modules/utlis/keys.dart';
import 'set_headers.dart';

getMethod(
    String apiUrl, Map<String, dynamic>? queryData, Function executionMethod,
    {bool authHeader = false}) async {
  dio_instance.Response response;
  dio_instance.Dio dio = dio_instance.Dio();
  dio.interceptors.add(PrettyDioLogger(
    requestHeader: false,
    requestBody: true,
    responseHeader: false,
    responseBody: true,
    error: true,
    compact: true,
  ));
  dio.options.connectTimeout = const Duration(seconds: 10);
  dio.options.receiveTimeout = const Duration(seconds: 20);

  setAcceptHeader(dio);
  setContentHeader(dio);
  if (authHeader) {
    // log(Get.find<GeneralController>().box.read(AppKeys.authToken));
    setCustomHeader(dio, 'Authorization',
        'Bearer ${Get.find<GeneralController>().box.read(AppKeys.authToken)}');
  }
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      log('Internet Connected');
      Get.find<GeneralController>().changeLoaderCheck(true);
      try {
        Map<String, dynamic> params = queryData ?? {};

        log('params------>> $params');
        response = await dio.get(apiUrl, queryParameters: queryData);
        log('StatusCode------>> ${response.statusCode}');
        // log('Response $apiUrl------>> ${json.encode(response.data)}');
        // log('End Point $apiUrl');
        Get.find<GeneralController>().changeLoaderCheck(false);

        if (response.statusCode! >= 200 && response.statusCode! <= 299) {
          executionMethod(true, response.data);
          return;
        }

        executionMethod(false, {'errors': null});
      } on DioException catch (e) {
        Get.find<GeneralController>().changeLoaderCheck(false);
        if (e.response?.statusCode == null) {
          ResponseDialog.showError(
              'Request Time Out.Please check your internet connection.');
          return;
        }
        // if (e.response?.statusCode == 401) {
        //   ResponseDialog.showError('Session expired. Please log in again.');
        //   Get.offAll(LogIn());
        //   // Get.find<GeneralController>().refreshToken();
        //   return;
        // }
        if (e.response?.statusCode == 401) {
          log('Access token expired, trying to refresh token...');
          // Get.find<GeneralController>().refreshToken(() {
          //   getMethod(apiUrl, queryData, executionMethod,
          //       authHeader: authHeader);
          // });
          return;
        }

        if (dio_instance.DioExceptionType.cancel == e.type) {
          ResponseDialog.showError('SocketException.Please Try again later');
        }
        log('Dio Error From Get $apiUrl -->> $e');
        executionMethod(false, e.response?.data);
      }
    }
  } on SocketException catch (_) {
    Get.find<GeneralController>().changeLoaderCheck(false);
    ResponseDialog.showError('Internet Not Connected');
    //snackbzzz(subTitle: 'Internet Not Connected');
    log('Internet Not Connected');
  }
}
