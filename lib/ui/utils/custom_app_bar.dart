import 'package:flutter/material.dart';

import 'package:weweyou/ui/utils/constant.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 70,
      backgroundColor: WeweyouColors.blackPrimary,
      flexibleSpace: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 26,
                width: 28,
                child: Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Image.asset(
                        AppIcons.menuBar,
                      ),
                    );
                  },
                ),
              ),
              appBarContainer(
                imagePath: AppIcons.logoName,
                height: 35,
                width: 120,
              ),
              Row(
                children: [
                  appBarContainer(
                    imagePath: AppIcons.search,
                    onPressed: () {},
                  ),
                  sizedBox(width: 10),
                  appBarContainer(
                    imagePath: AppIcons.notification,
                    onPressed: () async {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  appBarContainer(
      {double? height,
      double? width,
      required String imagePath,
      VoidCallback? onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        height: height ?? 22,
        width: width ?? 22,
        child: Image.asset(
          imagePath,
        ),
      ),
    );
  }
}
