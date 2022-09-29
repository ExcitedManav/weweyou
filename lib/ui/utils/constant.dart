import 'package:flutter/material.dart';

const imagePath =
    'https://firebasestorage.googleapis.com/v0/b/weweyou-5ca8b.appspot.com/o/icon.png?alt=media&token=32d5f03f-3693-48f3-a4d0-61c0a089aa45';
const mapApiKey = "AIzaSyBhCef5WuAuPKRVoPuWQASD6avTs16x7uE";

class WeweyouColors {
  static const Color lightBlackColor = Color(0xff212121);
  static const Color blackBackground = Color(0xff212121);
  static const Color blackPrimary = Color(0xff000000);
  static const Color primaryDarkRed = Color(0xffAF2525);
  static const Color secondaryLightRed = Color(0xffe42322);
  static const Color lightColorWhite = Color(0xffffe9d2);
  static const Color customPureWhite = Color(0xffffffff);
  static const Color secondaryOrange = Color(0xffDF7604);
  static const Color greyPrimary = Color(0xffBCBCBC);
}

SizedBox sizedBox({double? height, double? width}) {
  return SizedBox(
    height: height ?? 15,
    width: width ?? 15,
  );
}

class AppIcons {
  static const String location = 'assets/images_icons/home_screen/location.png';
  static const String menuBar = 'assets/images_icons/home_screen/menu_bar.png';
  static const String logoName =
      'assets/images_icons/home_screen/app_name_logo.png';
  static const String search = 'assets/images_icons/home_screen/search.png';
  static const String notification =
      'assets/images_icons/home_screen/notification.png';
}
