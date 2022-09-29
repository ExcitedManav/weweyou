import 'package:flutter/material.dart';
import 'package:weweyou/ui/home_screens/create_event/create_event.dart';
import 'package:weweyou/ui/home_screens/home_screen.dart';
import 'package:weweyou/ui/onboarding_screens/preview_screens/preview_screen.dart';
import 'package:weweyou/ui/onboarding_screens/registration_screens/select_category_screen.dart';
import 'package:weweyou/ui/onboarding_screens/registration_screens/signIn_screen.dart';
import 'package:weweyou/ui/onboarding_screens/registration_screens/signUp_screen.dart';
import 'package:weweyou/ui/onboarding_screens/registration_screens/welcome_category_screen.dart';

class Routes {
  Map<String, WidgetBuilder> createRoutes() => {
        PreviewScreen.route: (_) => const PreviewScreen(),
        WelcomeCategoryScreen.route: (_) => const WelcomeCategoryScreen(),
        SignInScreen.route: (_) => const SignInScreen(),
        SignUpScreen.route: (_) => const SignUpScreen(),
        SelectCategoryScreen.route: (_) => SelectCategoryScreen(email: ''),
        HomeScreen.route: (_) => HomeScreen(email: ''),
        CreateEventScreen.route: (_) => CreateEventScreen(),


        // ConfirmationMailScreen.route: (_) =>  const ConfirmationMailScreen(email: '',)
      };
}
