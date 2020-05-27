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

  Future login(String username, String password, context) async {
    var user = Provider.of<UserModel>(context, listen: false);

    try {
      user.setLoading(true);
      //print('loading');
      final response = await http.post('$url/api/login', body: {
        'username': username,
        'password': password,
      }, headers: {
        'Accept': 'application/json',
      });
      user.setLoading(false);
      var body = json.decode(response.body).containsKey('data')
          ? json.decode(response.body)['data']
          : json.decode(response.body);

      request(response, () async {
        if (body != null) {
          var u = User.fromMap(body);
          setUser(u);
          await saveJson(u.toJson());
          //await saveJson('credentials', {'username': username});
        }
        //user.user.settings = body['settings'];
        //await user.user.getTransactions(context);
        //await user.user.getComissions(context);
        Get.off(Home());
      });
    } catch (e) {
      user.setLoading(false);
      print(e);
      //snackbar(e.message(), context, _scaffoldKey);
      return Widgets.snackbar(msg: connErrorMsg);
      //return snackbar(connErrorMsg, context, _scaffoldKey);
    }
  }
}
