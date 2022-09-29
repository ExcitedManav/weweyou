import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:weweyou/data/networking/response.dart';

import '../../ui/utils/common_widgets.dart';
import '../../ui/utils/constant.dart';
import 'api_provider.dart';
import 'shared_pref.dart';

class NetworkingFunctions {
  final CommonProgress _commonProgress = CommonProgress();

  static Future<Response> getApiCall({
    required String endPoint,
  }) async {
    var token = await getAuthToken();
    var headers = {
      'Authorization': "Bearer $token",
      "X-localization": "en",
      "Content-Type": "application/json"
    };
    Dio dio = Dio();
    final response = await dio.get(
      baseUrl + endPoint,
      options: Options(
        method: "Get",
        validateStatus: (val) => true,
        headers: headers,
        contentType: 'Application/json',
      ),
    );
    debugPrint('API URL ---> ${baseUrl + endPoint}');
    if (response.statusCode == 200 && response.data['success'] == true) {
      response.data;
      debugPrint('Data  ---> ${response.data}');
    } else {
      showToast(
        toastMsg: 'Something went wrong',
        backgroundColor: WeweyouColors.primaryDarkRed,
      );
    }
    return response;
  }

  Future<Response> postApiCall({
    required String endPoint,
    required Map body,
  }) async {
    var token = await getAuthToken();
    var headers = {
      'Authorization': "Bearer $token",
      "X-localization": "en",
      "Content-Type": "application/json"
    };
    Dio dio = Dio();
    final response = await dio.post(
      baseUrl + endPoint,
      data: jsonEncode(body),
      options: Options(
        method: "Post",
        validateStatus: (val) => true,
        headers: headers,
        contentType: 'Application/json',
      ),
    );
    // debugPrint('AuthToken ---> $token');
    debugPrint('Body Params ---> $body');
    debugPrint('API URL ---> ${baseUrl + endPoint}');
    if (response.statusCode == 200 && response.data['status'] == true) {
      showToast(toastMsg: response.data['message']);
    } else {
      showToast(
        toastMsg: response.data['message'],
        backgroundColor: WeweyouColors.primaryDarkRed,
      );
      debugPrint(response.data['message']);
    }
    return response;
  }

  Future<ResponseC> multipartApi({
    required BuildContext context,
    required Map<String, String> body,
    required String loadingMsg,
    required String apiURL,
     String? imagePath,
    required String keyImagePath,
  }) async {
    final ProgressDialog pr = _commonProgress.commonProgressIndicator(
      context: context,
      loadingMsg: loadingMsg,
    );
    bool isSuccessful = false;
    String message = '';
    var token = await getAuthToken();
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        apiURL,
      ),
    );
    request.fields.addAll(body);
    request.files.add(
      await http.MultipartFile.fromPath(
        keyImagePath,
        imagePath ?? '',
        filename: imagePath,
      ),
    );
    debugPrint('API URL ---> $apiURL');
    debugPrint('Body Params ---> $body');
    request.headers.addAll(headers);
    var response = await request.send();
     await response.stream.transform(utf8.decoder).listen(
      (value)  {
        Map valueMap = json.decode(value);
        if (response.statusCode == 200 && valueMap['success'] == true) {
          pr.close();
          isSuccessful = valueMap['success'];
          print("Success boolean $isSuccessful");
          message = valueMap['message'];
          showToast(toastMsg: valueMap['message']);
        } else {
          pr.close();
          showToast(toastMsg: valueMap['message']);
          debugPrint('Error ${valueMap['message']}');
        }
      },
    );
    return ResponseC(isSuccessful, message);
  }
}
