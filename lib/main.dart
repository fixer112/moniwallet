// @dart=2.9

import 'dart:async';

// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_analytics/firebase_analytics.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_analytics/observer.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_core/firebase_core.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:get/get.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:google_fonts/google_fonts.dart';
import 'global.dart';
import 'pages/app/splashscreen.dart';
import 'providers/user.dart';
import 'value.dart';
import 'package:provider/provider.dart';

void main() async {
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
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(bgMsgHdl);

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  //runZonedGuarded(body, onError);
  runZonedGuarded(() {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserModel()),
          //ChangeNotifierProvider.value(value: UserModel()),
          //ChangeNotifierProvider<UserModel>(create: (context) => UserModel()),
          //ChangeNotifierProvider<MainModel>(create: (context) => MainModel()),
        ],
        child: MyApp(),
      ),
    );
  }, (error, stackTrace) {
    print('runZonedGuarded: Caught error in my root zone.');
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
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
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      /* FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      Isolate.current.addErrorListener(RawReceivePort((pair) async {
        final List<dynamic> errorAndStacktrace = pair;
        await FirebaseCrashlytics.instance.recordError(
          errorAndStacktrace.first,
          errorAndStacktrace.last,
        );
      }).sendPort); */
      Function originalOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails errorDetails) async {
        await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
        // Forward to original handler.
        originalOnError(errorDetails);
      };
    }
  }
}
