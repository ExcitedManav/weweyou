import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:weweyou/ui/home_screens/create_event/create_event.dart';
import 'package:weweyou/ui/utils/common_button.dart';
import 'package:weweyou/ui/utils/constant.dart';

import '../../../data/networking/api_end_point.dart';
import '../../../data/networking/api_provider.dart';
import '../../utils/common_text_style.dart';
import '../../utils/common_widgets.dart';

class ConfirmationMailScreen extends StatefulWidget {
  const ConfirmationMailScreen({Key? key, required this.email})
      : super(key: key);
  static const String route = '/confirmMailScreen';

  final String email;

  @override
  State<ConfirmationMailScreen> createState() => _ConfirmationMailScreenState();
}

class _ConfirmationMailScreenState extends State<ConfirmationMailScreen>
    with SingleTickerProviderStateMixin {
  final String confirmMail1 =
      'We have sent an email with a confirmation link to your email address. In order to complete the sign-up process, please click the confirmation link.';

  final String confirmMail2 =
      'If you do not receive a confirmation email, please check your spam folder. Also, please verify that you entered a valid email address in our sign-up form.';

  String strDigits(int n) => n.toString().padLeft(2, '0');

  late AnimationController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(
          seconds: 60,
        ) // gameData.levelClock is a user entered number elsewhere in the applciation
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WeweyouColors.lightBlackColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              width: 250,
              child: Image.asset(
                  'assets/images_icons/onboarding/confirm_mail_Icon.png'),
            ),
            Text(
              'Confirm your email address',
              style: poppinsRegular(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontColor: WeweyouColors.customPureWhite,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              confirmMail1,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: poppinsRegular(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontColor: WeweyouColors.customPureWhite,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              confirmMail2,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: poppinsRegular(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontColor: WeweyouColors.customPureWhite,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CommonButton(
                    width: MediaQuery.of(context).size.width * 0.4,
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      final scaffoldMes = ScaffoldMessenger.of(context);

                      final ProgressDialog pr =
                          ProgressDialog(context: context);
                      pr.show(
                          max: 100,
                          msg: "Resending Confirmation Mail",
                          barrierDismissible: true);
                      Dio dio = Dio();

                      var response = await dio.post(
                        baseUrl + ApiEndPoint.RESENDCONFIRMMAIL,
                        data: json.encode({
                          'email': widget.email,
                        }),
                        options: Options(
                            method: 'POST',
                            responseType: ResponseType.json,
                            // or ResponseType.JSON,,
                            validateStatus: (status) => true,
                            contentType: 'application/json'),
                      );
                      print("Hell check email ${widget.email}");
                      debugPrint(
                          "Response ${response.statusCode} ${response.data}");
                      if (response.statusCode == 200) {
                        try {
                          debugPrint('${response.data}');
                          pr.close();
                          log(mounted.toString());
                          // pr.close();
                          showToast(
                              toastMsg: '${response.data['message']}',
                              backgroundColor: Colors.green);
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      } else {
                        pr.close();
                        debugPrint('status 200 ');
                        final snackBar = SnackBar(
                          content: Text("${response.data['message']}"),
                          backgroundColor: Colors.red,
                        );
                        scaffoldMes.showSnackBar(snackBar);
                      }
                    },
                    buttonName: 'Resend Email',
                    textColor: WeweyouColors.primaryDarkRed,
                    fontSize: 16,
                    backgroundColor: WeweyouColors.blackBackground,
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 25),
                  ),
                ),
                Expanded(
                  child: CommonButton(
                    width: MediaQuery.of(context).size.width * 0.4,
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      final ProgressDialog pr =
                          ProgressDialog(context: context);
                      pr.show(
                          max: 100,
                          msg: "Checking...",
                          barrierDismissible: true);
                      Dio dio = Dio();
                      var response = await dio.post(
                        baseUrl + ApiEndPoint.CHECKEMAILVERIFY,
                        data: json.encode({
                          'email': widget.email,
                        }),
                        options: Options(
                            method: 'POST',
                            responseType: ResponseType.json,
                            validateStatus: (status) => true,
                            contentType: 'application/json'),
                      );
                      debugPrint(
                          "Response ${response.statusCode} ${response.data}");
                      if (response.statusCode == 200) {
                        try {
                          debugPrint('${response.data}');
                          pr.close();
                          log(mounted.toString());
                          navigator.pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => CreateEventScreen(),
                            ),
                          );
                          pr.close();
                          showToast(
                              toastMsg: '${response.data['message']}',
                              backgroundColor: Colors.green);
                        } catch (e) {
                          showToast(
                            toastMsg: "${response.data['message']}",
                            backgroundColor: WeweyouColors.secondaryLightRed,
                          );
                        }
                      } else {
                        pr.close();
                        debugPrint('status 200 ');
                        showToast(
                          toastMsg: "${response.data['message']}",
                          backgroundColor: WeweyouColors.secondaryLightRed,
                        );
                      }
                    },
                    buttonName: 'Email Verified',
                    backgroundColor: WeweyouColors.primaryDarkRed,
                    fontSize: 16,
                    margin: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 25,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
