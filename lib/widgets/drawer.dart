import 'dart:async';

// ignore: import_of_legacy_library_into_null_safe
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:get/get.dart';
import '../global.dart';
import '../pages/app/fund.dart';
import '../pages/app/home.dart';
import '../pages/bill/airtime.dart';
import '../pages/bill/cable.dart';
import '../pages/bill/data.dart';
import '../pages/bill/electricity.dart';
import '../providers/user.dart';
import '../value.dart';
import 'widgets.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatefulWidget {
  DrawerWidget({Key? key}) : super(key: key);

  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  void initState() {
    //Timer.run(() => closeKeybord(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //var user = Provider.of<UserModel>(context, listen: false);
    //return Container();
    var user = context.watch<UserModel>();
    var u = user.getUser;
    //return //Consumer<UserModel>(builder: (context, user, child) {
    //print(u.packageName);
    return WillPopScope(
        onWillPop: () async => false,
        child: Container(
          //width: 250,
          child: Drawer(
            //color: whiteColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Widgets.text(
                      "${u?.fullname} (${ucFirst(u?.packageName ?? '')} Account)",
                      color: whiteColor),
                  accountEmail: Widgets.text(u?.email, color: whiteColor),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider('$url/${u?.profilePic}'),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    gradient: LinearGradient(
                      colors: [primaryColor, secondaryColor],
                      //stops: [0.5, 0.5],
                    ),
                  ),
                ),
                Widgets.listTile('Home', FontAwesomeIcons.home, action: () {
                  Future.delayed(Duration.zero, () => Get.to(Home()));
                }),
                /* Widgets.listTile(
                'Transaction History',
                FontAwesomeIcons.history,
              ), */
                Widgets.listTile(
                  'Fund Wallet',
                  FontAwesomeIcons.creditCard,
                  action: () {
                    Future.delayed(Duration.zero, () => Get.to(Fund()));
                  },
                ),
                Widgets.listTile(
                  'Airtime',
                  FontAwesomeIcons.phoneAlt,
                  action: () {
                    Future.delayed(Duration.zero, () => Get.to(Airtime()));
                  },
                  //action: () => Get.to(Airtime()),
                ),
                Widgets.listTile(
                  'Data',
                  FontAwesomeIcons.globe,
                  action: () {
                    Future.delayed(Duration.zero, () => Get.to(Data()));
                  },
                  //action: () => Get.to(Data()),
                ),
                Widgets.listTile(
                  'Cable',
                  FontAwesomeIcons.tv,
                  action: () {
                    Future.delayed(Duration.zero, () => Get.to(Cable()));
                  },
                  //action: () => Get.to(Cable()),
                ),
                Widgets.listTile(
                  'Electricity',
                  FontAwesomeIcons.lightbulb,
                  action: () {
                    Future.delayed(Duration.zero, () => Get.to(Electricity()));
                  },
                  //action: () => Get.to(Electricity()),
                ),
                Expanded(child: Container()),
                Container(
                  color: primaryColor,
                  child: Widgets.listTile(
                    'Logout',
                    FontAwesomeIcons.powerOff,
                    action: () {
                      Future.delayed(Duration.zero, () => logout(context));
                    },
                    /* action: () async {
                      await logout(context);
                    }, */
                    color: Colors.red,
                  ),
                )
              ],
            ),
          ),
        ));
    //});
  }
}
