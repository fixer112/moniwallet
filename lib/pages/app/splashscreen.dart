import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moniwallet/pages/app/home.dart';
import 'package:moniwallet/pages/auth/login.dart';
import 'package:moniwallet/widgets/widgets.dart';
import 'package:package_info/package_info.dart';

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
  @override
  void initState() {
    print(url);
    _initPackageInfo();
    Future.delayed(Duration(seconds: 3), () {
      Get.to(Login());
    });

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
