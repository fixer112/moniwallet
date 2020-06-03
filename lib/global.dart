import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:moniwallet/pages/auth/login.dart';
import 'package:moniwallet/providers/user.dart';
import 'package:moniwallet/value.dart';
import 'package:moniwallet/widgets/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:app_review/app_review.dart';

bool generalAlert = true;
bool airtimeAlert = true;
bool dataAlert = true;
bool cableAlert = true;

logout() async {
  await removeJson();
  await removeJson(fileName: 'credentials.json');
  Get.to(Login());
}

currencyFormat(number) {
  var f = NumberFormat("#,###");
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
        '$url/api/user/${user.getUser.id}/$type?api_token=${user.getUser.apiToken}&plathform=app';
    //link = isRefresh ? "$link?refresh=yes" : link;
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
    });
    return;
  } catch (e) {
    user.setLoading(false);
    print(e);
    //snackbar(e.message(), context, _scaffoldKey);
    return Widgets.snackbar(msg: connErrorMsg);
    //return snackbar(connErrorMsg, context, _scaffoldKey);
  }
}

request(Response response, Function action) {
  print(response.statusCode);
  var body = json.decode(response.body);
  print(body);
  return processResponse(response.statusCode, body, action);
}

processResponse(statusCode, body, Function action) {
  if (statusCode == 401) {
    Widgets.snackbar(msg: 'Please re login');
    return logout();
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
  user.login(credentials['username'], credentials['password'], context,
      isRefresh: refresh);
}

Widget checkNull(dynamic check, Widget widget, {String msg = ''}) {
  return check == null || check.isEmpty
      ? Center(child: Widgets.text(msg))
      : widget;
}

String _getReference(id) {
  return '${randomAlphaNumeric(7)}$id${randomAlphaNumeric(7)}';
}

checkOut(
  BuildContext context, {
  @required UserModel user,
  @required int amount,
}) async {
  var charges = 1.5 / 100;
  var chargeAmount = (amount / (1 - charges)).ceil() * 100;
  Charge charge = Charge()
    ..amount = chargeAmount
    ..reference = _getReference(user.user.id)
    ..putMetaData('user_id', user.user.id)
    ..putMetaData('reason', 'top-up')
    ..putMetaData('amount', amount)
    ..email = user.user.email;

  CheckoutResponse res = await PaystackPlugin.checkout(
    context,
    method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
    charge: charge,
  );
  print(res.toString());
  if (res.message != 'Transaction terminated') {
    try {
      user.setLoading(true);
      final response =
          await http.get('$url/verify/wallet/fund/${res.reference}', headers: {
        'Accept': 'application/json',
      });
      user.setLoading(false);
      var body = json.decode(response.body);
      if (body.containsKey('success')) {
        refreshLogin(context);
        return Widgets.transactionAlert(body['success'], context);
      }
      request(response, () async {
        return;
      });
    } catch (e) {
      print(e);
      user.setLoading(false);
      Widgets.snackbar(msg: connErrorMsg);
      //snackbar(connErrorMsg, context, _scaffoldKey);
    }
  }
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
