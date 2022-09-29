import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:weweyou/ui/onboarding_screens/registration_screens/reset_password_screen.dart';
import 'package:weweyou/ui/onboarding_screens/registration_screens/widgets/ellipse_design.dart';
import 'package:weweyou/ui/utils/common_button.dart';
import 'package:weweyou/ui/utils/common_text_style.dart';
import 'package:weweyou/ui/utils/common_widgets.dart';
import 'package:weweyou/ui/utils/constant.dart';
import 'package:weweyou/ui/utils/input_text_field.dart';
import 'package:weweyou/ui/utils/validator.dart';

import '../../../data/models/onboarding_models/UserModel.dart';
import '../../../data/models/onboarding_models/sign_in_model.dart';
import '../../../data/networking/api_end_point.dart';
import '../../../data/networking/api_provider.dart';
import '../../../data/networking/shared_pref.dart';
import '../../home_screens/drawer_screens/drawer_screen.dart';
import 'package:http/http.dart' as http;
final googleSignIn = GoogleSignIn();

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);
  static const String route = '/signInRoute';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with WidgetsBindingObserver {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _forgotEmailController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();
  final FocusNode _forgotEmailFocus = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyForgot = GlobalKey<FormState>();

  final CommonProgress _commonProgress = CommonProgress();
  bool visiblePassword = true;

  bool changeLanguage = true;

  @override
  Widget build(BuildContext context) {
    final mediaQ = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: WeweyouColors.primaryDarkRed,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomText(
        text1: "sign_in.bottom_title".tr(),
        text2: 'sign_in.bottom_title2'.tr(),
        onPressed: () {
          Navigator.pushNamed(context, '/signUpRoute');
        },
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Stack(
          children: [
            const Align(
              alignment: Alignment.topRight,
              child: EllipseTopDesign(),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headingText(heading: 'sign_in.login_now'.tr()),
                  sizedBox(),
                  headingText2(
                    heading2: 'sign_in.login_now_des'.tr(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: mediaQ.height * 0.15),
              child: Stack(
                children: [
                  const EllipseHalf(),
                  Container(
                    height: mediaQ.height,
                    margin: EdgeInsets.only(top: mediaQ.height * 0.05),
                    padding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 20),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        color: WeweyouColors.blackBackground),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomFormField(
                              controller: _emailController,
                              hintText: 'sign_in.email'.tr(),
                              focusNode: _emailFocus,
                              validator: (val) => validEmailField(val),
                            ),
                            sizedBox(height: 20),
                            CustomFormField(
                              controller: _passwordController,
                              hintText: 'sign_in.password'.tr(),
                              focusNode: _passFocus,
                              validator: (val) => validPassword(val),
                              obscureText: visiblePassword,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    visiblePassword = !visiblePassword;
                                  });
                                },
                                icon: Icon(
                                  visiblePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 22,
                                  color: WeweyouColors.customPureWhite,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => _showDialog(),
                              child: Text(
                                'sign_in.forgot_password'.tr(),
                                style: poppinsBold(
                                    fontColor: WeweyouColors.secondaryOrange,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16),
                              ),
                            ),
                            sizedBox(),
                            CommonButton(
                              onPressed: () async {
                                final navigator = Navigator.of(context);
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  final ProgressDialog pr =
                                      _commonProgress.commonProgressIndicator(
                                          context: context,
                                          loadingMsg:
                                              'sign_in.loader_text'.tr());
                                  Dio dio = Dio();
                                  var response = await dio.post(
                                    baseUrl + ApiEndPoint.LOGIN,
                                    data: json.encode({
                                      'email': _emailController.text.trim(),
                                      'password':
                                          _passwordController.text.trim(),
                                      'fcm_token': 'FCM_TOKEN',
                                      'web_mobile_type': '1'
                                    }),
                                    options: Options(
                                        method: 'POST',
                                        responseType: ResponseType.json,
                                        validateStatus: (status) => true,
                                        contentType: 'application/json'),
                                  );
                                  debugPrint(
                                      'Status Message ${response.data['status']}');
                                  debugPrint(
                                      "Response here ${response.statusCode} ${response.data} ");
                                  if (response.statusCode == 200) {
                                    try {
                                      SignInModel user =
                                          SignInModel.fromJson(response.data);
                                      await setAuthToken(
                                        user.recordData!.authToken!,
                                      );
                                      final token = await getAuthToken();
                                      debugPrint("token $token");
                                      pr.close();
                                      // navigator.pushNamedAndRemoveUntil(, (route) => false);
                                      navigator.push(
                                        MaterialPageRoute(
                                          builder: (_) => const DrawerScreen(),
                                        ),
                                      );
                                      setValues();
                                      pr.close();
                                      showToast(
                                          toastMsg:
                                              '${response.data['message']}',
                                          backgroundColor: Colors.green);
                                    } catch (e) {
                                      showToast(
                                        toastMsg: e.toString(),
                                        backgroundColor: Colors.red,
                                      );
                                      debugPrint(e.toString());
                                    }
                                  } else {
                                    pr.close();
                                    showToast(
                                      toastMsg: "${response.data['message']}",
                                      backgroundColor: Colors.red,
                                    );
                                  }
                                }
                              },
                              buttonName: 'sign_in.login_now'.tr(),
                            ),
                            sizedBox(),
                            const DividerCommon(),
                            sizedBox(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                socialLoginButton(
                                  imagePath:
                                      'assets/images_icons/onboarding/google.png',
                                  onPressed: () {
                                    googleLogin();
                                  },
                                ),
                                socialLoginButton(
                                  imagePath:
                                      'assets/images_icons/onboarding/fb.png',
                                  onPressed: () {
                                    fbLoginNew();
                                  },
                                ),
                                socialLoginButton(
                                  imagePath:
                                      'assets/images_icons/onboarding/appleO.png',
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                changeLanguage = !changeLanguage;
                                if (changeLanguage == false) {
                                  context.setLocale(const Locale('fr'));
                                } else {
                                  context.setLocale(const Locale('en'));
                                }
                                if (mounted) setState(() {});
                              },
                              icon: const Icon(
                                Icons.language,
                                color: Colors.white,
                                size: 22,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  socialLoginButton(
      {required String imagePath, required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 45,
        width: 80,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        // padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset(imagePath),
      ),
    );
  }

  void fbLoginNew() async {
    debugPrint('Function');
    final LoginResult result = await FacebookAuth.instance.login();
    debugPrint("helllo sfjaslfjds${result}");
    if (result.status == LoginStatus.success) {
      final accessToken = result.accessToken;

      try {
        Map<String, dynamic> userData =
            await FacebookAuth.instance.getUserData();
        debugPrint('User Data ${userData}');
        debugPrint("helllo ");
        var email = userData['email'].toString();
        var first_name = userData['first_name']?.toString() ?? userData['name'];
        var last_name = userData['last_name'] ?? '';
        var imgUrl = userData['picture']['data']['url'].toString();
        debugPrint('First Name $first_name');
        try {
          Map<String, String> headers = {
            'Content-Type': "application/json",
          };
          final response = await http.post(
            Uri.parse(
              baseUrl + ApiEndPoint.SOCIALLOGIN,
            ),
            headers: headers,
            body: jsonEncode({
              "first_name": first_name,
              "last_name": last_name,
              "email": email,
              "mediaId": accessToken?.userId.toString(),
              "img_url": imgUrl,
              "login_type": "facebook",
              "web_mobile_type": "1"
            }),
          );
          var model = json.decode(response.body);
          debugPrint("helllo CCCC");
          if (response.statusCode == 200) {
            debugPrint("hFInally");
          } else {}
        } catch (e) {
          debugPrint('api exception $e');
        }
      } catch (e) {
        debugPrint('fg login exception1 $e');
      }
    }
  }


  void googleLogin() async {
    final navigator = Navigator.of(context);
    await googleSignIn.signIn().then((result) {
      result!.authentication.then((googleKey) async {
        try {
          Map<String, String> headers = {
            'Content-Type': "application/json",
            'X-localization': "en",
          };
          var body = {
            "first_name":
                googleSignIn.currentUser!.displayName!.split(' ')[0].toString(),
            "last_name":
                googleSignIn.currentUser!.displayName!.split(' ')[1].toString(),
            "email": googleSignIn.currentUser!.email.toString(),
            "login_type": "google",
            "mediaId": googleSignIn.currentUser!.id.toString(),
            "fcm_token": "FCM_TOKEN",
            "web_mobile_type": "1"
          };
          var url = baseUrl + ApiEndPoint.SOCIALLOGIN;
          final response = await http.post(
            Uri.parse(url),
            headers: headers,
            body: jsonEncode(body),
          );
          debugPrint("Sent Body $body");
          var model = json.decode(response.body);
          if (response.statusCode == 200) {
            await setAuthToken(model['record']['authtoken']);
            var token = await getAuthToken();
            debugPrint("Token here $token");
            showToast(
              toastMsg: model['message'],
            );
            navigator.push(
              MaterialPageRoute(
                builder: (_) => const DrawerScreen(),
              ),
            );
          } else {
            log("model erro");
            log(model['message']);
          }
        } catch (e) {
          log('api exception $e');
        }
      }).catchError((err) {
        log('inner error');
      });
    }).catchError((err) {
      log('error occured $err');
    });
  }

  _showDialog() {
    return showDialog(
      builder: (c) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: WeweyouColors.blackBackground,
          ),
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
          child: Form(
            key: _formKeyForgot,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 60,
                    width: 70,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black),
                    child:
                        Image.asset('assets/images_icons/onboarding/key.png'),
                  ),
                  sizedBox(),
                  headingText(
                    heading: 'sign_in.forgot_password'.tr(),
                    fontSize: 22,
                  ),
                  sizedBox(height: 5),
                  headingText2(
                    heading2: 'sign_in.login_now'.tr(),
                    fontSize: 16,
                  ),
                  sizedBox(height: 20),
                  CustomFormField(
                    controller: _forgotEmailController,
                    hintText: 'sign_in.email'.tr(),
                    focusNode: _forgotEmailFocus,
                    validator: (val) => validEmailField(val),
                  ),
                  sizedBox(height: 30),
                  CommonButton(
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      if (_formKeyForgot.currentState!.validate()) {
                        Navigator.pop(context);
                        ProgressDialog pr =
                            _commonProgress.commonProgressIndicator(
                                context: context,
                                loadingMsg: 'sign_in.sending_mail'.tr());
                        Dio dio = Dio();
                        var response = await dio.post(
                          baseUrl + ApiEndPoint.FORGOTPASSWORD,
                          data: json.encode({
                            'email': _forgotEmailController.text,
                          }),
                          options: Options(
                            method: 'POST',
                            responseType: ResponseType.json,
                            validateStatus: (status) => true,
                            contentType: 'application/json',
                          ),
                        );
                        if (response.statusCode == 200) {
                          try {
                            ForgotPasswordModel user =
                                ForgotPasswordModel.formJson(response.data);
                            debugPrint('${response.data}');
                            pr.close();
                            navigator.push(
                              MaterialPageRoute(
                                builder: (_) => ResetPasswordScreen(
                                  email: _forgotEmailController.text,
                                ),
                              ),
                            );
                            pr.close();
                            showToast(
                              toastMsg: '${response.data['message']}',
                              backgroundColor: Colors.green,
                            );
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                        } else {
                          pr.close();
                          showToast(
                            toastMsg: "${response.data['message']}",
                            backgroundColor: WeweyouColors.secondaryLightRed,
                          );
                        }
                      }
                    },
                    buttonName: 'sign_in.submit_btn'.tr(),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'sign_in.close_btn'.tr(),
                        style: poppinsRegular(
                          fontSize: 16,
                          fontColor: WeweyouColors.secondaryOrange,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      context: context,
    );
  }
}
