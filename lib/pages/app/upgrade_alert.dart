// ignore: import_of_legacy_library_into_null_safe
import 'package:app_review/app_review.dart';
import 'package:flutter/material.dart';
import '../../providers/user.dart';
import '../../value.dart';
import '../../widgets/widgets.dart';
import 'package:provider/provider.dart';
import '../../global.dart';
// ignore: import_of_legacy_library_into_null_safe
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
      latestVersion =
          Version.parse(user.getConfig?.getString('latest_version'));
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
                      Container(
                          height: 54,
                          margin: EdgeInsets.symmetric(vertical: 15),
                          child: Widgets.button(
                              'UPDATE NOW',
                              context,
                              () async => await AppReview
                                  .storeListing) /* FlatButton(
                          //style: TextButton.styleFrom(),
                          disabledColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          color: primaryColor,
                          child: Text(
                            'UPDATE NOW',
                            style: TextStyle(color: whiteColor),
                          ),
                          onPressed: () async => await AppReview.storeListing,
                        ), */
                          ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
