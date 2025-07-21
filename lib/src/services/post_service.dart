import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:smart_ride/src/general_controller/GeneralController.dart';
import 'package:smart_ride/src/modules/customwidget/dialog.dart';
import 'package:smart_ride/src/modules/login_page/login_view.dart';
import 'package:smart_ride/src/modules/utlis/keys.dart';
import 'set_headers.dart';

enum MethodsTypes { post, put }

final dio.Dio dioClient = dio.Dio()
  ..interceptors.add(PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseHeader: false,
    responseBody: true,
    error: true,
    compact: true,
  ))
  ..options.connectTimeout = const Duration(seconds: 30)
  ..options.receiveTimeout = const Duration(seconds: 30);

/// ✅ MAIN POST METHOD FOR API CALLS
postMethod(
  String apiUrl,
  dynamic postData,
  Function(bool, dynamic) executionMethod, {
  bool authHeader = false,
  dynamic queryParameters,
  String methodType = 'post',
  Map<String, String>? headers, // ✅ NEW PARAMETER FOR CUSTOM HEADERS
}) async {
  dio.Response response;

  setAcceptHeader(dioClient);
  setContentHeader(dioClient);

  final box = Get.find<GeneralController>().box;
  final token = box.read(AppKeys.authToken);

  if (authHeader &&
      (token == null ||
          token.isEmpty ||
          token == 'undefined' ||
          JwtDecoder.isExpired(token))) {
    box.remove(AppKeys.authToken);
    box.remove(AppKeys.userId);
    box.remove(AppKeys.userRole);

    Get.snackbar("Session Expired", "Please login again.",
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError);

    await Future.delayed(const Duration(milliseconds: 800));
    Get.offAll(() => const LoginView());
    return;
  }

  if (authHeader && token != null) {
    setCustomHeader(dioClient, 'Authorization', 'Bearer $token');
  }

  // ✅ Apply manually passed headers if provided
  if (headers != null) {
    dioClient.options.headers.addAll(headers);
  }

  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      log('✅ Internet Connected');
      Get.find<GeneralController>().changeLoaderCheck(true);

      try {
        log('📤 postData: $postData');

        response = methodType == MethodsTypes.put.name
            ? await dioClient.put(apiUrl,
                data: postData,
                queryParameters: queryParameters,
                options: dio.Options(method: methodType))
            : await dioClient.post(apiUrl,
                data: postData,
                queryParameters: queryParameters,
                options: dio.Options(method: methodType));

        Get.find<GeneralController>().changeLoaderCheck(false);

        log('✅ Status Code: ${response.statusCode}');
        log('📦 Response body: ${response.data}');

        if (response.statusCode == 200 && response.data['success'] == true) {
          executionMethod(true, response.data);
        } else {
          executionMethod(false, response.data);
        }
      } on dio.DioException catch (e) {
        Get.find<GeneralController>().changeLoaderCheck(false);

        final statusCode = e.response?.statusCode ?? 500;
        final errorMsg =
            e.response?.data?['message']?.toString().toLowerCase() ?? '';

        if (e.type == dio.DioExceptionType.connectionTimeout ||
            e.type == dio.DioExceptionType.sendTimeout ||
            e.type == dio.DioExceptionType.receiveTimeout) {
          log('⏳ Timeout: ${e.message}');
          ResponseDialog.showError('Request Timeout. Please try again.');
          return;
        }

        if (statusCode == 401 ||
            errorMsg.contains('jwt expired') ||
            errorMsg.contains('token is not valid')) {
          log('🔒 Token expired or invalid during request');
          box.remove(AppKeys.authToken);
          box.remove(AppKeys.userId);
          box.remove(AppKeys.userRole);

          Get.snackbar("Session Expired", "Please login again.",
              backgroundColor: Get.theme.colorScheme.error,
              colorText: Get.theme.colorScheme.onError);

          await Future.delayed(const Duration(milliseconds: 800));
          Get.offAll(() => const LoginView());
          return;
        }

        if (statusCode >= 500) {
          log('❌ Server error: ${e.message}');
          ResponseDialog.showError('Server Error! Please try again later.');
          return;
        }

        log('❗ Dio Error [$apiUrl]: ${e.response?.data}');
        executionMethod(false, e.response?.data ?? {'message': e.message});
      }
    }
  } on SocketException {
    Get.find<GeneralController>().changeLoaderCheck(false);
    log('❌ Internet Not Connected');
    ResponseDialog.showError('Internet Not Connected');
  }
}
