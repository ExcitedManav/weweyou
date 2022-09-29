import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:weweyou/ui/utils/common_text_style.dart';
import 'package:weweyou/ui/utils/common_widgets.dart';
import 'package:weweyou/ui/utils/constant.dart';

import '../../../data/networking/api_end_point.dart';
import '../../../data/networking/api_provider.dart';

class StripeWebView extends StatefulWidget {
  const StripeWebView({Key? key}) : super(key: key);

  @override
  State<StripeWebView> createState() => _StripeWebViewState();
}

class _StripeWebViewState extends State<StripeWebView> {
  String stripeUrl =
      "https://connect.stripe.com/oauth/authorize?response_type=code&client_id=ca_MGdwrI4ZHE8RHT7hruM4C4vUP56VaaEa&scope=read_write";

  // 'https://connect.stripe.com/oauth/v2/authorize?response_type=code&client_id=ca_Hgkmh3KhFgG5oVQWqRLwo8l8T1EjlugW&scope=read_write&state=%7B%22nextURL%22%3A%22https%3A%2F%2Fweweyou.com%2Fstripe_connect%3Fresume%3D1660716729806x305972196309040700%22%2C%22user_id%22%3A%221660640182361x361329064136813200%22%2C%22appname%22%3A%22wtmeinit%22%7D&stripe_user%5Bemail%5D=aakashtest905%40gmail.com&stripe_user%5Burl%5D=aakashtest905%40gmail.com&stripe_user%5Bbusiness_name%5D=aakash%20test&stripe_user%5Bproduct_category%5D=events_and_ticketing&stripe_user%5Bcondition%5D=true&stripe_user%5Bcountry%5D=ID&stripe_user%5Bstreet_address%5D=undefined%20undefined&stripe_user%5Bcity%5D=Demak&stripe_user%5Bstate%5D=Central%20Java';

  double progressValue = 0.0;
  String? _url;
  bool loading = true;
  String? error;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  String congratsUrl = "https://mmfinfotech.co/Weweyou/user/thankyou";

  String? _authToken;

  @override
  void initState(){
    checkAuthValue();
   super.initState();
  }

  checkAuthValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('auth_Token');
    _authToken = token;
  }

  checkUrl(String url) async {
    String success =
        "https://mmfinfotech.co/Weweyou/user/thankyou".toLowerCase();
    _url = url;
    (WebViewController controller, BuildContext context) async {
      await controller.clearCache();
    };
    print('Url $url');
    if (url.toLowerCase().contains(success)) {
      String code = url.substring(url.indexOf("code=") + 5);
      print("Key code $code");
      try {
        Dio dio = Dio();
        var response = await dio.post(
          "${baseUrl}user/add_account",
          data: json.encode({
           "code" : code
          }),
          options: Options(
              method: 'POST',
              responseType: ResponseType
                  .json, // or ResponseType.JSON,,
              validateStatus: (status) => true,
              headers: {
                "Authorization" : "Bearer $_authToken",
                "X-localization" : "en"
              },
              contentType: 'application/json'),
        );
        debugPrint(
            "Response ${response.statusCode} ${response.data}");
        if (response.statusCode == 200 && response.data['status'] == true) {
          Future.delayed(
            const Duration(seconds: 2),
                () {
              showToast(toastMsg: 'Stripe Account Added Successfully.');
              return Navigator.pop(context, congratsUrl);
            },
          );
        } else {
          print("error ${response.data['message']}");
          showToast(
            toastMsg:
            "${response.data['message']}",
            backgroundColor:
            WeweyouColors.secondaryLightRed,
          );
        }
      } catch (e) {

        showToast(
          toastMsg: e.toString(),
        );
        debugPrint(e.toString());
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_url == "https://mmfinfotech.co/Weweyou/user/thankyou") {
          Navigator.pop(context, congratsUrl);
          showToast(toastMsg: 'Stripe account added successfully!');
        } else {
          Navigator.pop(context);
          showToast(toastMsg: 'Something went wrong');
        }
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              WebView(
                backgroundColor: Colors.grey[200],
                initialUrl: stripeUrl,
                onProgress: (progress) {
                  progressValue = double.parse(progress.toString());
                  if (mounted) setState(() {});
                },
                onWebViewCreated: (WebViewController controller) {
                  _controller.complete(controller);
                },
                javascriptMode: JavascriptMode.unrestricted,
                userAgent: 'Custom_User_Agent',
                onPageFinished: (url) {
                  loading = false;
                  checkUrl(url);
                  if (mounted) setState(() {});
                },
                onPageStarted: (url) {
                  error = null;
                  progressValue = 0.0;
                  loading = true;
                  if (mounted) setState(() {});
                },
                onWebResourceError: (error) {
                  showToast(
                      toastMsg: error.description,
                      backgroundColor: WeweyouColors.primaryDarkRed);
                },
              ),
              if (loading)
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white24,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.blue),
                          strokeWidth: 2.0,
                          backgroundColor: Colors.blue.withOpacity(0.4),
                        ),
                      ),
                      sizedBox(height: 10),
                      Text(
                        "Please Wait Connecting To Stripe",
                        style: poppinsRegular(
                            fontSize: 15, fontColor: WeweyouColors.primaryDarkRed),
                      )
                    ],
                  ),
                ),
              if (error != null)
                Container(
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      error!,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
