import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weweyou/data/models/onboarding_models/signUpModel.dart';
import 'package:weweyou/data/networking/api_end_point.dart';
import 'package:weweyou/ui/utils/common_widgets.dart';

class ApiProvider {
  /*Server base url.*/

  /* Use for development*/
  final baseUrl = 'https://mmfinfotech.co/Weweyou/api/';

/* Use for testing*/
  Future<String> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('auth_Token') ?? '';
    return token;
  }

  /*End Point Call*/
  final ApiEndPoint _apiEndPoint = ApiEndPoint();

  Future<dynamic> postApi(String url, var body) async {
    debugPrint("Api Url $url");
    debugPrint("Body $body");

    var token = await getAuthToken();
    Map<String, String> headers = {
      'Content-Type': "application/json",
      "Authorization": token.isEmpty ? '' : 'Bearer $token',
    };
    var responseCheck;
    Dio dio = Dio();
    var response = await dio.post(
      baseUrl + url,
      data: body,
      options: Options(
        method: 'POST',
        responseType: ResponseType.json,
        validateStatus: (status) => true,
        headers: headers,
        contentType: 'application/json',
      ),
    );
    print("Response ${response.data} ${response.statusCode}");
    try {
      if (response.statusCode == 200 && response.data['message'] == true) {
        // TestModel user = TestModel.fromJson(response.data);
        responseCheck = json.decode(response.data);
      } else {
        showToast(toastMsg: response.data['message']);
        debugPrint(response.data['message']);
      }
    } catch (e) {
      showToast(toastMsg: e.toString());
      debugPrint(e.toString());
    }
    return responseCheck;
  }
}

class TestModel {
  int? status;
  bool? check;
  SignUpModel? signUpModel;

  TestModel({this.status, this.check, this.signUpModel});

  factory TestModel.fromJson(Map<String, dynamic> json) {
    return TestModel(
      status: json['status'],
      check: json['message'],
    );
  }
}

//
//   signUpRequest(BuildContext context, var body) async {
//     final ProgressDialog pr = ProgressDialog(context: context);
//
//     pr.show(max: 100, msg: "Signing User", barrierDismissible: true);
//     Dio dio = Dio();
//     var response = await dio.post(
//       baseUrl + REGISTERAPI,
//       data: body,
//       options: Options(
//           method: 'POST',
//           responseType: ResponseType.json,
//           // or ResponseType.JSON,,
//           validateStatus: (status) => true,
//           contentType: 'application/json'),
//     );
//     print("repsonse ${response.data} ${response.data}");
//     if (response.statusCode == 200) {
//       try {
//         debugPrint('Check push');
//         SignUpModel user = SignUpModel.fromJson(response.data);
//         debugPrint('${response.data}');
//         pr.close();
//         // log(mounted.toString());
//         Fluttertoast.showToast(msg: 'Login Successful');
//         // navigator.pushNamed('/welcomeScreen');
//         pr.close();
//         showCustomDialog(
//             toastMsg: '${response.data['message']}',
//             backgroundColor: Colors.green);
//       } catch (e) {
//         print(e.toString());
//       }
//     } else {
//       pr.close();
//       final snackBar = SnackBar(
//         content: Text("${response.data['message']}"),
//         backgroundColor: Colors.red,
//       );
//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//     }
//   }
// }

const baseUrl = 'https://mmfinfotech.co/Weweyou/api/';
