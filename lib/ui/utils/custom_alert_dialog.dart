import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weweyou/ui/utils/common_text_style.dart';
import 'package:weweyou/ui/utils/constant.dart';

showAlertDialog({
  required BuildContext context,
  required String headline,
  required VoidCallback onPressedYes,

}) {
    showCupertinoModalPopup<void>(
      barrierColor: Colors.black26,
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          'Alert',
          style: poppinsBold(
            fontColor: WeweyouColors.blackPrimary,
          ),
        ),
        content: Text(
          headline,
          style: poppinsRegular(
            fontSize: 16,
            fontColor: WeweyouColors.blackPrimary,
          ),
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            // isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'NO',
              style: poppinsMedium(
                fontColor: Colors.blue,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: onPressedYes,
            child: Text(
              'Yes',
              style: poppinsMedium(
                fontColor: WeweyouColors.secondaryLightRed,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
}
