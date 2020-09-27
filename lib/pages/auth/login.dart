import 'dart:async';
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

class Login extends StatefulWidget {
  final String info;

  Login({this.info});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLogin = true;
  var username = TextEditingController();
  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var email = TextEditingController();
  var number = TextEditingController();
  String gender;
  var address = TextEditingController();
  var password = TextEditingController();
  var confirmPassword = TextEditingController();
  var reseller;
  //var savedUser;

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  void initState() {
    var user = Provider.of<UserModel>(context, listen: false);
    if (widget.info != null)
      Timer.run(() => Widgets.alert(widget.info, context));
    user.setLoading(true);
    getJson().then((u) {
      if (u != null) {
        //u['latest_transactions'] =
        user.setUser(User.fromMap(json.decode(u)));
        //refreshLogin(context, refresh: false);

        if (user.getUser != null) Get.to(Home());
        user.setLoading(false);

        //setState(() {});
        //print(json.decode(u)['id']);
      }
      user.setLoading(false);
      //print(user.getUser);
    });

    /* if (user.getUser != null) {
      Get.to(Home());
    } */

    getRemoteConfig(context).then((config) {
      checkUpdate(context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
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
                  return Widgets.body(
                    user,
                    Center(child: listLogin(user)),
                  );
                }),
              ),
            ),
          ),
        ));
  }

  Widget listLogin(UserModel user) {
    return ListView(
      shrinkWrap: true,
      //crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        //Expanded(child: Container()),
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
        if (!isLogin)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Widgets.text('First Name'),
              Widgets.input(firstName, context,
                  icondata: FontAwesomeIcons.userAlt),
              Widgets.text('Last Name'),
              Widgets.input(lastName, context,
                  icondata: FontAwesomeIcons.userAlt),
              Widgets.text('Email'),
              Widgets.input(email, context,
                  icondata: FontAwesomeIcons.mailBulk),
              Widgets.text('Mobile Number'),
              Widgets.input(number, context,
                  icondata: FontAwesomeIcons.phone, prefix: '+234'),
              Widgets.text('Address'),
              Widgets.input(address, context,
                  icondata: FontAwesomeIcons.userAlt),
              Widgets.text('Gender'),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                width: MediaQuery.of(context).size.width,
                height: 54.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(color: Colors.grey)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      //isExpanded: true,
                      items: ['male', 'female'].map((g) {
                        return Widgets.dropItem(g.toUpperCase(), g);
                      }).toList(),
                      hint: Widgets.text('Select Type'),
                      value: gender,

                      onChanged: (value) {
                        //print(plans);
                        closeKeybord(context);
                        setState(() {
                          gender = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        Widgets.text('Password'),
        Widgets.input(password, context,
            type: TextInputType.visiblePassword,
            icondata: FontAwesomeIcons.key),
        if (!isLogin)
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Widgets.text('Confirm Password'),
                Widgets.input(confirmPassword, context,
                    type: TextInputType.visiblePassword,
                    icondata: FontAwesomeIcons.key),
              ]),
        SizedBox(
          height: 10,
        ),
        Widgets.button(isLogin ? 'LOGIN' : "REGISTER", context, () async {
          //return appReview();
          //return launchUssd('*556#');
          //return makeMyRequest('*556#');

          if (!user.isloading) {
            if ([username.text, password.text].contains('')) {
              return Widgets.snackbar(msg: 'All inputs are required');
            }

            if (isLogin) {
              user.login(username.text, password.text, context);
            } else {
              if ([
                firstName.text,
                lastName.text,
                email.text,
                number.text,
                address.text,
                confirmPassword.text,
                gender,
              ].contains('')) {
                return Widgets.snackbar(msg: 'All inputs are required');
              }
              var data = {
                'login': username.text,
                'first_name': firstName.text,
                'last_name': lastName.text,
                'email': email.text,
                'number': number.text,
                'password': password.text,
                'password_confirmation': confirmPassword.text,
                'address': address.text,
                'gender': gender,
                'reseller': '0',
              };

              user.register(data, context);
            }
          }
        }),
        SizedBox(
          height: 10,
        ),
        Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                    child: Widgets.text(isLogin ? 'Register' : "Login",
                        color: primaryColor),
                    onTap: () {
                      isLogin = !isLogin;
                      setState(() {}); //launchURL('$url/register'),
                    }),
                Widgets.text(' | '),
                InkWell(
                  child: Widgets.text('Forget Password?', color: primaryColor),
                  onTap: () => launchURL('$url/password/reset'),
                )
              ],
            ),
          ],
        ),
        SizedBox(
          height: 50,
        ),

        //Expanded(child: Container()),
      ],
    );
  }
}
