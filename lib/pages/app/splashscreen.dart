import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:get/get.dart';
import '../../global.dart';
import '../auth/login.dart';
import '../../widgets/widgets.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:package_info/package_info.dart';
//import 'package:quick_actions/quick_actions.dart';

import '../../value.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  PackageInfo _packageInfo = new PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );
  //final QuickActions quickActions = QuickActions();
  @override
  void initState() {
    print(url);
    getRemoteConfig(context).then((config) {
      checkUpdateForce(context).then((b) {
        if (!b) {
          Future.delayed(Duration(seconds: 3), () {
            Get.to(Login());
          });
        }
      });
    });
    /* quickActions.initialize((shortcutType) {
      if (shortcutType == 'airtime') {
        Get.to(Airtime());
      }
      if (shortcutType == 'data') {
        Get.to(Data());
      }
      if (shortcutType == 'cable') {
        Get.to(Cable());
      }
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
          type: 'cable', localizedTitle: 'Cable', icon: 'personal_video'),
      const ShortcutItem(
          type: 'data', localizedTitle: 'Data', icon: 'language'),
      const ShortcutItem(
          type: 'airtime', localizedTitle: 'Airtime', icon: 'phone'),
    ]); */
    _initPackageInfo();

    super.initState();
  }

  Future<Null> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: whiteColor,
          body: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Hero(
                    child: Image.asset('assets/img/logo2.png'),
                    tag: 'logo2',
                  ),
                ),
              ),
              Widgets.text("Version ${_packageInfo.version}"),
              /* SizedBox(
            height: 30,
          ), */
            ],
          ),
        ));
  }
}
