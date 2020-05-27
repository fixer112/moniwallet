import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:json_store/json_store.dart';
import 'package:moniwallet/pages/auth/login.dart';
import 'package:moniwallet/widgets/widgets.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/user.dart';

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

request(Response response, Function action) {
  print(response.statusCode);
  var body = json.decode(response.body);
  print(body);
  return processResponse(response.statusCode, body, action);
}

processResponse(statusCode, body, Function action) {
  if (statusCode == 401) {
    Widgets.snackbar(msg: 'Please re login');
    return Get.off(Login());
  }
  if (statusCode == 422) {
    var errors = '';
    body['errors'].forEach((error, data) => errors += '${data[0]}\n');
    //return snackbar(errors, context, _scaffoldKey);
    return Widgets.snackbar(msg: errors);
  }

  if (statusCode == 200) {
    if (body.containsKey('error')) {
      Widgets.snackbar(msg: body['error']);
    }
    if (body.containsKey('success')) {
      Widgets.snackbar(msg: body['success']);
    }
    action();
  } else {
    return Widgets.snackbar(msg: 'An error occured, Please try later.');
    /*  return snackbar(
        'An error occured, Please try later.', context, _scaffoldKey); */
  }
}

localStorage() async {
  SharedPreferences storage = await SharedPreferences.getInstance();
  return storage;
}

Future<Null> saveJson(String content, {String fileName = 'user.json'}) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String path = appDocDir.path;
  File file = new File(path + "/" + fileName);
  file.createSync();
  file.writeAsStringSync((content));
}

Future<Null> saveString(String key, value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(key, (value));
}

Future getJson({String fileName = 'user.json'}) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String path = appDocDir.path;
  var jsonFile = new File(path + "/" + fileName);
  bool fileExists = jsonFile.existsSync();
  return fileExists ? (jsonFile.readAsStringSync()) : null;
}

Future<String> getString(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
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
