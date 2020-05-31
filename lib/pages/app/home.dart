import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moniwallet/global.dart';
import 'package:moniwallet/providers/user.dart';
import 'package:moniwallet/value.dart';
import 'package:moniwallet/widgets/drawer.dart';
import 'package:moniwallet/widgets/widgets.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //var credentials;
  @override
  void initState() {
    var user = Provider.of<UserModel>(context, listen: false);

    if (user.getUser.settings['general_alert'] != "" && generalAlert) {
      Timer.run(
          () => Widgets.alert(user.getUser.settings['general_alert'], context));
    }
    generalAlert = false;

    Timer.run(() => refreshLogin(context));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Widgets.coloredPage(
          context,
          Scaffold(
            backgroundColor: Colors.transparent,
            drawer: DrawerWidget(),
            appBar: Widgets.appbar('MoniWallet',
                backgroundColor: Colors.transparent),
            body: Consumer<UserModel>(builder: (context, user, child) {
              return RefreshIndicator(
                onRefresh: () => refreshLogin(context),
                child: Stack(children: [
                  body(user),
                  Widgets.loader(user),
                ]),
              );
            }),
          ),
        ));
  }

  body(UserModel user) {
    return ListView(
      padding: EdgeInsets.all(20),
      children: <Widget>[
        Container(
          height: 110,
          child: customContainer(currencyFormat(user.getUser.balance),
              'My Wallet', FontAwesomeIcons.wallet,
              color: secondaryColor),
        ),
        SizedBox(height: 15),
        Container(
          height: 110,
          child: customContainer(currencyFormat(user.getUser.referralBalance),
              'Refferal Wallet', FontAwesomeIcons.user),
        ),
      ],
    );
  }

  Widget customContainer(String text, String subText, var icon,
      {Color color = primaryColor}) {
    return Container(
      child: Card(
        elevation: 10,
        color: whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      subText,
                      style: TextStyle(
                          fontSize: 16, color: color.withOpacity(0.7)),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      text,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: color),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Icon(
                icon,
                size: 40,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
