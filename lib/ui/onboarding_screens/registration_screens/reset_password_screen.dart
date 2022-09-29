import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:weweyou/data/networking/api_end_point.dart';
import 'package:weweyou/data/networking/api_provider.dart';
import 'package:weweyou/ui/onboarding_screens/registration_screens/select_category_screen.dart';
import 'package:weweyou/ui/onboarding_screens/registration_screens/signIn_screen.dart';
import 'package:weweyou/ui/onboarding_screens/registration_screens/widgets/ellipse_design.dart';
import 'package:weweyou/ui/utils/common_button.dart';
import 'package:weweyou/ui/utils/constant.dart';
import 'package:weweyou/ui/utils/validator.dart';

import '../../utils/common_text_style.dart';
import '../../utils/common_widgets.dart';
import '../../utils/input_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key, required this.email}) : super(key: key);
  static const String route = '/resetPasswordScreenRoute';
  final String email;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPassController =
      TextEditingController();

  final FocusNode _otpFocus = FocusNode();
  final FocusNode _newPassFocus = FocusNode();
  final FocusNode _newConfPassFocus = FocusNode();

  final ApiProvider _apiProvider = ApiProvider();
  final ApiEndPoint _apiEndPoint = ApiEndPoint();
  final CommonProgress _commonProgress = CommonProgress();

  @override
  Widget build(BuildContext context) {
    final mediaQ = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: WeweyouColors.primaryDarkRed,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Material(
        color: WeweyouColors.blackBackground,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: CommonButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                final ProgressDialog pr =
                    _commonProgress.commonProgressIndicator(
                        context: context, loadingMsg: 'Saving New Password');
                Dio dio = Dio();
                var response = await dio.post(
                  baseUrl + ApiEndPoint.RESETPASSWORD,
                  data: json.encode({
                    'email': widget.email,
                    'otp': _otpController.text,
                    'password': _newPasswordController.text,
                    'password_confirmation': _confirmNewPassController.text,
                  }),
                  options: Options(
                    method: 'POST',
                    responseType: ResponseType.json,
                    validateStatus: (status) => true,
                    contentType: 'application/json',
                  ),
                );
                debugPrint("Response ${response.statusCode} ${response.data}");
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
            buttonName: 'Save Password',
          ),
        ),
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
                  headingText(heading: 'Reset Password'),
                  sizedBox(),
                  headingText2(
                    heading2:
                        'Please fill the below details to generate new password.',
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
                              controller: _otpController,
                              hintText: 'Enter 4 digit OTP here',
                              focusNode: _otpFocus,
                              textInputType: TextInputType.number,
                              validator: (val) => requiredField(val, 'OTP'),
                            ),
                            sizedBox(height: 20),
                            CustomFormField(
                              controller: _newPasswordController,
                              hintText: 'New Password',
                              focusNode: _newPassFocus,
                              textInputType: TextInputType.number,
                              validator: (val) => validPassword(val),
                            ),
                            sizedBox(height: 20),
                            CustomFormField(
                              controller: _confirmNewPassController,
                              textInputType: TextInputType.number,
                              hintText: 'Confirm Password',
                              focusNode: _newConfPassFocus,
                              validator: (val) => validConfirmPassword(val),
                            ),
                            sizedBox(),
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
}
