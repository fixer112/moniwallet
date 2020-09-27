import 'dart:isolate';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moniwallet/pages/app/splashscreen.dart';
import 'package:moniwallet/providers/user.dart';
import 'package:moniwallet/value.dart';
import 'package:provider/provider.dart';

void main() {
  //Firebase.initializeApp();
  /* await FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(kDebugMode); */
  //Crashlytics.instance.enableInDevMode = kDebugMode;

  // Pass all uncaught errors from the framework to Crashlytics.
  /* FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  Isolate.current.addErrorListener(RawReceivePort((pair) async {
    final List<dynamic> errorAndStacktrace = pair;
    await FirebaseCrashlytics.instance.recordError(
      errorAndStacktrace.first,
      errorAndStacktrace.last,
    );
  }).sendPort); */ //Crashlytics.instance.recordFlutterError;
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
      home: FutureBuilder(
          // Initialize FlutterFire
          future: getData(),
          builder: (context, snapshot) {
            return SplashScreen();
          }),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
      ],
      debugShowCheckedModeBanner: false,
    );
  }

  Future<void> getData() async {
    await Firebase.initializeApp();
    if (kReleaseMode) {
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(kDebugMode);
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      Isolate.current.addErrorListener(RawReceivePort((pair) async {
        final List<dynamic> errorAndStacktrace = pair;
        await FirebaseCrashlytics.instance.recordError(
          errorAndStacktrace.first,
          errorAndStacktrace.last,
        );
      }).sendPort);
    }
  }
}
