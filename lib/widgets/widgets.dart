import 'dart:ui';

// ignore: import_of_legacy_library_into_null_safe
import 'package:app_review/app_review.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:get/get.dart';
//import 'package:getflutter/getflutter.dart';
import 'package:moniwallet/global.dart';
import 'package:moniwallet/pages/app/home.dart';
import 'package:moniwallet/providers/user.dart';
import 'package:moniwallet/value.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class Widgets {
  static updateAlert(String latest, String current, BuildContext context,
      {title = "Update Available"}) {
    Widget cancelButton = Widgets.button('Later', context, () => Get.back());
    /* FlatButton(
      child: Text("Later"),
      onPressed: () {
        Get.back();
      },
    ); */

    Widget updateButton = Widgets.button(
      'Update Now',
      context,
      () async {
        await AppReview.storeListing;
        Get.back();
      },
    );
    /* FlatButton(
      child: Text("Update Now"),
      onPressed: () async {
        await AppReview.storeListing;
        Get.back();
      },
    ); */
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(
              "Version $latest is available, you are currently using version $current"),
          actions: [
            cancelButton,
            updateButton,
          ],
        );
      },
    );
  }

  static body(UserModel user, Widget body) {
    return Stack(children: [
      body,
      Widgets.loader(user),
    ]);
  }

  static appbar(String title, BuildContext context,
      {Color color = whiteColor, Color backgroundColor = primaryColor}) {
    var user = Provider.of<UserModel>(context, listen: false);
    return AppBar(
      iconTheme: new IconThemeData(color: color),
      elevation: 0,
      backgroundColor: backgroundColor,
      title: text(
        title,
        color: color,
      ),
      actions: <Widget>[
        PopupMenuButton<String>(
          onSelected: (value) async {
            switch (value) {
              case 'link':
                Share.share(
                    "Moniwallet is Nigeria's fastest growing bill payments plathform. Airtime, Data, Cable Tv, and many more at discount prices. Register through this link ${user.getUser?.settings['ref_link']} to also enjoy amazing discounts",
                    subject: 'Register on MoniWallet');
                break;
              case 'app':
                var p = await PackageInfo.fromPlatform();
                Share.share(
                    "Moniwallet is Nigeria's fastest growing bill payments plathform. Airtime, Data, Cable Tv, and many more at discount prices. Download app at https://play.google.com/store/apps/details?id=${p.packageName} to also enjoy amazing discounts",
                    subject: 'Register on MoniWallet');
                break;
              default:
            }
          },
          itemBuilder: (BuildContext context) {
            return {
              ['Share Referral Link', 'link'],
              ['Share Moniwallet App', 'app']
            }.map((choice) {
              return PopupMenuItem<String>(
                value: choice[1],
                child: ListTile(
                  title: Text(choice[0]),
                  //leading: Icon(Icons.link),
                ),
              );
            }).toList();
          },
        ),
        /* IconButton(
          icon: Icon(
            FontAwesomeIcons.link,
            size: 10,
          ),
          onPressed: () {
            //_select(choices[0]);
          },
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert,
            size: 10,
          ),
          onPressed: () {
            //_select(choices[0]);
          },
        ), */
      ],
    );
  }

  static text(text,
      {double fontSize = 15,
      fontWeight = FontWeight.bold,
      Color color = Colors.black,
      overflow}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
      overflow: overflow,
    );
  }

  static input(TextEditingController controller, BuildContext context,
      {String hintText = '',
      TextInputType type = TextInputType.text,
      bool spaced = true,
      IconData? icondata,
      String prefix = '',
      bool enable = true}) {
    var user = Provider.of<UserModel>(context, listen: false);
    Icon? icon = icondata.isBlank
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
        enabled: !user.isloading && enable,
      ),
    );
  }

  static button(String text, BuildContext context, Function action,
      {bool spaced = true,
      Color color = primaryColor,
      Color textColor = whiteColor,
      bool enable = true}) {
    var user = Provider.of<UserModel>(context, listen: false);
    return Container(
      height: 54,
      margin: EdgeInsets.symmetric(vertical: spaced ? 15 : 0),
      child: TextButton(
        child: Text(
          text,
        ),
        style: TextButton.styleFrom(
          primary: textColor,
          backgroundColor: color,
          textStyle: TextStyle(),
          //disabledMouseCursor:
        ),
        onPressed: user.isloading || !enable
            ? null
            : () {
                action();
                closeKeybord(context);
              },
      ), /* FlatButton(
        disabledColor: Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: color,
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
        onPressed: user.isloading || !enable
            ? null
            : () {
                action();
                closeKeybord(context);
              },
      ), */
    );
  }

  static waiting(BuildContext context,
      {Function? task, Function? whenComplete}) {
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
        builder: (BuildContext builder) {
          return Scaffold(
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
                    Widgets.button(
                        'CLOSE', context, () => Navigator.pop(context))
                    /* FlatButton(
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
                    ) */
                    ,
                  ],
                ),
              ),
            ),
          );
        });
    /* showDialog(
      context: context,
      builder: Scaffold(
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
  
   */
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
      child: Drawer(
        //color: whiteColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: text(
                  "${user.getUser?.fullname} (${ucFirst(user.getUser?.packageName ?? '')} Account)",
                  color: whiteColor),
              accountEmail: text(user.getUser?.email, color: whiteColor),
              currentAccountPicture: CircleAvatar(
                backgroundImage:
                    NetworkImage('$url/${user.getUser?.profilePic}'),
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
              action: () {},
            ),
            listTile(
              'Fund Wallet',
              FontAwesomeIcons.creditCard,
              action: () {},
            ),
            listTile(
              'Airtime',
              FontAwesomeIcons.phoneAlt,
              action: () {},
            ),
            listTile(
              'Data',
              FontAwesomeIcons.globe,
              action: () {},
            ),
            listTile(
              'Cable',
              FontAwesomeIcons.tv,
              action: () {},
            ),
            Expanded(child: Container()),
            Container(
              color: secondaryColor,
              child: listTile(
                'Logout',
                FontAwesomeIcons.powerOff,
                action: () {},
                /* action: () async {
                  await removeJson();
                  Get.to(Login());
                }, */
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
      {required Function action, color = primaryColor}) {
    return ListTile(
      leading: Icon(
        icon,
        size: 17,
        color: color,
      ),
      title: text(t, color: color, fontSize: 15),
      onTap: () {
        action();
      },
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

  static DropdownMenuItem dropItem(String text, dynamic value) {
    return DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Text(text),
        ],
      ),
      value: value,
    );
  }

  static transactionAlert(String desc, BuildContext context) {
    Widget cancelButton =
        Widgets.button('Stay Here', context, () => Get.back());
    /* FlatButton(
      child: Text("Stay Here"),
      onPressed: () {
        Get.back();
      },
    ); */
    Widget continueButton =
        Widgets.button('Go Home', context, () => Get.to(Home()));
    /* FlatButton(
      child: Text("Go Home"),
      onPressed: () {
        Get.to(Home());
      },
    ); */
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Transaction Successfull"),
          content: Text(desc),
          actions: [
            cancelButton,
            continueButton,
          ],
        );
      },
    );
  }

  static alert(String desc, BuildContext context, {title = "Alert"}) {
    Widget cancelButton = button('OK', context, () => Get.back());
    /* FlatButton(
      child: Text("OK"),
      onPressed: () {
        Get.back();
      },
    ); */
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(desc),
          actions: [
            cancelButton,
          ],
        );
      },
    );
  }

  static tabbedWidget(List tabs, {int currentIndex: 0, Function? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
            //height: 100,
            ),
        Container(
          height: 60,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(tabs.length, (index) {
                return InkWell(
                  onTap: () {
                    if (controller != null) {
                      controller(index);
                    }
                  },
                  child: Card(
                    child: Container(
                      // height: 110,
                      decoration: BoxDecoration(
                        border: Border(
                          top: index == currentIndex
                              ? BorderSide(color: primaryColor, width: 3)
                              : BorderSide.none,
                        ),
                      ),
                      padding: EdgeInsets.all(15),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            tabs[index]['icon'],
                            size: 13,
                            color: index == currentIndex ? primaryColor : null,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Widgets.text(tabs[index]['title'],
                              fontSize: 13,
                              color: index == currentIndex
                                  ? primaryColor
                                  : Colors.black),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          child: tabs[currentIndex]['widget'],
        ),
      ],
    );
  }

  static paymentCard(Map data, Function f) {
    var font = FontAwesomeIcons.check;
    var color = Colors.green;

    switch (data['status']) {
      case 'pending':
        font = FontAwesomeIcons.solidClock;
        color = Colors.blue;
        break;
      case 'failed':
        font = FontAwesomeIcons.times;
        color = Colors.red;
        break;
      default:
    }

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      color: whiteColor,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(
              data['type'] == 'credit'
                  ? FontAwesomeIcons.caretUp
                  : FontAwesomeIcons.caretDown,
              color: (data['type'] == 'credit' ? secondaryColor : primaryColor),
            ),
            Container(
              //color: Colors.green,
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                  color: color,
                  //border: Border.all(),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Icon(
                font,
                size: 12,
                color: whiteColor,
              ),
            ),
          ],
        ),
        title: Container(
          margin: EdgeInsets.only(bottom: 10),
          child: text(data['desc'], fontSize: 15),
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            text(data['ref'], fontSize: 12),
            SizedBox(height: 5),
            text(data['date'], fontSize: 11, fontWeight: FontWeight.normal),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            text(
                (data['type'] == 'debit' ? '-' : '') +
                    currencyFormat(data['amount']),
                color:
                    (data['type'] == 'credit' ? secondaryColor : primaryColor),
                fontSize: 16),
            SizedBox(height: 5),
            text(currencyFormat(data['balance']),
                color:
                    (data['type'] == 'credit' ? secondaryColor : primaryColor),
                fontSize: 12),
          ],
        ),
        onTap: f(),
      ),
    );
  }
}

class Logo extends StatefulWidget {
  Logo({Key? key}) : super(key: key);

  _LogoState createState() => _LogoState();
}

class _LogoState extends State<Logo> with TickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? animation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
    animation = Tween(begin: 0.5, end: 1.0)
        .animate(CurvedAnimation(parent: controller!, curve: Curves.ease));
    //animation = Tween(begin: 0.0, end: 1.0).animate(controller);

    controller?.repeat(reverse: true);
    //controller.repeat();
  }

  @override
  void dispose() {
    controller?.dispose();
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
      scale: animation!,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        child: Container(
          color: whiteColor,
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
