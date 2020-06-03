import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moniwallet/global.dart';
import 'package:moniwallet/providers/user.dart';
import 'package:moniwallet/value.dart';
import 'package:moniwallet/widgets/drawer.dart';
import 'package:moniwallet/widgets/widgets.dart';
import 'package:provider/provider.dart';

class Airtime extends StatefulWidget {
  Airtime({Key key}) : super(key: key);

  _AirtimeState createState() => _AirtimeState();
}

class _AirtimeState extends State<Airtime> {
  var number = TextEditingController();
  var amount = TextEditingController();
  var discount = TextEditingController();
  var password = TextEditingController();
  String network;
  double discountPercentage = 0;
  //{user.getUser.settings['airtime_discount']}
  @override
  void initState() {
    var user = Provider.of<UserModel>(context, listen: false);

    if (user.getUser.settings['airtime_alert'] != "" && airtimeAlert) {
      Timer.run(
          () => Widgets.alert(user.getUser.settings['airtime_alert'], context));
    }
    airtimeAlert = false;

    amount.addListener(() {
      if (network != '') {
        discount.text = amount.text == ''
            ? ''
            : calDiscountAmount(double.parse(amount.text), discountPercentage)
                .toString();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    number.dispose();
    amount.dispose();
    password.dispose();
    discount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: whiteColor,
          drawer: DrawerWidget(),
          appBar: Widgets.appbar('Airtime', context),
          body: Container(
            padding: EdgeInsets.all(20),
            child: Consumer<UserModel>(builder: (context, user, child) {
              return Widgets.body(
                user,
                body(user),
              );
            }),
          ),
        ));
  }

  body(UserModel user) {
    var networks = user.getUser.settings['bills']['airtime'].keys.toList();
    return ListView(
      children: <Widget>[
        Widgets.text('Mobile Number'),
        Widgets.input(number, context,
            icondata: FontAwesomeIcons.phone,
            prefix: '+234',
            type: TextInputType.number),
        Widgets.text('Mobile Networks'),
        Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          //width: 200.0,
          height: 54.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(color: Colors.grey)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                //isExpanded: true,
                items: List.generate(networks.length, (index) {
                  String string = networks[index];
                  return Widgets.dropItem(string.toUpperCase(), string);
                }),
                hint: Widgets.text('Select Network'),
                value: network,
                onChanged: (value) {
                  //print(user.getUser.settings['airtime_discount'][value]);

                  setState(() {
                    network = value;
                    discountPercentage = double.parse(user
                        .getUser.settings['airtime_discount'][value]
                        .toString());
                    if (amount.text != '') {
                      discount.text = calDiscountAmount(
                              double.parse(amount.text), discountPercentage)
                          .toString();
                    }
                  });
                },
              ),
            ),
          ),
        ),
        Widgets.text('Amount'),
        Widgets.input(amount, context,
            icondata: FontAwesomeIcons.moneyBill,
            type: TextInputType.numberWithOptions(decimal: false)),
        Widgets.text('Discount Amount at ${discountPercentage.toString()}%'),
        Widgets.input(discount, context,
            icondata: FontAwesomeIcons.moneyBill, enable: false),
        Widgets.text('Password'),
        Widgets.input(password, context,
            icondata: FontAwesomeIcons.key,
            type: TextInputType.visiblePassword),
        Widgets.button('Continue', context, () {
          if (!user.isloading) {
            if ([number.text, password.text, network, amount.text]
                .contains('')) {
              return Widgets.snackbar(msg: 'All inputs are required');
            }
            var data = {
              'network': network,
              'amount': amount.text,
              'number': number.text,
              'password': password.text,
            };
            return transaction('airtime', data, context);
          }
        }),
      ],
    );
    //}),
    //);
  }
}
