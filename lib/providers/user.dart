import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:moniwallet/global.dart';
import 'package:moniwallet/models/user.dart';
import 'package:moniwallet/pages/app/home.dart';
import 'package:moniwallet/value.dart';
import 'package:moniwallet/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends ChangeNotifier {
  User user;
  RemoteConfig _config;
  bool _isLoading = false;

  setUser(User newUser) {
    user = newUser;
    notifyListeners();
  }

  setConfig(RemoteConfig config) {
    _config = config;
    notifyListeners();
  }

  RemoteConfig get getConfig => _config;

  User get getUser => user;

  setLoading(bool value) {
    _isLoading = value;
    Future.delayed(Duration(seconds: 1), () => notifyListeners());
  }

  bool get isloading => _isLoading;

  Future login(String username, String password, context,
      {bool isRefresh: false}) async {
    var user = Provider.of<UserModel>(context, listen: false);

    try {
      user.setLoading(true);
      //print('loading');
      var link = '$url/api/login';
      link = isRefresh ? "$link?type=app&refresh=yes" : link;
      final response = await http.post(link, body: {
        'username': username,
        'password': password,
      }, headers: {
        'Accept': 'application/json',
      });
      user.setLoading(false);
      var body = json.decode(response.body).containsKey('data')
          ? json.decode(response.body)['data']
          : json.decode(response.body);

      if ((response.statusCode < 200 || response.statusCode >= 300) &&
          isRefresh) {
        Widgets.snackbar(msg: 'Please re login');
        return logout();
      }
      request(response, () async {
        if (body != null) {
          var u = User.fromMap(body);
          setUser(u);
          await saveJson(jsonEncode(u));
          await saveJson(
              jsonEncode({'username': username, 'password': password}),
              fileName: 'credentials.json');
        }

        if (!isRefresh) Get.to(Home());
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
}
