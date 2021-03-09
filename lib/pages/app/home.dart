import 'dart:async';

// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:get/get.dart';
import '../../global.dart';
import '../../providers/user.dart';
import '../../value.dart';
import '../../widgets/drawer.dart';
import '../../widgets/widgets.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    var user = Provider.of<UserModel>(context, listen: false);

    if (user.getUser?.settings['general_alert'] != "" && generalAlert) {
      Timer.run(() =>
          Widgets.alert(user.getUser?.settings['general_alert'], context));
    }
    generalAlert = false;

    if (firstLoad) {
      Timer.run(() => refreshLogin(context));
    }
    firstLoad = false;

    //Timer.run(() => refreshLogin(context));

    firebaseMessaging.getToken().then((token) async {
      print('FCM Token: $token');
      var response = await http.post(
          '$url/api/user/${user.user?.id}/update_token?api_token=${user.user?.apiToken}',
          body: {
            'app_token': token,
          },
          headers: {
            'Accept': 'application/json',
          });

      print((response.body));
    });

    firebaseMessaging.requestPermission();
    //requestNotificationPermissions(IosNotificationSettings());

    firebaseMessaging.getInitialMessage().then((RemoteMessage message) {
      if (!message.isBlank) {
        bgMsgHdl(message);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      //AndroidNotification android = message.notification?.android;

      if (!notification.isBlank /* && android != null */) {
        bgMsgHdl(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Widgets.alert(message.notification.body, Get.context,
          title: message.notification.title ?? "Alert");
    });
    /* configure(
      onMessage: (Map<String, dynamic> message) {
        print('onMessage called: $message');
        /*  showNotificationWithDefaultSound(
            message['data']['title'], message['data']['body']);
         */
        return;
      },
      onResume: (Map<String, dynamic> message) {
        print('onResume called: $message');
        return;
      },
      onLaunch: (Map<String, dynamic> message) {
        print('onLaunch called: $message');
        return;
      },
      onBackgroundMessage: bgMsgHdl,
    ); */
    firebaseMessaging.getToken().then((token) {
      print('FCM Token: $token');
    });

    firebaseMessaging.subscribeToTopic('global');
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
            appBar: Widgets.appbar('MoniWallet', context,
                backgroundColor: Colors.transparent),
            body: Consumer<UserModel>(builder: (context, user, child) {
              return RefreshIndicator(
                onRefresh: () => refreshLogin(context),
                child: Widgets.body(
                  user,
                  body(user),
                ),
              );
            }),
          ),
        ));
  }

  body(UserModel? user) {
    Widget latestTran = ListView(
        //shrinkWrap: true,
        children: user?.getUser?.latestTransactions
                .map<Widget>(
                  (transaction) => Widgets.paymentCard({
                    'desc': transaction.desc,
                    'amount': transaction.amount,
                    'date': transaction.createdAt.toLocal().toString(),
                    'type': transaction.type,
                    'ref': transaction.ref,
                    'balance': transaction.balance,
                    'status': transaction.status,
                  }, () {}),
                )
                .toList() ??
            []);
    Widget latestCom = ListView(
        //shrinkWrap: true,
        children: user?.getUser?.latestComissions
                .map<Widget>(
                  (transaction) => Widgets.paymentCard({
                    'desc': transaction.desc,
                    'amount': transaction.amount,
                    'date': transaction.createdAt.toString(),
                    'type': 'credit',
                    'ref': transaction.ref,
                    'balance': transaction.balance,
                    'status': transaction.status,
                  }, () {}),
                )
                .toList() ??
            []);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        //padding: EdgeInsets.all(20),
        shrinkWrap: true,
        children: <Widget>[
          Container(
            //height: 110,
            child: customContainer(currencyFormat(user?.getUser?.balance ?? 0),
                'My Wallet', FontAwesomeIcons.wallet,
                color: secondaryColor),
          ),
          SizedBox(height: 15),
          Container(
            //height: 110,
            child: customContainer(
              currencyFormat(user?.getUser?.referralBalance ?? 0),
              'Refferal Wallet',
              FontAwesomeIcons.user,
              ref: user?.getUser?.settings['ref_link'],
            ),
          ),
          SizedBox(height: 15),
          Widgets.tabbedWidget([
            {
              'title': 'Wallet History',
              'icon': FontAwesomeIcons.wallet,
              'widget': Container(
                height: 300,
                child: checkNull(user?.getUser?.latestTransactions, latestTran,
                    msg: 'No transaction history available'),
              ),
            },
            {
              'title': 'Refferal History',
              'icon': FontAwesomeIcons.user,
              'widget': Container(
                height: 300,
                child: checkNull(user?.getUser?.latestComissions, latestCom,
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
      {Color color = primaryColor, String ref = ''}) {
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
                    Widgets.text(subText,
                        fontSize: 16,
                        color: color.withOpacity(0.7),
                        fontWeight: FontWeight.normal),
                    SizedBox(
                      height: 3,
                    ),
                    Widgets.text(text, fontSize: 25, color: color),
                    if (!ref.isBlank)
                      InkWell(
                        onTap: () async {
                          await Clipboard.setData(ClipboardData(text: ref))
                              .then((text) {
                            Widgets.snackbar(
                                msg: 'Referral Link Copied',
                                title: 'Copy Done');
                          });
                        },
                        child: Widgets.text(
                          'Referal link: $ref',
                          fontSize: 7,
                          color: color,
                        ),
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
