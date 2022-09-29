import 'dart:convert';
import 'dart:developer';

import 'package:country_picker/country_picker.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:weweyou/data/models/onboarding_models/signUpModel.dart';
import 'package:weweyou/data/networking/api_end_point.dart';
import 'package:weweyou/data/networking/api_provider.dart';
import 'package:weweyou/ui/onboarding_screens/registration_screens/select_category_screen.dart';
import 'package:weweyou/ui/onboarding_screens/registration_screens/signIn_screen.dart';
import 'package:weweyou/ui/onboarding_screens/registration_screens/widgets/ellipse_design.dart';
import 'package:weweyou/ui/utils/common_drop_down.dart';
import 'package:weweyou/ui/utils/common_widgets.dart';

import '../../../data/networking/shared_pref.dart';
import '../../home_screens/drawer_screens/drawer_screen.dart';
import '../../utils/common_button.dart';
import '../../utils/common_text_style.dart';
import '../../utils/constant.dart';
import '../../utils/input_text_field.dart';
import '../../utils/validator.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  static const String route = '/signUpRoute';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneNumFocus = FocusNode();
  final FocusNode _confirmPassFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? selectedLanguage;
  String? selectedCurrency;

  final List<String> currencyList = [
    'USD',
    'EUR',
    'CHF',
  ];
  final List<String> langaugeList = [
    'English',
    'Francais',
  ];

  final ApiProvider _apiProvider = ApiProvider();
  final ApiEndPoint _apiEndPoint = ApiEndPoint();

  final CommonProgress _commonProgress = CommonProgress();

  bool visiblePassword = true;
  bool visibleConfirmPassword = true;

  String selectedCountryCode = '91';

  @override
  Widget build(BuildContext context) {
    final mediaQ = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: WeweyouColors.primaryDarkRed,
      bottomNavigationBar: BottomText(
        text1: "sign_up.bottom_title".tr(),
        text2: 'sign_in.login_now'.tr(),
        onPressed: () {
          Navigator.pushNamed(context, '/signInRoute');
        },
      ),
      body: Form(
        key: _formKey,
        child: Padding(
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
                    headingText(heading: 'sign_up.create_acc'.tr()),
                    sizedBox(),
                    headingText2(
                      heading2: 'sign_up.create_acc_des'.tr(),
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
                      // height: mediaQ.height,
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
                        padding: const EdgeInsets.only(bottom: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomFormField(
                              controller: _firstNameController,
                              hintText: 'sign_up.first_name'.tr(),
                              focusNode: _firstNameFocus,
                              validator: (val) =>
                                  requiredField(val, 'sign_up.first_name'.tr()),
                            ),
                            sizedBox(height: 20),
                            CustomFormField(
                              controller: _lastNameController,
                              hintText: 'sign_up.last_name'.tr(),
                              focusNode: _lastNameFocus,
                              validator: (val) =>
                                  requiredField(val, 'sign_up.last_name'.tr()),
                            ),
                            sizedBox(height: 20),
                            CustomFormField(
                              controller: _emailController,
                              hintText: 'sign_in.email'.tr(),
                              focusNode: _emailFocus,
                              validator: (val) => validEmailField(val),
                            ),
                            sizedBox(height: 20),
                            CustomFormField(
                              controller: _phoneNumberController,
                              hintText: 'sign_up.phone_num'.tr(),
                              focusNode: _phoneNumFocus,
                              prefixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () => countryPicker(),
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(
                                          left: 13, right: 10),
                                      child: Row(
                                        children: [
                                          Text(
                                            "(+$selectedCountryCode)",
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: poppinsRegular(
                                                fontColor: WeweyouColors
                                                    .customPureWhite),
                                          ),
                                          const Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color:
                                                WeweyouColors.customPureWhite,
                                            size: 18,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              validator: (val) =>
                                  requiredField(val, 'sign_up.phone_num'.tr()),
                              textInputType: TextInputType.phone,
                            ),
                            sizedBox(height: 20),
                            CommonDropDown(
                              hintText: 'Language',
                              selectedValue:
                                  selectedLanguage ?? langaugeList[0],
                              onChanged: (value) {
                                setState(() {
                                  selectedLanguage = value as String;
                                });
                              },
                              items: langaugeList.map((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: poppinsRegular(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                );
                              }).toList(),
                            ),
                            sizedBox(),
                            CommonDropDown(
                              hintText: 'Currency',
                              selectedValue:
                                  selectedCurrency ?? currencyList[0],
                              onChanged: (val) {
                                setState(() {
                                  selectedCurrency = val as String;
                                });
                              },
                              items: currencyList
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                        e,
                                        style: poppinsRegular(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            sizedBox(),
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
                            sizedBox(height: 20),
                            CustomFormField(
                              controller: _confirmPasswordController,
                              hintText: 'sign_up.confirm_pass'.tr(),
                              focusNode: _confirmPassFocus,
                              validator: (val) => validConfirmPassword(val),
                              obscureText: visibleConfirmPassword,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    visibleConfirmPassword =
                                        !visibleConfirmPassword;
                                  });
                                },
                                icon: Icon(
                                  visibleConfirmPassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 22,
                                  color: WeweyouColors.customPureWhite,
                                ),
                              ),
                            ),
                            sizedBox(),
                            CommonButton(
                              onPressed: () async {
                                final navigator = Navigator.of(context,
                                    rootNavigator: true); // store the Navigator
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  if (_passwordController.text ==
                                      _confirmPasswordController.text) {
                                    final ProgressDialog pr =
                                        _commonProgress.commonProgressIndicator(
                                            context: context,
                                            loadingMsg:
                                                "sign_up.loader_text".tr());
                                    var reqBody = {
                                      'first_name':
                                          _firstNameController.text.trim(),
                                      'last_name':
                                          _lastNameController.text.trim(),
                                      'email': _emailController.text.trim(),
                                      "language": selectedLanguage,
                                      'password':
                                          _passwordController.text.trim(),
                                      'fcm_token': 'FCM_TOKEN',
                                      'currency': selectedCurrency,
                                      'web_mobile_type': '1'
                                    };
                                    try {
                                      Dio dio = Dio();
                                      var response = await dio.post(
                                        baseUrl + ApiEndPoint.REGISTERAPI,
                                        data: json.encode(reqBody),
                                        options: Options(
                                            method: 'POST',
                                            responseType: ResponseType
                                                .json, // or ResponseType.JSON,,
                                            validateStatus: (status) => true,
                                            contentType: 'application/json'),
                                      );
                                      debugPrint(
                                          "Response ${response.statusCode} ${response.data}");
                                      if (response.statusCode == 200) {
                                        try {
                                          SignUpModel user =
                                              SignUpModel.fromJson(
                                                  response.data);
                                          pr.close();
                                          await setEmail(_emailController.text);
                                          navigator.pushReplacement(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  SelectCategoryScreen(
                                                email: _emailController.text,
                                              ),
                                            ),
                                          );

                                          // navigator.push(
                                          //   MaterialPageRoute(
                                          //     builder: (_) =>
                                          //         ConfirmationMailScreen(
                                          //           email: _emailController.text,
                                          //         ),
                                          //   ),
                                          // );
                                          pr.close();
                                          showToast(
                                              toastMsg:
                                                  '${response.data['message']}',
                                              backgroundColor: Colors.green);
                                        } catch (e) {
                                          debugPrint(e.toString());
                                        }
                                      } else {
                                        pr.close();
                                        showToast(
                                          toastMsg:
                                              "${response.data['message']}",
                                          backgroundColor:
                                              WeweyouColors.secondaryLightRed,
                                        );
                                      }
                                    } catch (e) {
                                      pr.close();
                                      showToast(
                                        toastMsg: e.toString(),
                                      );
                                      debugPrint(e.toString());
                                    }
                                  } else {
                                    showToast(
                                      toastMsg: "Passwords do not match",
                                      backgroundColor:
                                          WeweyouColors.secondaryLightRed,
                                    );
                                  }
                                }
                              },
                              buttonName: 'sign_up.sign_up_btn'.tr(),
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
                                  onPressed: () => googleLogin(),
                                ),
                                socialLoginButton(
                                  imagePath:
                                      'assets/images_icons/onboarding/fb.png',
                                  onPressed: () =>fbLoginNew(),
                                ),
                                socialLoginButton(
                                  imagePath:
                                      'assets/images_icons/onboarding/appleO.png',
                                  onPressed: () {},
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
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

  countryPicker() {
    return showCountryPicker(
      context: context,
      showPhoneCode: true,
      // showWorldWide: true,
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: WeweyouColors.blackBackground,
        textStyle: poppinsRegular(
          fontSize: 16,
          fontColor: WeweyouColors.customPureWhite,
        ),
        bottomSheetHeight: MediaQuery.of(context).size.height * 0.7,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
        inputDecoration: InputDecoration(
          hoverColor: WeweyouColors.customPureWhite,
          focusColor: WeweyouColors.customPureWhite,
          focusedBorder: customBorder(),
          enabledBorder: customBorder(),
          disabledBorder: customBorder(),
          hintText: 'sign_up.search_code'.tr(),
          hintStyle: poppinsRegular(
            fontColor: WeweyouColors.customPureWhite,
            fontSize: 16,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: WeweyouColors.customPureWhite,
          ),
          fillColor: WeweyouColors.blackPrimary,
          filled: true,
          border: customBorder(),
        ),
      ),
      onSelect: (Country country) {
        setState(() {
          selectedCountryCode = country.phoneCode;
        });
      },
    );
  }

  customBorder() {
    return UnderlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: WeweyouColors.customPureWhite,
      ),
    );
  }

  void fbLoginNew() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      final accessToken = result.accessToken;

      try {
        Map<String, dynamic> userData =
            await FacebookAuth.instance.getUserData();

        var email = userData['email'].toString();
        var firstName = userData['first_name']?.toString() ?? userData['name'];
        var lastName = userData['last_name'] ?? '';
        var imgUrl = userData['picture']['data']['url'].toString();
        debugPrint('First Name $firstName');
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
              "first_name": firstName,
              "last_name": lastName,
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
      }).catchError(
        (err) {
          log('inner error');
        },
      );
    }).catchError(
      (err) {
        log('error occured $err');
      },
    );
  }
}
