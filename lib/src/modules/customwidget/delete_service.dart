import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart' as dio_instance;
import 'package:get/get.dart';
import 'package:smart_ride/src/general_controller/GeneralController.dart';
import 'package:smart_ride/src/modules/customwidget/dialog.dart';
import 'package:smart_ride/src/modules/utlis/keys.dart';
import 'package:smart_ride/src/services/set_headers.dart';


deleteMethod(String apiUrl, dynamic postData, Function executionMethod,
    {bool authHeader = false, dynamic queryParameters}
    // for performing functionalities
    ) async {
  dio_instance.Response response;
  dio_instance.Dio dio = dio_instance.Dio();

  dio.options.connectTimeout = const Duration(seconds: 10);
  dio.options.receiveTimeout = const Duration(seconds: 10);

  setAcceptHeader(dio);
  setContentHeader(dio);
  if (authHeader) {
    setCustomHeader(dio, 'Authorization',
        'Bearer ${Get.find<GeneralController>().box.read(AppKeys.authToken)}');
  }

  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      log('Internet Connected');
      Get.find<GeneralController>().changeLoaderCheck(true);
      try {
        log('postData--->> $postData');
        response = await dio.delete(apiUrl,
            data: postData, queryParameters: queryParameters);

        log('StatusCode------>> ${response.statusCode}');
        log('Delete Response $apiUrl------>> $response');
        Get.find<GeneralController>().changeLoaderCheck(false);
        if (response.statusCode! >= 200 && response.statusCode! <= 299) {
          print(response.data);
          executionMethod(true, response.data);
          return;
        }
        executionMethod(false, {'status': null});
      } on dio_instance.DioException catch (e) {
        Get.find<GeneralController>().changeLoaderCheck(false);
        if ((e.response?.statusCode ?? 500) >= 500) {
          ResponseDialog.showError('Server Error!.Please Try again later');
          // showSnackBar('Error', 'Server Error!.Please Try again later');
          log('Dio Error From -->> $e');
          return;
        }

        executionMethod(false, e.response?.data);
        log('Dio Error From Delete $apiUrl -->> ${e.message}');
      }
    }
  } on SocketException {
    Get.find<GeneralController>().changeLoaderCheck(false);
    log('Internet Not Connected');
    ResponseDialog.showError('Internet Not Connected');
  }
}
