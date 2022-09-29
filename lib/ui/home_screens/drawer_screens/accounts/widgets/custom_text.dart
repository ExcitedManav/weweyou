import 'package:flutter/material.dart';
import 'package:weweyou/ui/utils/common_text_style.dart';
import 'package:weweyou/ui/utils/constant.dart';

class CustomText extends StatelessWidget {
  const CustomText({Key? key, required this.initialText, this.requiredText})
      : super(key: key);

  final String initialText;
  final String? requiredText;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: initialText,
        style: poppinsRegular(
          fontColor: WeweyouColors.greyPrimary,
          fontSize: 14
        ),
        children: <TextSpan>[
          TextSpan(
            text: requiredText ?? '',
            style: poppinsRegular(
              fontColor: WeweyouColors.secondaryLightRed,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
