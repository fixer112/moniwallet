import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getflutter/components/drawer/gf_drawer.dart';
import 'package:moniwallet/global.dart';
import 'package:moniwallet/pages/app/home.dart';
import 'package:moniwallet/pages/auth/login.dart';
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
  Widget build(BuildContext context) {
    //var user = Provider.of<UserModel>(context, listen: false);
    return Consumer<UserModel>(builder: (context, user, child) {
    var u = user.getUser;
    return Container(
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
                      backgroundImage: NetworkImage('$url/${u.profilePic}'),
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
                  Widgets.listTile(
                    'Transaction History',
                    FontAwesomeIcons.history,
                  ),
                  Widgets.listTile(
                    'Fund Wallet',
                    FontAwesomeIcons.creditCard,
                  ),
                  Widgets.listTile(
                    'Airtime',
                    FontAwesomeIcons.phoneAlt,
                  ),
                  Widgets.listTile(
                    'Data',
                    FontAwesomeIcons.globe,
                  ),
                  Widgets.listTile(
                    'Cable',
                    FontAwesomeIcons.tv,
                  ),
                  Expanded(child: Container()),
                  Container(
                    color: secondaryColor,
                    child: Widgets.listTile(
                      'Logout',
                      FontAwesomeIcons.powerOff,
                      action: () async {
                        await removeJson();
                        Get.to(Login());
                      },
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ),
          );
    });
  }
}
