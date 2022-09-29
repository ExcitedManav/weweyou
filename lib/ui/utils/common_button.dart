import 'package:flutter/material.dart';
import 'package:weweyou/ui/utils/common_text_style.dart';
import 'package:weweyou/ui/utils/constant.dart';

class CommonButton extends StatefulWidget {
  const CommonButton(
      {Key? key,
      required this.onPressed,
      this.backgroundColor,
      this.padding,
      this.margin,
      this.height,
      this.width,
      required this.buttonName,
      this.textColor,
      this.fontSize})
      : super(key: key);

  final VoidCallback onPressed;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? height;
  final double? width;
  final String buttonName;
  final Color? textColor;
  final double? fontSize;

  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        height: widget.height ?? 60,
        width: widget.width ?? MediaQuery.of(context).size.height * 0.8,
        margin: widget.margin,
        padding: widget.padding,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? WeweyouColors.primaryDarkRed,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: WeweyouColors.primaryDarkRed,
            width: 2.0
          )
        ),
        child: Text(
          widget.buttonName,
          style: poppinsRegular(
              fontColor: widget.textColor ?? WeweyouColors.customPureWhite,
              fontWeight: FontWeight.w700,
              fontSize: widget.fontSize ?? 18),
        ),
      ),
    );
  }
}
