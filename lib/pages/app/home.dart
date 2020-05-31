import 'dart:async';

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
  int currentIndex = 0;

  @override
  void initState() {
    var user = Provider.of<UserModel>(context, listen: false);

    if (user.getUser.settings['general_alert'] != "" && generalAlert) {
      Timer.run(
          () => Widgets.alert(user.getUser.settings['general_alert'], context));
    }
    generalAlert = false;

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
    Widget latestTran = ListView(
        shrinkWrap: true,
        children: user.getUser.latestTransactions
            .map<Widget>(
              (transaction) => Widgets.paymentCard({
                'desc': transaction.desc,
                'amount': transaction.amount,
                'date': transaction.createdAt.toLocal().toString(),
                'type': transaction.type,
              }, () {}),
            )
            .toList());
    Widget latestCom = ListView(
        shrinkWrap: true,
        children: user.getUser.latestComissions
            .map<Widget>(
              (transaction) => Widgets.paymentCard({
                'desc': transaction.desc,
                'amount': transaction.amount,
                'date': transaction.createdAt.toString(),
                'type': 'credit',
              }, () {}),
            )
            .toList());
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        //padding: EdgeInsets.all(20),
        children: <Widget>[
          Container(
            //height: 110,
            child: customContainer(currencyFormat(user.getUser.balance),
                'My Wallet', FontAwesomeIcons.wallet,
                color: secondaryColor),
          ),
          SizedBox(height: 15),
          Container(
            //height: 110,
            child: customContainer(currencyFormat(user.getUser.referralBalance),
                'Refferal Wallet', FontAwesomeIcons.user),
          ),
          SizedBox(height: 15),
          Widgets.tabbedWidget([
            {
              'title': 'Wallet History',
              'icon': FontAwesomeIcons.wallet,
              'widget': Container(
                height: 300,
                child: checkNull(user.getUser.latestTransactions, latestTran,
                    msg: 'No transaction history available'),
              ),
            },
            {
              'title': 'Refferal History',
              'icon': FontAwesomeIcons.user,
              'widget': Container(
                height: 300,
                child: checkNull(user.getUser.latestComissions, latestCom,
                    msg: "No referral history available"),
              ),
            }
          ], currentIndex: currentIndex, controller: (index) {
            setState(() {
              currentIndex = index;
            });
          }),
        ],
      ),
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
