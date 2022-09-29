import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:provider/provider.dart';
import 'package:weweyou/route_helper.dart';
import 'package:weweyou/ui/onboarding_screens/splash_screen.dart';


ValueNotifier<int> changeIndex = ValueNotifier<int>(0);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  if (kIsWeb) {
    // initialiaze the facebook javascript SDK
     await FacebookAuth.instance.webInitialize(
      appId: "5155674644561637",
      cookie: true,
      xfbml: true,
      version: "v13.0",
    );}
  // final GoogleMapsFlutterPlatform mapsImplementation =
  //     GoogleMapsFlutterPlatform.instance;
  // if (mapsImplementation is GoogleMapsFlutterAndroid) {
  //   mapsImplementation.useAndroidViewSurface = true;
  // }
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: Provider(
        create: (_) => Routes(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'weweyou',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(primarySwatch: Colors.red, primaryColor: Colors.red),
      home: const SplashScreen(),
      routes: context.read<Routes>().createRoutes(),
      debugShowCheckedModeBanner: false,
    );
  }
}
