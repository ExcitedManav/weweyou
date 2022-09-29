import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:weweyou/ui/home_screens/drawer_screens/accounts/widgets/custom_text.dart';
import 'package:weweyou/ui/utils/common_button.dart';
import 'package:weweyou/ui/utils/common_text_style.dart';
import 'package:weweyou/ui/utils/common_widgets.dart';
import 'package:weweyou/ui/utils/constant.dart';
import 'package:weweyou/ui/utils/input_text_field.dart';
import 'package:weweyou/ui/utils/validator.dart';

import '../../../../data/models/onboarding_models/UserModel.dart';
import '../../../../data/networking/api_end_point.dart';
import '../../../../data/networking/api_provider.dart';

class SetNewPasswordProfile extends StatefulWidget {
  const SetNewPasswordProfile({Key? key}) : super(key: key);

  @override
  State<SetNewPasswordProfile> createState() => _SetNewPasswordProfileState();
}

class _SetNewPasswordProfileState extends State<SetNewPasswordProfile> {
  final TextEditingController _emailCont = TextEditingController();
  final TextEditingController _otpCont = TextEditingController();
  final TextEditingController _newPassCont = TextEditingController();
  final TextEditingController _newPassConfirmCont = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _otpFocus = FocusNode();
  final FocusNode _newPassFocus = FocusNode();
  final FocusNode _newPassConfirmFocus = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CommonProgress _commonProgress = CommonProgress();

  int checker = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WeweyouColors.blackBackground,
      appBar: AppBar(
        backgroundColor: WeweyouColors.blackPrimary,
        toolbarHeight: 70,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 22,
            color: WeweyouColors.customPureWhite,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Set New Password',
                style: poppinsMedium(fontWeight: FontWeight.w500, fontSize: 20),
              ),
              if (checker == 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sizedBox(height: 20),
                    const CustomText(initialText: 'Email'),
                    sizedBox(height: 10),
                    CustomFormField(
                      controller: _emailCont,
                      hintText: "Enter email",
                      validator: (val) => validEmailField(val),
                      textInputType: TextInputType.emailAddress,
                      focusNode: _emailFocus,
                    ),
                  ],
                ),
              if (checker == 1)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sizedBox(height: 20),
                    const CustomText(initialText: 'OTP'),
                    sizedBox(height: 10),
                    CustomFormField(
                      controller: _otpCont,
                      hintText: "Enter OTP",
                      validator: (val) => requiredField(val, 'OTP'),
                      focusNode: _emailFocus,
                    ),
                    sizedBox(height: 20),
                    const CustomText(initialText: 'New Password'),
                    sizedBox(height: 10),
                    CustomFormField(
                      controller: _newPassCont,
                      hintText: "Enter New Password",
                      validator: (val) => requiredField(val, 'New Password'),
                      focusNode: _newPassFocus,
                    ),
                    sizedBox(height: 20),
                    const CustomText(initialText: 'Confirm Password'),
                    sizedBox(height: 10),
                    CustomFormField(
                      controller: _newPassConfirmCont,
                      hintText: "Enter ConfirmPassword",
                      validator: (val) =>
                          requiredField(val, 'Confirm Password'),
                      focusNode: _newPassConfirmFocus,
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
      bottomNavigationBar: checker == 0
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
              child: CommonButton(
                onPressed: () async {
                  checker = 1;
                  if (_formKey.currentState!.validate()) {
                    ProgressDialog pr = _commonProgress.commonProgressIndicator(
                        context: context,
                        loadingMsg: 'sign_in.sending_mail'.tr());
                    try {
                      Dio dio = Dio();
                      var response = await dio.post(
                        baseUrl + ApiEndPoint.FORGOTPASSWORD,
                        data: json.encode({
                          'email': _emailCont.text,
                        }),
                        options: Options(
                          method: 'POST',
                          responseType: ResponseType.json,
                          validateStatus: (status) => true,
                          contentType: 'application/json',
                        ),
                      );
                      if (response.statusCode == 200) {
                        ForgotPasswordModel user =
                            ForgotPasswordModel.formJson(response.data);
                        debugPrint('${response.data}');
                        pr.close();
                        checker = 1;
                        if (mounted) setState(() {});
                        showToast(
                          toastMsg: '${response.data['message']}',
                          backgroundColor: Colors.green,
                        );
                      } else {
                        pr.close();
                        showToast(
                          toastMsg: "${response.data['message']}",
                          backgroundColor: WeweyouColors.secondaryLightRed,
                        );
                      }
                    } catch (e) {
                      pr.close();
                      showToast(toastMsg: e.toString());
                    }
                  }
                },
                buttonName: 'Reset Password',
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CommonButton(
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        final ProgressDialog pr =
                            _commonProgress.commonProgressIndicator(
                                context: context,
                                loadingMsg: 'Saving New Password');
                        Dio dio = Dio();
                        var response = await dio.post(
                          baseUrl + ApiEndPoint.RESETPASSWORD,
                          data: json.encode({
                            'email': "alok.gupta@mmfinfotech.in",
                            'otp': _otpCont.text,
                            'password': _newPassCont.text,
                            'password_confirmation': _newPassConfirmCont.text,
                          }),
                          options: Options(
                            method: 'POST',
                            responseType: ResponseType.json,
                            validateStatus: (status) => true,
                            contentType: 'application/json',
                          ),
                        );
                        debugPrint(
                            "Response ${response.statusCode} ${response.data}");
                        if (response.statusCode == 200) {
                          try {
                            showToast(
                              toastMsg: '${response.data['message']}',
                              backgroundColor: Colors.green,
                            );
                            pr.close();
                            navigator.pop();
                            pr.close();
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
                    buttonName: 'Save',
                  ),
                  sizedBox(height: 20),
                  CommonButton(
                    onPressed: () {
                      Navigator.pop(context);
                      checker = 0;
                    },
                    buttonName: 'Cancel',
                  )
                ],
              ),
            ),
    );
  }
}
