import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getflutter/components/drawer/gf_drawer.dart';
import 'package:moniwallet/global.dart';
import 'package:moniwallet/pages/app/fund.dart';
import 'package:moniwallet/pages/app/home.dart';
import 'package:moniwallet/pages/auth/login.dart';
import 'package:moniwallet/pages/bill/airtime.dart';
import 'package:moniwallet/pages/bill/cable.dart';
import 'package:moniwallet/pages/bill/data.dart';
import 'package:moniwallet/providers/user.dart';
import 'package:moniwallet/value.dart';
import 'package:moniwallet/widgets/widgets.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatefulWidget {
  DrawerWidget({Key key}) : super(key: key);

  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  void initState() {
    Timer.run(() => closeKeybord(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //var user = Provider.of<UserModel>(context, listen: false);
    return Consumer<UserModel>(builder: (context, user, child) {
      var u = user.getUser;
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
                        "${u.fullname} (${ucFirst(u.packageName)} Account)",
                        color: whiteColor),
                    accountEmail:
                        Widgets.text(user.getUser.email, color: whiteColor),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider('$url/${u.profilePic}'),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      gradient: LinearGradient(
                        colors: [secondaryColor, primaryColor],
                        //stops: [0.5, 0.5],
                      ),
                      /* image: DecorationImage(
                    image: AssetImage('assets/img/background (2).jpg')), */
                    ),
                  ),
                  Widgets.listTile(
                    'Home',
                    FontAwesomeIcons.home,
                    action: () => Get.to(Home()),
                  ),
                  /* Widgets.listTile(
                'Transaction History',
                FontAwesomeIcons.history,
              ), */
                  Widgets.listTile(
                    'Fund Wallet',
                    FontAwesomeIcons.creditCard,
                    action: () => Get.to(Fund()),
                  ),
                  Widgets.listTile('Airtime', FontAwesomeIcons.phoneAlt,
                      action: () => Get.to(Airtime())),
                  Widgets.listTile('Data', FontAwesomeIcons.globe,
                      action: () => Get.to(Data())),
                  Widgets.listTile(
                    'Cable',
                    FontAwesomeIcons.tv,
                    action: () => Get.to(Cable()),
                  ),
                  Expanded(child: Container()),
                  Container(
                    color: secondaryColor,
                    child: Widgets.listTile(
                      'Logout',
                      FontAwesomeIcons.powerOff,
                      action: () async {
                        await logout();
                      },
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ),
          ));
    });
  }
}
