import 'package:flutter/material.dart';

import '../../../utils/common_button.dart';
import '../../../utils/common_text_style.dart';
import '../../../utils/constant.dart';

void userLocationPermission(BuildContext context, VoidCallback onPressedAllow, VoidCallback onPressedDeny) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: WeweyouColors.blackBackground,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: CircleAvatar(
          radius: 28,
          backgroundColor: WeweyouColors.secondaryOrange.withOpacity(0.2),
          child: const Icon(
            Icons.mail,
            size: 32,
            color: WeweyouColors.secondaryOrange,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Allow "Weweyou" to access your location?',
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: poppinsSemiBold(
                fontSize: 18,
                fontColor: WeweyouColors.customPureWhite,
              ),
            ),
            sizedBox(height: 10),
            Text(
              'This app needs your location to search for nearby events.',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: poppinsRegular(
                fontSize: 16,
                fontColor: WeweyouColors.greyPrimary,
              ),
            ),
            sizedBox(height: 30),
            CommonButton(
              onPressed: onPressedAllow,
              buttonName: 'Allow while using App',
              fontSize: 14,
            ),
            TextButton(
              onPressed:onPressedDeny,
              child: Text(
                "Don't Allow",
                style: poppinsSemiBold(
                  fontSize: 16,
                  fontColor: WeweyouColors.secondaryOrange,
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}