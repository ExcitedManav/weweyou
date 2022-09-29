import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../utils/common_text_style.dart';
import '../../../utils/constant.dart';

class EllipseTopDesign extends StatelessWidget {
  const EllipseTopDesign({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQ = MediaQuery.of(context).size;
    return SizedBox(
      height: mediaQ.height * 0.18,
      child: Image.asset('assets/images_icons/onboarding/ellipse_topRight.png'),
    );
  }
}

class EllipseHalf extends StatelessWidget {
  const EllipseHalf({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQ = MediaQuery.of(context).size;
    return SizedBox(
      height: mediaQ.height * 0.2,
      child: Image.asset(
        'assets/images_icons/onboarding/Ellipse_half.png',
      ),
    );
  }
}

class DividerCommon extends StatelessWidget {
  const DividerCommon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Wrap(
          children: [
            for (var i = 0; i <= 8; i++)
              Container(
                height: 1,
                width: 6,
                margin: const EdgeInsets.only(left: 2, right: 2),
                decoration: BoxDecoration(
                  color: WeweyouColors.primaryDarkRed,
                  borderRadius: BorderRadius.circular(2),
                ),
              )
          ],
        ),
        sizedBox(width: 4),
        Text(
          'sign_in.or'.tr(),
          style: poppinsRegular(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            fontColor: WeweyouColors.customPureWhite,
          ),
        ),
        sizedBox(width: 4),
        Wrap(
          children: [
            for (var i = 0; i <= 8; i++)
              Container(
                height: 1,
                width: 6,
                margin: const EdgeInsets.only(left: 2, right: 2),
                decoration: BoxDecoration(
                  color: WeweyouColors.primaryDarkRed,
                  borderRadius: BorderRadius.circular(2),
                ),
              )
          ],
        ),
      ],
    );
  }
}

class BottomText extends StatelessWidget {
  const BottomText(
      {Key? key,
      required this.text1,
      required this.text2,
      required this.onPressed})
      : super(key: key);

  final String text1;
  final String text2;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: WeweyouColors.blackBackground,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
        child: GestureDetector(
          onTap: onPressed,
          child: RichText(
            textAlign: TextAlign.center,
            maxLines: 2,
            text: TextSpan(
              text: "$text1 ",
              style: poppinsRegular(
                fontColor: WeweyouColors.customPureWhite,
                fontWeight: FontWeight.w400,
                fontSize: 17,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: text2,
                  style: poppinsBold(
                    fontWeight: FontWeight.w700,
                    fontColor: WeweyouColors.secondaryOrange,
                    fontSize: 17,
                  ).copyWith(decoration: TextDecoration.underline),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
