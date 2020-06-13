import 'package:app_review/app_review.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moniwallet/providers/user.dart';
import 'package:moniwallet/value.dart';
import 'package:moniwallet/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:moniwallet/global.dart';
import 'package:version/version.dart';

class UpgradeAlert extends StatefulWidget {
  @override
  _UpgradeAlertState createState() => _UpgradeAlertState();
}

class _UpgradeAlertState extends State<UpgradeAlert> {
  var latestVersion;
  var currentVersion;
  @override
  void initState() {
    var user = Provider.of<UserModel>(context, listen: false);
    initPackageInfo().then((info) {
      latestVersion = Version.parse(user.getConfig.getString('latest_version'));
      currentVersion = Version.parse(info.version);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: whiteColor,
          //drawer: DrawerWidget(),
          //appBar: Widgets.appbar('UpgradeAlert Wallet', context),
          body: Stack(
            children: [
              Center(
                child: Opacity(
                    opacity: 0.1,
                    child: Container(
                      child: Image.asset("assets/img/logo.png"),
                    )),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Widgets.text(
                        "You are currently using version $currentVersion, which is no longer supported, please update to version $latestVersion",
                        fontSize: 15,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Widgets.button("UPDATE NOW", context,
                          () async => await AppReview.storeListing),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
