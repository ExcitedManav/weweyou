import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:weweyou/ui/utils/constant.dart';

class CommonDropDown extends StatefulWidget {
  CommonDropDown({
    Key? key,
    required this.hintText,
    this.items,
    required this.selectedValue,
    this.onChanged,
    this.textColor,
    this.iconData,
    this.iconSize,
    this.iconEnabledColor,
    this.iconDisabledColor,
    this.buttonHeight,
    this.buttonWidth,
    this.itemHeight,
    this.dropdownMaxHeight,
    this.dropdownWidth,
    this.itemPadding,
  }) : super(key: key);

  final String hintText;
  final List<DropdownMenuItem<dynamic>>? items;
  final String selectedValue;
  Function(dynamic)? onChanged;
  final Color? textColor;
  final IconData? iconData;
  final double? iconSize;
  final Color? iconEnabledColor;
  final Color? iconDisabledColor;
  final double? buttonHeight;
  final double? buttonWidth;
  final double? itemHeight;
  final double? dropdownMaxHeight;
  final double? dropdownWidth;
  final EdgeInsets? itemPadding;

  @override
  State<CommonDropDown> createState() => _CommonDropDownState();
}

class _CommonDropDownState extends State<CommonDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        hint: Text(
          widget.hintText,
          style: TextStyle(
            color: widget.textColor ?? WeweyouColors.customPureWhite,
            fontSize: 16,
          ),
        ),
        items: widget.items,
        value: widget.selectedValue,
        onChanged: widget.onChanged,
        icon: Icon(
          widget.iconData ?? Icons.keyboard_arrow_down_rounded,
        ),
        iconSize: widget.iconSize ?? 24,
        iconEnabledColor: widget.iconEnabledColor ?? Colors.white,
        iconDisabledColor: widget.iconEnabledColor ?? Colors.grey,
        buttonHeight: widget.buttonHeight ?? 55,
        buttonWidth: widget.buttonWidth ?? MediaQuery.of(context).size.width,
        buttonPadding: const EdgeInsets.only(left: 14, right: 14),
        buttonDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black,
        ),
        buttonElevation: 2,
        itemHeight: widget.itemHeight ?? 40,
        itemPadding:
            widget.itemPadding ?? const EdgeInsets.only(left: 14, right: 14),
        dropdownMaxHeight: widget.dropdownMaxHeight ?? 300,
        dropdownWidth:
            widget.dropdownWidth ?? MediaQuery.of(context).size.width * 0.9,
        dropdownPadding: null,
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black,
        ),
        dropdownElevation: 8,
        scrollbarRadius: const Radius.circular(40),
        // scrollbarThickness: 6,
        scrollbarAlwaysShow: true,
        offset: const Offset(-0, 0),
      ),
    );
  }
}
