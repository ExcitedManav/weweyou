import 'package:flutter/material.dart';
import 'package:weweyou/ui/utils/common_text_style.dart';
import 'package:weweyou/ui/utils/constant.dart';

class CustomFormField extends StatefulWidget {
  const CustomFormField({
    Key? key,
    this.textStyle,
    this.validator,
    required this.controller,
    this.contentPadding,
    required this.hintText,
    this.fillColor,
    this.focusNode,
    this.obscureText,
    this.suffixIcon,
    this.textInputType,
    this.prefixIcon,
    this.maxLine,
    this.onPressed,
    this.readOnly,
  }) : super(key: key);

  final TextStyle? textStyle;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final EdgeInsets? contentPadding;
  final String hintText;
  final Color? fillColor;
  final FocusNode? focusNode;
  final bool? obscureText;
  final Widget? suffixIcon;
  final TextInputType? textInputType;
  final Widget? prefixIcon;
  final int? maxLine;
  final VoidCallback? onPressed;
  final bool? readOnly;

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: widget.textStyle ??
          poppinsRegular(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontColor: WeweyouColors.customPureWhite,
          ),
      onTap: widget.onPressed,
      textInputAction: TextInputAction.next,
      validator: widget.validator,
      maxLines: widget.maxLine ?? 1,
      controller: widget.controller,
      focusNode: widget.focusNode,
      keyboardType: widget.textInputType ?? TextInputType.text,
      obscureText: widget.obscureText ?? false,
      readOnly: widget.readOnly ?? false,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
        prefixIcon: widget.prefixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: const BorderSide(width: 0.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 0.5,
          ),
        ),
        hintText: widget.hintText,
        hintStyle: poppinsRegular(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontColor: WeweyouColors.greyPrimary,
        ),
        filled: true,
        fillColor: widget.fillColor ?? const Color(0xff0F0F0F),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: widget.suffixIcon,
      ),
    );
  }
}
