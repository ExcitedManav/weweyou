import 'package:flutter/material.dart';
import 'package:weweyou/ui/utils/common_text_style.dart';
import 'package:weweyou/ui/utils/constant.dart';

class CreateTextTitles extends StatelessWidget {
  const CreateTextTitles({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: poppinsRegular(
        fontSize: 18,
        fontColor: WeweyouColors.greyPrimary,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
