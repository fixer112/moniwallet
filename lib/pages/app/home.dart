import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moniwallet/global.dart';
import 'package:moniwallet/providers/user.dart';
import 'package:moniwallet/value.dart';
import 'package:moniwallet/widgets/widgets.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    getJson().then((json) => print(json));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Widgets.coloredPage(
      context,
      Scaffold(
        backgroundColor: Colors.transparent,
        drawer: Widgets.drawer(context),
        appBar: Widgets.appbar('MoniWallet'),
        body: Consumer<UserModel>(builder: (context, user, child) {
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
                child: customContainer(
                    currencyFormat(user.getUser.referralBalance),
                    'Refferal Wallet',
                    FontAwesomeIcons.user),
              ),
            ],
          );
        }),
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
