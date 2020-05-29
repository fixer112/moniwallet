import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moniwallet/global.dart';
import 'package:moniwallet/models/comission.dart';
import 'package:moniwallet/models/transaction.dart';
import 'package:moniwallet/providers/user.dart';
import 'package:moniwallet/value.dart';
import 'package:moniwallet/widgets/widgets.dart';
import 'package:provider/provider.dart';

class User {
  final int id;
  final String username;
  final String firstname;
  final String lastname;
  final String fullname;
  final String number;
  final double balance;
  final double referralBalance;
  final bool isActive;
  final bool isReseller;
  final int points;
  final String email;
  final String apiToken;
  final String type;
  final String profilePic;
  final String bankName;
  final String accountNumber;
  final DateTime createdAt;
  List<Transaction> latestTransactions;
  List<Comission> latestComissions;
  var settings;
  final String packageName;

  User({
    this.id,
    this.username,
    this.firstname,
    this.fullname,
    this.lastname,
    this.email,
    this.apiToken,
    this.type,
    this.profilePic,
    this.createdAt,
    this.latestComissions,
    this.latestTransactions,
    this.settings,
    this.isActive,
    this.isReseller,
    this.number,
    this.points,
    this.balance,
    this.referralBalance,
    this.packageName,
    this.accountNumber,
    this.bankName,
  });

  factory User.fromMap(Map data) {
    return User(
      id: data['id'],
      username: data['login'],
      firstname: data['first_name'],
      lastname: data['last_name'],
      fullname: data['full_name'],
      email: data['email'],
      apiToken: data['api_token'],
      type: data['type'],
      profilePic: data['profile_pic'],
      settings: data['settings'],
      isActive: data['is_active'] == '1' ? true : false,
      isReseller: data['is_reseller'] == '1' ? true : false,
      points: int.parse(data['points']),
      number: data['number'],
      latestTransactions: List<Transaction>.from(data['latest_transactions']
          .map((i) => Transaction.fromMap(i))
          .toList()),
      latestComissions: List<Comission>.from(
          data['latest_comissions'].map((i) => Comission.fromMap(i)).toList()),
      createdAt: DateTime.parse(data['created_at']) ?? null,
      balance: double.parse(data['balance']),
      referralBalance: double.parse(data['referral_balance']),
      packageName: data['package_name'],
      bankName: data['bank_name'] ?? '',
      accountNumber: data['account_number'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'login': username,
        'first_name': firstname,
        'last_name': lastname,
        'full_name': fullname,
        'email': email,
        'api_token': apiToken,
        'type': type,
        'profile_pic': profilePic,
        'settings': settings,
        'is_active': isActive ? '1' : '0',
        'is_reseller': isReseller ? '1' : '0',
        'points': points.toString(),
        'number': number,
        'latest_transactions': latestTransactions,
        'latest_comissions': latestComissions,
        'created_at': createdAt.toIso8601String(),
        'balance': balance.toString(),
        'referral_balance': referralBalance.toString(),
        'package_name': packageName,
        'bank_name': bankName,
        'account_number': accountNumber,
      };

  /* List<Transaction> setTransactions(List<Transaction> transactions) {
    if (this.transactions != null) {
      transactions = [...this.transactions, ...transactions].toSet().toList();
    }
    transactions.sort((a, b) {
      return b.createdAt.compareto(a.createdAt);
    });

    return transactions;
  }

  List<Comission> setComissions(List<Comission> comissions) {
    if (this.comissions != null) {
      comissions = [...this.comissions, ...comissions].toSet().toList();
    }
    comissions.sort((a, b) {
      return b.createdAt.compareto(a.createdAt);
    });

    return comissions;
  } */

  Future getTransactions(BuildContext context, {from = '', to = ''}) async {
    var user = Provider.of<UserModel>(context, listen: false);
    try {
      //var user = Provider.of<UserModel>(context);
      user.setLoading(true);
      final response = await http.get(
          '$url/api/user/${this.id}/history?api_token=${this.apiToken}&from=$from&to=$to',
          headers: {
            'Accept': 'application/json',
          });
      user.setLoading(false);
      var body = json.decode(response.body).containsKey('data')
          ? json.decode(response.body)['data']
          : json.decode(response.body);
      //print(body);
      return List<Transaction>.from(
          body.map((i) => Transaction.fromMap(i)).toList());
      /* request(response, () {
        this.transactions = List<Transaction>.from(
            body.map((i) => Transaction.fromMap(i)).toList());
      }); */
    } catch (e) {
      user.setLoading(false);
      print(e);
      //snackbar(connErrorMsg, context, _scaffoldKey);
      Widgets.snackbar(msg: connErrorMsg);
    }
  }

  Future getComissions(BuildContext context, {from = '', to = ''}) async {
    var user = Provider.of<UserModel>(context, listen: false);
    try {
      //var user = Provider.of<UserModel>(context);
      user.setLoading(true);
      final response = await http.get(
          '$url/api/user/${this.id}/referral?api_token=${this.apiToken}&from=$from&to=$to',
          headers: {
            'Accept': 'application/json',
          });
      user.setLoading(false);
      var body = json.decode(response.body).containsKey('data')
          ? json.decode(response.body)['data']
          : json.decode(response.body);
      //print(body);
      return List<Comission>.from(
          body.map((i) => Comission.fromMap(i)).toList());
      /* request(response, () {
        this.comissions = List<Comission>.from(
            body.map((i) => Comission.fromMap(i)).toList());
      }); */
    } catch (e) {
      user.setLoading(false);
      print(e);
      //snackbar(connErrorMsg, context, _scaffoldKey);
      Widgets.snackbar(msg: connErrorMsg);
    }
  }
}
