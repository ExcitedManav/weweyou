import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:weweyou/ui/utils/constant.dart';

class CustomWidgets {
  CustomWidgets._();

  static buildErrorSnackbar(
      {required BuildContext context,
      required String message,
      required Color backgroundColor}) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        content: Text(
          message,
          style: const TextStyle(
              color: WeweyouColors.customPureWhite, fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}

Future<bool?> showToast({required String toastMsg, Color? backgroundColor}) {
  return Fluttertoast.showToast(
    msg: toastMsg,
    backgroundColor: backgroundColor ?? Colors.green,
    textColor: WeweyouColors.customPureWhite,
    fontSize: 14,
    gravity: ToastGravity.BOTTOM,
  );
}

class CustomDialogBox extends StatefulWidget {
  CustomDialogBox(
      {Key? key, required this.context, this.max, required this.message})
      : super(key: key);
  final BuildContext context;
  final int? max;
  final String message;

  @override
  State<CustomDialogBox> createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    final ProgressDialog pr = ProgressDialog(context: widget.context);
    return pr.show(max: widget.max ?? 100, msg: widget.message);
  }
}

class CommonProgress {
  commonProgressIndicator({
    required BuildContext context,
    required String loadingMsg,
  }) {
    final ProgressDialog pro = ProgressDialog(context: context);
    pro.show(
      max: 100,
      msg: loadingMsg,
      barrierDismissible: true,
      backgroundColor: WeweyouColors.blackBackground,
      msgColor: WeweyouColors.customPureWhite,
      progressBgColor: WeweyouColors.customPureWhite,
      // completed: Completed(
      //   completedMsg: 'Done Baby',
      // ),
      barrierColor: Colors.black45,
      progressType: ProgressType.normal,
      progressValueColor: WeweyouColors.secondaryOrange,
      msgTextAlign: TextAlign.center,
      borderRadius: 15,
      msgMaxLines: 3,
      valueColor: Colors.green,
    );
    return pro;
  }
}
