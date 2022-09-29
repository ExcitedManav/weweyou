import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:weweyou/ui/utils/input_text_field.dart';
import 'package:weweyou/ui/utils/validator.dart';

import '../../../data/networking/api_end_point.dart';
import '../../../data/networking/api_provider.dart';
import '../../utils/common_button.dart';
import '../../utils/common_widgets.dart';
import '../../utils/constant.dart';

class SetNewPassword extends StatefulWidget {
  const SetNewPassword({Key? key, required this.email}) : super(key: key);

  final String email;

  @override
  State<SetNewPassword> createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  final FocusNode _otpFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();
  final FocusNode _confirmFocus = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WeweyouColors.lightBlackColor,
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            color: WeweyouColors.lightBlackColor,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Set New Password',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: WeweyouColors.customPureWhite),
                  ),
                  const SizedBox(height: 40),
                  CustomFormField(
                    controller: _otpController,
                    focusNode: _otpFocus,
                    hintText: 'Enter your OTP',
                    validator: (val) => requiredField(val, 'OTP'),
                  ),
                  const SizedBox(height: 20),
                  CustomFormField(
                    controller: _passwordController,
                    focusNode: _passFocus,
                    hintText: 'Enter your New Password',
                    validator: (val) => validPassword(val),
                  ),
                  const SizedBox(height: 20),
                  CustomFormField(
                    controller: _confirmPassController,
                    focusNode: _confirmFocus,
                    hintText: 'Confirm New Password',
                    validator: (val) => validConfirmPassword(val),
                  ),
                  const SizedBox(height: 20),
                  CommonButton(
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        final ProgressDialog pr =
                            ProgressDialog(context: context);
                        pr.show(
                            max: 100,
                            msg: "Saving New Password",
                            barrierDismissible: true);
                        Dio dio = Dio();

                        var response = await dio.post(
                          baseUrl + ApiEndPoint.RESETPASSWORD,
                          data: json.encode({
                            'email': widget.email,
                            'otp': _otpController.text,
                            'password': _passwordController.text,
                            'password_confirmation': _confirmPassController.text,
                          }),
                          options: Options(
                              method: 'POST',
                              responseType:
                                  ResponseType.json, // or ResponseType.JSON,,
                              validateStatus: (status) => true,
                              contentType: 'application/json'),
                        );
                        print(
                            "repsonse ${response.statusCode} ${response.data}");
                        if (response.statusCode == 200) {
                          try {
                            debugPrint('${response.data}');
                            showToast(
                                toastMsg: '${response.data['message']}',
                                backgroundColor: Colors.green);
                            pr.close();
                            navigator.pushNamed('/registrationScreen');
                            pr.close();
                          } catch (e) {
                            print(e.toString());
                          }
                        } else {
                          pr.close();
                          debugPrint('status 200 ');
                          final snackBar = SnackBar(
                            content: Text("${response.data['message']}"),
                            backgroundColor: Colors.red,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                    },
                    buttonName: 'Save Password',
                    backgroundColor: WeweyouColors.secondaryLightRed,
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 25),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
