import 'package:flutter/material.dart';
import 'package:weweyou/ui/utils/constant.dart';

Widget headingText(
    {required String heading,
    FontWeight? fontWeight,
    double? fontSize,
    Color? fontColor}) {
  return Text(
    heading,
    style: poppinsSemiBold(
      fontWeight: fontWeight ?? FontWeight.w600,
      fontSize: fontSize ?? 24,
      fontColor: fontColor ?? WeweyouColors.customPureWhite,
    ),
  );
}

Widget headingText2(
    {required String heading2, double? fontSize, FontWeight? fontWeight}) {
  return Text(
    heading2,
    style: poppinsRegular(
        fontWeight: fontWeight ?? FontWeight.w400, fontSize: fontSize ?? 18),
  );
}

commonText({required String text, Color? fontColor, double? fontSize, FontWeight? fontWeight}) {
  return Text(
    text,
    overflow: TextOverflow.ellipsis,
    textAlign: TextAlign.start,
    maxLines: 3,
    style: poppinsRegular(
      fontSize: fontSize ?? 12,
      fontColor: fontColor ?? WeweyouColors.customPureWhite,
      fontWeight: fontWeight?? FontWeight.w400
    ),
  );
}

TextStyle poppinsBold(
    {double? fontSize, FontWeight? fontWeight, Color? fontColor}) {
  return TextStyle(
    fontSize: fontSize ?? 22,
    fontWeight: fontWeight ?? FontWeight.w700,
    fontFamily: 'Poppins-Bold',
    color: fontColor ?? WeweyouColors.customPureWhite,
  );
}

TextStyle poppinsSemiBold(
    {double? fontSize, FontWeight? fontWeight, Color? fontColor}) {
  return TextStyle(
    fontSize: fontSize ?? 22,
    fontWeight: fontWeight ?? FontWeight.w600,
    fontFamily: 'Poppins-SemiBold',
    color: fontColor ?? WeweyouColors.customPureWhite,
  );
}

TextStyle poppinsRegular(
    {double? fontSize, FontWeight? fontWeight, Color? fontColor}) {
  return TextStyle(
    fontSize: fontSize ?? 18,
    fontWeight: fontWeight ?? FontWeight.w400,
    fontFamily: 'Poppins-Regular',
    color: fontColor ?? WeweyouColors.customPureWhite,
  );
}

TextStyle poppinsMedium(
    {double? fontSize, FontWeight? fontWeight, Color? fontColor}) {
  return TextStyle(
    fontSize: fontSize ?? 18,
    fontWeight: fontWeight ?? FontWeight.w500,
    fontFamily: 'Poppins-Medium',
    color: fontColor ?? WeweyouColors.customPureWhite,
  );
}
