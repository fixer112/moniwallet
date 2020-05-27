import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getflutter/getflutter.dart';
import 'package:moniwallet/global.dart';
import 'package:moniwallet/pages/app/home.dart';
import 'package:moniwallet/pages/auth/login.dart';
import 'package:moniwallet/providers/user.dart';
import 'package:moniwallet/value.dart';
import 'package:provider/provider.dart';

class Widgets {
  static appbar(title) {
    return AppBar(
        iconTheme: new IconThemeData(color: whiteColor),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: text(
          title,
          color: whiteColor,
        ));
  }

  static text(text,
      {double fontSize = 15,
      fontWeight = FontWeight.bold,
      Color color = Colors.black}) {
    return Text(text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        ));
  }

  static input(TextEditingController controller, BuildContext context,
      {String hintText = '',
      TextInputType type = TextInputType.text,
      bool spaced = true,
      IconData icondata,
      String prefix = ''}) {
    var user = Provider.of<UserModel>(context, listen: false);
    Icon icon = icondata != null
        ? Icon(
            icondata,
            size: 15,
          )
        : null;
    return Container(
      height: 54,
      margin: EdgeInsets.symmetric(vertical: spaced ? 15 : 0),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: icon,
          prefix: Text(prefix),
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
          contentPadding: EdgeInsets.all(17),
        ),
        cursorColor: primaryColor,
        controller: controller,
        keyboardType: type,
        obscureText: type == TextInputType.visiblePassword ? true : false,
        enabled: !user.isloading,
      ),
    );
  }

  static button(String text, BuildContext context, Function action,
      {bool spaced = true,
      Color color = primaryColor,
      Color textColor = whiteColor}) {
    var user = Provider.of<UserModel>(context, listen: false);
    return Container(
      height: 54,
      margin: EdgeInsets.symmetric(vertical: spaced ? 15 : 0),
      child: FlatButton(
        disabledColor: Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: color,
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
        onPressed: !user.isloading ? action : null,
      ),
    );
  }

  static waiting(BuildContext context, {Function task, Function whenComplete}) {
    showDialog(
      context: context,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.black.withOpacity(.1),
          body: SizedBox(
            height: 10,
            child: LinearProgressIndicator(),
          ),
        );
      },
    ).then((value) {
      if (whenComplete != null) {
        whenComplete();
      }
    });

    if (task != null) {
      Future.microtask(() {
        return task();
      }).then((status) {
        if (status != false) {
          Navigator.pop(context);
        }
      });
    }
  }

  static popup(BuildContext context, String text) {
    showDialog(
      context: context,
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(.05),
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
            ),
            height: 120,
            width: 220,
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Text(
                    text,
                    softWrap: true,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: primaryColor),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'CLOSE',
                    style: TextStyle(color: primaryColor),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static coloredPage(BuildContext context, Widget widget) {
    var wd = MediaQuery.of(context).size.width + 50;

    return Stack(
      children: <Widget>[
        Container(
          color: whiteColor,
        ),
        Positioned(
          left: 0,
          right: -50,
          top: 0,
          height: 270,
          child: Container(
            width: wd,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius:
                  BorderRadius.only(bottomRight: Radius.elliptical(wd, 150)),
            ),
          ),
        ),
        widget
      ],
    );
  }

  /* static scaffold({title, body, user}) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        drawer: drawer(user),
        appBar: appbar(title),
        body: body);
  } */

  static drawer(UserModel user) {
    //var user = Provider.of<UserModel>(context, listen: false);
    return Container(
      //width: 250,
      child: GFDrawer(
        color: whiteColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: text(
                  "${user.getUser.fullname} (${ucFirst(user.getUser.packageName)} Account)",
                  color: whiteColor),
              accountEmail: text(user.getUser.email, color: whiteColor),
              currentAccountPicture: CircleAvatar(
                backgroundImage:
                    NetworkImage('$url/${user.getUser.profilePic}'),
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
            listTile(
              'Home',
              FontAwesomeIcons.home,
              action: () => Get.to(Home()),
            ),
            listTile(
              'Transaction History',
              FontAwesomeIcons.history,
            ),
            listTile(
              'Fund Wallet',
              FontAwesomeIcons.creditCard,
            ),
            listTile(
              'Airtime',
              FontAwesomeIcons.phoneAlt,
            ),
            listTile(
              'Data',
              FontAwesomeIcons.globe,
            ),
            listTile(
              'Cable',
              FontAwesomeIcons.tv,
            ),
            Expanded(child: Container()),
            Container(
              color: secondaryColor,
              child: listTile(
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

    /*return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('Matnex Mix'),
            accountEmail: Text('matnex@gmail.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/img/logo.png'),
            ),
            decoration: BoxDecoration(
              color: primaryColor
            ),
          ),

          ListTile(
            leading: Icon( FontAwesomeIcons.home, size: 21, ),
            title: Text('Home'),
            onTap: (){

            },
          ),
          ListTile(
            leading: Icon( FontAwesomeIcons.history, size: 21, ),
            title: Text('Transaction History'),
            onTap: (){
              
            },
          ),
          ListTile(
            leading: Icon( FontAwesomeIcons.creditCard, size: 21, ),
            title: Text('Deposit'),
            onTap: (){
              
            },
          ),
          ListTile(
            leading: Icon( FontAwesomeIcons.headphonesAlt, size: 21, ),
            title: Text('Support'),
            onTap: (){
              
            },
          ),
          ListTile(
            leading: Icon( FontAwesomeIcons.powerOff, size: 21, ),
            title: Text('Sign Out'),
            onTap: (){
              
            },
          ),
        ]
      ),
    );*/
  }

  static listTile(String t, IconData icon,
      {Function action, color = primaryColor}) {
    return ListTile(
      leading: Icon(
        icon,
        size: 17,
        color: color,
      ),
      title: text(t, color: color, fontSize: 15),
      onTap: action,
    );
  }

  static snackbar({msg = 'An Error Occured', title = 'Error', duration = 5}) {
    return Get.snackbar(
      title,
      msg,
      backgroundColor: Colors.black,
      colorText: whiteColor,
      duration: Duration(seconds: duration),
      /* backgroundGradient: LinearGradient(
          colors: [secondaryColor, primaryColor],
        ), */
    );
  }

  static logo() {
    return Transform.rotate(
      angle: 360,
      child: Image.asset(
        "assets/images/finncube.png",
        height: 100,
        width: 100,
        fit: BoxFit.fill,
      ),
    );
  }

  static loader(UserModel user) {
    return user.isloading
        ? Center(
            child: Logo(),
          )
        : Container();
  }
}

class Logo extends StatefulWidget {
  Logo({Key key}) : super(key: key);

  _LogoState createState() => _LogoState();
}

class _LogoState extends State<Logo> with TickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
    animation = Tween(begin: 0.5, end: 1.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.ease));
    //animation = Tween(begin: 0.0, end: 1.0).animate(controller);

    controller.repeat(reverse: true);
    //controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return /* RotationTransition(
        turns: Tween(begin: 0.0, end: 1.0).animate(controller),
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            child: Container(
              //color: primaryColor,
              child: Image.asset(
                "assets/img/logo.png",
                height: 50,
                width: 50,
                fit: BoxFit.fill,
              ),
            ))); */
        ScaleTransition(
      scale: animation,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        child: Container(
          //color: primaryColor,
          child: Image.asset(
            "assets/img/logo.png",
            height: 50,
            width: 50,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
