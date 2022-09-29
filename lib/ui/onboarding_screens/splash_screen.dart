import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weweyou/ui/home_screens/drawer_screens/drawer_screen.dart';
import 'package:weweyou/ui/onboarding_screens/registration_screens/signIn_screen.dart';
import 'package:weweyou/ui/utils/constant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )
      ..forward()
      ..repeat(reverse: true);
    _loadWidget();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  final splashDelay = 5;

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    final navigator = Navigator.of(context);
    SharedPreferences prefes = await SharedPreferences.getInstance();
    var checkLogin = prefes.getBool('isLogin') ?? false;
    var newUser = prefes.getBool('newUser') ?? true;

    debugPrint("Login Bool $checkLogin");
    debugPrint("NewUser bool $newUser");
    if (newUser == true) {
      navigator.pushReplacementNamed("/previewScreen");
    } else if (checkLogin == true) {
      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (_) => const DrawerScreen(),
        ),
      );
    } else {
      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (_) => const SignInScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WeweyouColors.lightBlackColor,
      body: Stack(
        children: [
          Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: AnimatedBuilder(
                  animation: animationController!,
                  builder: (context, child) {
                    return Container(
                      decoration: ShapeDecoration(
                        color: Colors.white.withOpacity(0.5),
                        shape: const CircleBorder(),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.all(20.0 * animationController!.value),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(50),
                    decoration: const ShapeDecoration(
                      color: Colors.white,
                      shape: CircleBorder(),
                    ),
                    child: Image.asset(
                      "assets/images_icons/onboarding/icon.png",
                      width: 250,
                      height: 250,
                    ),
                  ),
                ),
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Image.asset(
                "assets/images_icons/onboarding/app_name.png",
                width: 300,
                height: 30,
              ),
            ),
          )
        ],
      ),
    );
  }
}
