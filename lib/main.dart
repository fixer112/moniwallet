import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moniwallet/pages/app/splashscreen.dart';
import 'package:moniwallet/providers/user.dart';
import 'package:moniwallet/value.dart';
import 'package:provider/provider.dart';

void main() {
  //Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserModel>(create: (context) => UserModel()),
        //ChangeNotifierProvider<MainModel>(create: (context) => MainModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MoniWallet',
      theme: ThemeData(
        //iconTheme: IconThemeData(color: whiteColor),
        textTheme: GoogleFonts.mavenProTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: primarySwatch,
      ),
      home: SplashScreen(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
