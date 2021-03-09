import 'dart:async';
import 'dart:convert';
import 'dart:io';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_messaging/firebase_messaging.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'pages/app/upgrade_alert.dart';
import 'pages/auth/login.dart';
import 'providers/user.dart';
import 'value.dart';
import 'widgets/widgets.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
//import 'package:rave_flutter/rave_flutter.dart';
//import 'package:shared_preferences/shared_preferences.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:url_launcher/url_launcher.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;
// ignore: import_of_legacy_library_into_null_safe
import 'package:app_review/app_review.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:package_info/package_info.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:version/version.dart';

bool generalAlert = true;
bool airtimeAlert = true;
bool dataAlert = true;
bool cableAlert = true;
bool firstLoad = true;

logout(context) async {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  // new FirebaseMessaging();
  var user = Provider.of<UserModel>(context, listen: false);
  if (user.user != null) {
    //FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
    firebaseMessaging.getToken().then((token) async {
      print('FCM Token: $token');
      var response = await http.post(
          '$url/api/user/${user.user?.id}/remove_token?api_token=${user.user?.apiToken}',
          body: {
            'app_token': token,
          },
          headers: {
            'Accept': 'application/json',
          });
      print(response.body);
    });
  }
  await removeJson();
  await removeJson(fileName: 'credentials.json');
  Get.to(Login());
}

currencyFormat(number) {
  var f = NumberFormat("#,###.##");
  return '₦' + f.format(number);
}

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    Widgets.snackbar();
  }
}

closeKeybord(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);

  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

Future transaction(
  String type,
  Map<String, dynamic> data,
  BuildContext context,
) async {
  var user = Provider.of<UserModel>(context, listen: false);

  try {
    user.setLoading(true);
    //print('loading');
    var link =
        '$url/api/user/${user.getUser?.id}/$type?api_token=${user.getUser?.apiToken}&plathform=app';
    //link = isRefresh ? "$link?refresh=yes" : link;
    print(link);
    final response = await http.post(link, body: data, headers: {
      'Accept': 'application/json',
    });
    user.setLoading(false);

    var body = json.decode(response.body);

    request(response, () async {
      if (body.containsKey('desc')) {
        refreshLogin(context);
        await appReview();
        return Widgets.transactionAlert(body['desc'], context);
      }
    }, context);
    return;
  } catch (e) {
    user.setLoading(false);
    print(e);
    //snackbar(e.message(), context, _scaffoldKey);
    return Widgets.snackbar(msg: connErrorMsg);
    //return snackbar(connErrorMsg, context, _scaffoldKey);
  }
}

request(http.Response response, Function action, context) {
  print(response.statusCode);
  var body = json.decode(response.body);
  print(body);
  return processResponse(response.statusCode, body, action, context);
}

processResponse(statusCode, body, Function action, context) {
  if (statusCode == 401) {
    Widgets.snackbar(msg: 'Please re login');
    return logout(context);
  }
  if (statusCode == 422) {
    var errors = '';
    body['errors'].forEach((error, data) => errors += '${data[0]}\n');
    //return snackbar(errors, context, _scaffoldKey);
    return Widgets.snackbar(msg: errors);
  }

  if (statusCode >= 200 && statusCode < 300) {
    if (body.containsKey('error')) {
      return Widgets.snackbar(msg: body['error']);
    }
    if (body.containsKey('success')) {
      return Widgets.snackbar(msg: body['success']);
    }
    action();
  } else {
    return Widgets.snackbar(msg: 'An error occured, Please try later.');
    /*  return snackbar(
        'An error occured, Please try later.', context, _scaffoldKey); */
  }
}

Future<Null> saveJson(String content, {String fileName = 'user.json'}) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String path = appDocDir.path;
  File file = new File(path + "/" + fileName);
  file.createSync();
  file.writeAsStringSync((content));
}

Future getJson({String fileName = 'user.json'}) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String path = appDocDir.path;
  var jsonFile = new File(path + "/" + fileName);
  bool fileExists = jsonFile.existsSync();
  return fileExists ? (jsonFile.readAsStringSync()) : null;
}

Future<Null> removeJson({String fileName = 'user.json'}) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String path = appDocDir.path;
  var jsonFile = new File(path + "/" + fileName);
  bool fileExists = jsonFile.existsSync();
  if (fileExists) jsonFile.delete();
}

ucFirst(String string) {
  return "${string[0].toUpperCase()}${string.substring(1)} ";
}

double calDiscountAmount(double amount, double percentage) {
  return amount - calPercentageAmount(amount, percentage);
}

calPercentageAmount(double amount, double percentage) {
  return (percentage / 100) * amount;
}

refreshLogin(BuildContext context, {bool refresh = true}) async {
  var user = Provider.of<UserModel>(context, listen: false);
  var credentials = await getJson(fileName: 'credentials.json');
  credentials = json.decode(credentials);
  await getRemoteConfig(context);
  await checkUpdateForce(context);
  user.login(credentials['username'], credentials['password'], context,
      isRefresh: refresh);
}

Widget checkNull(dynamic check, Widget widget, {String msg = ''}) {
  return check == null || check.isEmpty
      ? Center(child: Widgets.text(msg))
      : widget;
}

/* String _getReference(id) {
  return '${randomAlphaNumeric(7)}$id${randomAlphaNumeric(7)}';
} */

checkOut(
  BuildContext context, {
  required UserModel user,
  required double amount,
}) async {
  Widgets.transactionAlert("Currently not available", context);
  //amount = amount + (amount * 1.4);
  var publicKey = user.getUser?.settings['rave_public_key_app'];
  var encryptionKey = user.getUser?.settings['rave_enc_key_app'];
  //var ref = "mw-${_getReference(user.user?.id)}";
  print(publicKey);
  print(encryptionKey);
  //var charges = 1.4 / 100;
  //var chargeAmount = (amount / (1 - charges)).ceil() * 100;
  /* var initializer = RavePayInitializer(
      amount: amount, publicKey: publicKey, encryptionKey: encryptionKey)
    ..country = "NG"
    ..redirectUrl = '$url/verify/hook'
    ..currency = "NGN"
    ..email = user.user.email
    ..fName = user.user.firstname
    ..lName = user.user.lastname
    ..narration = 'Wallet funding from app'
    ..txRef = ref
    ..companyLogo = Image.asset("assets/img/logo.png")
    ..companyName = Text("MoniWallet")
    ..displayFee = true
    ..staging = kDebugMode
    ..acceptCardPayments = false
    ..acceptAccountPayments = true
    //..acceptMpesaPayments = true
    //..acceptAchPayments = true
    //..acceptGHMobileMoneyPayments = true
    //..acceptUgMobileMoneyPayments = true
    //..isPreAuth = true
    ..meta = {
      //'metaname': 'user_id',
      //'metavalue': user.user.id.toString(),
      'user_id': user.user.id.toString(),
      'reason': 'top-up',
      'amount': amount.toString(),
      'plathform': 'app',
      'number': user.user.number,
    };

  //..subAccounts = subAccounts
  //..acceptMpesaPayments = acceptMpesaPayment
  //..acceptAccountPayments = acceptAccountPayment
  //..acceptCardPayments = acceptCardPayment
  //..acceptAchPayments = acceptAchPayments
  //..acceptGHMobileMoneyPayments = acceptGhMMPayments
  //..acceptUgMobileMoneyPayments = acceptUgMMPayments
  //..isPreAuth = preAuthCharge

  // Initialize and get the transaction result
  RaveResult response =
      await RavePayManager().prompt(context: context, initializer: initializer);

  /* Charge charge = Charge()
    ..amount = amount
    ..reference = _getReference(user.user.id)
    ..putMetaData('user_id', user.user.id)
    ..putMetaData('reason', 'top-up')
    ..putMetaData('amount', amount)
    ..email = user.user.email;

  CheckoutResponse res = await PaystackPlugin.checkout(
    context,
    method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
    charge: charge,
  ); */
  print(response.message);
  //return;
  if (response.status == RaveStatus.success) {
    refreshLogin(context);
    //return
    Widgets.transactionAlert(
        "Payment of ${currencyFormat(amount)} successfull", context);
    try {
      user.setLoading(true);
      final response = await http.get('$url/verify/wallet/fund/$ref', headers: {
        'Accept': 'application/json',
      });
      user.setLoading(false);
      var body = json.decode(response.body);
      if (body.containsKey('success')) {
        refreshLogin(context);
        //return Widgets.transactionAlert(body['success'], context);
      }
      /* request(response, () async {
        return;
      }, context); */
    } catch (e) {
      print(e);
      user.setLoading(false);
      Widgets.snackbar(msg: connErrorMsg);
      //snackbar(connErrorMsg, context, _scaffoldKey);
    }
  } else {
    Widgets.snackbar(msg: response.message);
  } */
}

appReview({minCount = 2}) async {
  getJson(fileName: 'actions.json').then((j) async {
    var count = 1;
    if (j != null) {
      count = json.decode(j)['count'];
    }
    print(count);
    await saveJson(json.encode({'count': int.parse(count.toString()) + 1}),
        fileName: 'actions.json');
    if (count == minCount || (count % 10 == 0 && count < 21)) {
      await AppReview.storeListing;
    }
  });

  //}
}

Future<PackageInfo> initPackageInfo() async {
  final PackageInfo info = await PackageInfo.fromPlatform();
  return info;
}

Future<RemoteConfig> getRemoteConfig(BuildContext context) async {
  var user = Provider.of<UserModel>(context, listen: false);
  var info = await initPackageInfo();
  final RemoteConfig remoteConfig = await RemoteConfig.instance;
  final defaults = <String, dynamic>{
    'latest_version_force': info.version,
    'latest_version': info.version,
  };
  remoteConfig.setConfigSettings(RemoteConfigSettings());
  await remoteConfig.setDefaults(defaults);

  try {
    await remoteConfig.fetch(expiration: Duration(seconds: 0));
    await remoteConfig.activateFetched();
  } catch (e) {
    print(e);
  }

  user.setConfig(remoteConfig);

  print('latest version ${remoteConfig.getString('latest_version')}');
  print(
      'latest version force ${remoteConfig.getString('latest_version_force')}');
  return remoteConfig;
}

Future<bool> checkUpdate(BuildContext context) async {
  var user = Provider.of<UserModel>(context, listen: false);
  var info = await initPackageInfo();
  var latestVersion =
      Version.parse(user.getConfig?.getString('latest_version'));
  var currentVersion = Version.parse(info.version);
  if (latestVersion > currentVersion) {
    Widgets.updateAlert(
        latestVersion.toString(), currentVersion.toString(), context);
    return true;
  }
  return false;
}

Future<bool> checkUpdateForce(BuildContext context) async {
  var user = Provider.of<UserModel>(context, listen: false);
  var info = await initPackageInfo();
  var latestVersion =
      Version.parse(user.getConfig?.getString('latest_version_force'));
  var currentVersion = Version.parse(info.version);
  if (latestVersion > currentVersion) {
    Get.to(UpgradeAlert());
    return true;
  }
  return false;
}

Future showNotificationWithDefaultSound(String title, String message) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS =
      IOSInitializationSettings(onDidReceiveLocalNotification: null);
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (s) {
    print("Notification string $s");
    return;
  });
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '1', 'Notification', '',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      ticker: 'ticker',
      ongoing: false,
      styleInformation: BigTextStyleInformation(''));
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    '$title',
    '$message',
    platformChannelSpecifics,
    payload: 'Default_Sound',
  );
  //Widgets.alert(message, Get.context, title: title);
}

Future bgMsgHdl(/* Map<String, dynamic> */ RemoteMessage message) async {
  //print("onbgMessage: $message");
  /* Builder(
    builder: (context) {
      return Widgets.alert(message['data']['body'], context,
          title: message['data']['title']);
    },
  ); */
  /* if (Get.context != null)
    Widgets.alert(message['data']['body'], Get.context,
        title: message['data']['title']); */
  if (!message.isBlank && message.notification != null) {
    showNotificationWithDefaultSound(
        message.notification.title, message.notification.body);
  }
}

/* makeMyRequest(code) async {
  int subscriptionId = 1; // ussd code payload
  try {
    String ussdResponseMessage = await UssdService.makeRequest(
      subscriptionId,
      code,
      Duration(seconds: 10), // timeout (optional) - default is 10 seconds
    );
    print("succes! message: $ussdResponseMessage");
  } catch (e) {
    debugPrint("error! code: ${e.code} - message: ${e.message}");
  }
}

Future<void> launchUssd(String ussdCode) async {
  var res = await Ussd.runUssd(ussdCode);
  print(res);
}
 */
