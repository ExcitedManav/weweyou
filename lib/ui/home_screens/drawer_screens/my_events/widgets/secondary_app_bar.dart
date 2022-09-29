import 'package:flutter/material.dart';
import 'package:weweyou/ui/utils/common_text_style.dart';

import '../../../../utils/constant.dart';

class SecondaryAppBar extends StatefulWidget {
  const SecondaryAppBar({Key? key, required this.appBarName}) : super(key: key);

  final String appBarName;

  @override
  State<SecondaryAppBar> createState() => _SecondaryAppBarState();
}

class _SecondaryAppBarState extends State<SecondaryAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70,
      backgroundColor: WeweyouColors.primaryDarkRed,
      elevation: 0,
      centerTitle: true,
      title: Text(
        widget.appBarName,
        style: poppinsSemiBold(
          fontSize: 24,
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: WeweyouColors.customPureWhite,
          size: 24,
        ),
      ),
    );
  }
}
