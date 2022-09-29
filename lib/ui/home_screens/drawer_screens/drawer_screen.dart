import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weweyou/ui/home_screens/create_event/create_event.dart';
import 'package:weweyou/ui/home_screens/drawer_screens/accounts/profile_detail_screen.dart';
import 'package:weweyou/ui/home_screens/drawer_screens/favorites/favorites_list_screend.dart';
import 'package:weweyou/ui/home_screens/drawer_screens/groups/groups_list_screen.dart';
import 'package:weweyou/ui/home_screens/drawer_screens/itineraries/itineraries_list_screen.dart';
import 'package:weweyou/ui/home_screens/drawer_screens/location_screens/change_location_screen.dart';
import 'package:weweyou/ui/home_screens/drawer_screens/my_events/my_event_list_screen.dart';
import 'package:weweyou/ui/home_screens/home_screen.dart';
import 'package:weweyou/ui/onboarding_screens/registration_screens/signIn_screen.dart';

import '../../../main.dart';
import '../../utils/common_text_style.dart';
import '../../utils/constant.dart';
import '../../utils/custom_alert_dialog.dart';
import '../../utils/custom_app_bar.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final _screens = [
    const HomeScreen(email: ''),
    const ProfileDetailScreen(),
    CreateEventScreen(),
    const EventListScreen(),
    const ItinerariesListScreen(),
    const GroupListScreen(),
    const FavoriteListScreen(),
    const ChangeLocationScreen(),
  ];

  @override
  void initState() {
    check();
    super.initState();
  }

  check() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var checkSign = prefs.getBool('isLogin');
    debugPrint("Check Boolean $checkSign");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        return showAlertDialog(
          context: context,
          headline: 'Are you sure you want to exit?',
          onPressedYes: () => exit(0),
        );
      },
      child: Scaffold(
        backgroundColor: const Color(0xff1F2628),
        key: scaffoldKey,
        drawer: commonDrawer(context),
        appBar: PreferredSize(
          preferredSize: Size(size.width, 70),
          child: const CustomAppBar(),
        ),
        body: ValueListenableBuilder<int>(
          valueListenable: changeIndex,
          builder: (_, int x, __) {
            return _screens[x];
          },
        ),
      ),
    );
  }

  _showAlertDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      barrierColor: Colors.black26,
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          'Alert',
          style: poppinsBold(
            fontColor: WeweyouColors.blackPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to exit from app?',
          style: poppinsRegular(
            fontSize: 16,
            fontColor: WeweyouColors.blackPrimary,
          ),
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            // isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Keep',
              style: poppinsMedium(
                fontColor: Colors.blue,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              exit(0);
            },
            child: Text(
              'Exit',
              style: poppinsMedium(
                fontColor: WeweyouColors.secondaryLightRed,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

commonRow({required IconData iconData, required String headingName}) {
  return Row(
    children: [
      Icon(
        iconData,
        size: 22,
        color: WeweyouColors.customPureWhite,
      ),
      sizedBox(),
      Text(
        headingName,
        style: poppinsMedium(),
      )
    ],
  );
}

/*Used for drawer show in any page*/
Widget commonDrawer(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height,
    color: WeweyouColors.lightBlackColor,
    width: MediaQuery.of(context).size.width / 1.2,
    child: Stack(
      children: [
        Container(
          color: WeweyouColors.lightBlackColor,
          padding: const EdgeInsets.only(top: 110),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 45.0, left: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    changeIndex.value = 0;
                    changeIndex.notifyListeners();
                    debugPrint('Home Screen');
                  },
                  child: commonRow(
                    iconData: Icons.home_filled,
                    headingName: 'Home Screen',
                  ),
                ),
                sizedBox(height: 45),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    changeIndex.value = 1;
                    changeIndex.notifyListeners();
                    debugPrint('My Accout Screen');
                  },
                  child: commonRow(
                    iconData: Icons.person_outline_rounded,
                    headingName: 'My Account',
                  ),
                ),
                sizedBox(height: 45),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    changeIndex.value = 2;
                    changeIndex.notifyListeners();
                    debugPrint('Create Screen');
                  },
                  child: commonRow(
                    iconData: Icons.add_circle,
                    headingName: 'Create Events',
                  ),
                ),
                sizedBox(height: 45),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    changeIndex.value = 3;
                    changeIndex.notifyListeners();
                    debugPrint('Events Screen');
                  },
                  child: commonRow(
                    iconData: Icons.event,
                    headingName: 'My Event',
                  ),
                ),
                sizedBox(height: 45),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    changeIndex.value = 4;
                    changeIndex.notifyListeners();
                    debugPrint('Itineraries Screen');
                  },
                  child: commonRow(
                    iconData: Icons.integration_instructions_outlined,
                    headingName: 'Itineraries',
                  ),
                ),
                sizedBox(height: 45),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    changeIndex.value = 5;
                    changeIndex.notifyListeners();
                    debugPrint('groups Screen');
                  },
                  child: commonRow(
                    iconData: Icons.groups_rounded,
                    headingName: 'Groups',
                  ),
                ),
                sizedBox(height: 45),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    changeIndex.value = 6;
                    changeIndex.notifyListeners();
                  },
                  child: commonRow(
                    iconData: Icons.favorite_border_rounded,
                    headingName: 'Favourites',
                  ),
                ),
                sizedBox(height: 45),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    changeIndex.value = 7;
                    changeIndex.notifyListeners();
                  },
                  child: commonRow(
                    iconData: Icons.location_on_outlined,
                    headingName: 'Change Location',
                  ),
                ),
                sizedBox(height: 45),
                GestureDetector(
                  onTap: () {
                    final navigator = Navigator.of(context);
                    showAlertDialog(
                      context: context,
                      headline: 'Are you sure you want to Logout?',
                      onPressedYes: () async {
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        pref.clear();
                        navigator.pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => const SignInScreen(),
                          ),
                          (route) => false,
                        );
                      },
                    );
                  },
                  child: commonRow(
                    iconData: Icons.logout,
                    headingName: 'Logout',
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 140,
          color: WeweyouColors.blackPrimary,
          padding: const EdgeInsets.only(top: 45.0, left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                AppIcons.logoName,
                height: 45,
                width: 120,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
