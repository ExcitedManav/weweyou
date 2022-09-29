/*Used for any field when only required*/
import 'package:easy_localization/easy_localization.dart';

String? requiredField(String? val, String title) {
  if (val == null || val.trim().isEmpty) {
    return "${title} " + "validations.is_req".tr();
  } else {
    return null;
  }
}

String? validPassword(String? val) {
  final RegExp nameExp = RegExp(r'^.{8,}$');
  if (val == null || val.trim().isEmpty) {
    return "validations.pass_req".tr();
  } else if (nameExp.hasMatch(val.trim())) {
    return null;
  } else {
    return "validations.pass_req_l".tr();
  }
}

String? validConfirmPassword(String? val) {
  final RegExp nameExp = RegExp(r'^.{8,}$');
  if (val == null || val.trim().isEmpty) {
    return "validations.con_pass_req".tr();
  } else if (nameExp.hasMatch(val.trim())) {
    return null;
  } else {
    return "validations.pass_req_l".tr();
  }
}

String? validEmailField(String? val) {
  final RegExp nameExp =
      RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
  if (val == null || val.trim().isEmpty) {
    return "validations.email_req".tr();
  } else if (nameExp.hasMatch(val.trim())) {
    return null;
  } else {
    return "validations.email_valid".tr();
  }
}
