import 'package:flutter/material.dart';

import '../../../utils/common_text_style.dart';
import '../../../utils/constant.dart';

line({Color? backgroundColor, double? height, double? width}) {
  return Expanded(
    child: Container(
      height: height ?? 2,
      width: width ?? 40,
      color: backgroundColor ?? WeweyouColors.blackPrimary,
    ),
  );
}

subHeadingText({required String title, double? fontSize}) {
  return Text(
    title,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    softWrap: true,
    style: poppinsBold(fontWeight: FontWeight.w700, fontSize: fontSize ?? 20),
  );
}

customCheckBox(
    {required String title,
    required bool selectedValBool,
    required void Function(bool?)? onChanged,
    int? selectedInt}) {
  return Row(
    children: [
      Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: WeweyouColors.secondaryOrange, width: 1),
        ),
        child: Checkbox(
          value: selectedValBool,
          shape: const RoundedRectangleBorder(
            // borderRadius: BorderRadius.circular(5),
            side: BorderSide(
              color: WeweyouColors.secondaryOrange,
              width: 0.5,
            ),
          ),
          fillColor: MaterialStateColor.resolveWith(
            (states) => WeweyouColors.blackPrimary,
          ),
          checkColor: WeweyouColors.secondaryOrange,
          onChanged: onChanged,
        ),
      ),
      sizedBox(width: 10),
      Text(
        title,
        style: poppinsRegular(fontSize: 12),
      ),
    ],
  );
}

processStep({required String text, Color? backgroundColor}) {
  return CircleAvatar(
    backgroundColor: backgroundColor ?? WeweyouColors.blackPrimary,
    radius: 20,
    child: Text(
      text,
      style: poppinsRegular(fontColor: WeweyouColors.customPureWhite, fontSize: 14),
    ),
  );
}
