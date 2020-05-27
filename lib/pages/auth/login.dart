import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:moniwallet/global.dart';
import 'package:moniwallet/models/user.dart';
import 'package:moniwallet/pages/app/home.dart';
import 'package:moniwallet/providers/user.dart';
import 'package:moniwallet/value.dart';
import 'package:moniwallet/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var username = TextEditingController();
  var password = TextEditingController();
  //var savedUser;

  @override
  void initState() {
    var user = Provider.of<UserModel>(context, listen: false);
    getJson().then((u) {
      if (u != null) {
        //u['latest_transactions'] =
        user.setUser(User.fromMap(json.decode(u)));
        Get.to(Home());
        //print(json.decode(u)['id']);
      }
      print(user.getUser);
    });

    /* if (user.getUser != null) {
      Get.to(Home());
    } */

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: whiteColor,
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          physics: BouncingScrollPhysics(),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
            ),
            child: Consumer<UserModel>(builder: (context, user, child) {
              return Stack(children: [
                listLogin(user),
                Widgets.loader(user),
              ]);
            }),
          ),
        ),
      ),
    );
  }

  listLogin(UserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(child: Container()),
        SizedBox(
          height: 25,
        ),
        Container(
          alignment: Alignment.center,
          child: Container(
            //color: primaryColor,
            //width: 150,
            child: Hero(
              child: Image.asset(
                "assets/img/logo2.png",
              ),
              tag: 'logo2',
            ),
          ), /* Text('Moniwallet Account',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), */
        ),
        /* Center(
          child: Widgets.text('Welcome', fontSize: 25.0),
        ), */
        SizedBox(
          height: 30,
        ),
        Widgets.text('Username'),
        Widgets.input(username, context, icondata: FontAwesomeIcons.userAlt),
        Widgets.text('Password'),
        Widgets.input(password, context,
            type: TextInputType.visiblePassword,
            icondata: FontAwesomeIcons.key),
        SizedBox(
          height: 10,
        ),
        Widgets.button('LOGIN', context, () {
          /* Widgets.waiting(context,
                      task: () async {
                        await Future.delayed(Duration(seconds: 3), () async {
                          return true;
                        });
                      },
                      whenComplete: () async => Get.to(Home())); */
          if (!user.isloading) {
            if ([username.text, password.text].contains('')) {
              return Widgets.snackbar(msg: 'All inputs are required');
            }
            user.login(username.text, password.text, context);
            //Get.to(Home());
          }
          //user.setLoading(true);
          closeKeybord(context);
        }),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
              child: Widgets.text('Register', color: primaryColor),
              onTap: () => launchURL('$url/register'),
            ),
            Widgets.text(' | '),
            InkWell(
              child: Widgets.text('Forget Password?', color: primaryColor),
              onTap: () => launchURL('$url/password/reset'),
            )
          ],
        ),
        Expanded(child: Container()),
      ],
    );
  }
}
