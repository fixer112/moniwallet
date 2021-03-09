import 'dart:async';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../global.dart';
import '../../providers/user.dart';
import '../../value.dart';
import '../../widgets/drawer.dart';
import '../../widgets/widgets.dart';
import 'package:provider/provider.dart';

class Data extends StatefulWidget {
  Data({Key? key}) : super(key: key);

  _DataState createState() => _DataState();
}

class _DataState extends State<Data> {
  var number = TextEditingController();
  var discount = TextEditingController();
  var password = TextEditingController();
  String network = '';
  var plans;
  double price = 0;
  String priceString = '';
  double topup = 0;
  var plan;
  double discountPercentage = 0;
  List networks = [];
  //{user.getUser.settings['Data_discount']}
  @override
  void initState() {
    //print("discount " + user.getUser.settings);
    var user = Provider.of<UserModel>(context, listen: false);

    networks = user.getUser?.settings['bills']['data'].keys.toList();
    network = networks[0];

    if (user.getUser?.settings['data_alert'] != "" && dataAlert) {
      Timer.run(
          () => Widgets.alert(user.getUser?.settings['data_alert'], context));
    }
    dataAlert = false;

    super.initState();
  }

  @override
  void dispose() {
    number.dispose();
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
          appBar: Widgets.appbar('Data', context),
          body: Container(
            padding: EdgeInsets.all(20),
            child: Consumer<UserModel>(builder: (context, user, child) {
              return Stack(children: [
                body(user),
                Widgets.loader(user),
              ]);
            }),
          ),
        ));
  }

  body(UserModel user) {
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

                onChanged: (dynamic value) {
                  closeKeybord(context);
                  discountPercentage = double.parse(user
                          .getUser?.settings['data_discount'][value]
                          .toString() ??
                      '0');
                  setState(() {
                    discount.text = '';
                    network = value;
                    plans = user.getUser?.settings['bills']['data'][value];
                  });
                },
              ),
            ),
          ),
        ),
        if (plans != null) Widgets.text('Data Plans'),
        if (plans != null)
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
                  isExpanded: true,
                  items: plans.map<DropdownMenuItem<dynamic>>((data) {
                    //var data = plans[index];
                    String string =
                        "${data["id"]} ${data["topup_currency"].toString()} ${double.parse(data['topup_amount'].toString()).toString()} ${data["validity"]} (${data["type"]})";
                    return DropdownMenuItem(
                      value: data,
                      child: Text(string),
                    );
                  }).toList(),
                  hint: Widgets.text('Select Plan'),
                  value: plan,
                  /* networkPrice != null ? networkPrice : null, */

                  onChanged: plans == null
                      ? null
                      : (dynamic value) {
                          closeKeybord(context);
                          setState(() {
                            plan = value;
                            price = double.parse(value['price'].toString());
                            priceString = value['price'].toString();
                            topup =
                                double.parse(value['topup_amount'].toString());
                            discount.text =
                                calDiscountAmount(topup, discountPercentage)
                                    .toString();
                            //networkPrice = "$value";
                            //price = double.parse(value.replaceAll(network, ''));
                            //print(price);
                          });
                        },
                ),
              ),
            ),
          ),
        Widgets.text('Discount Amount at ${discountPercentage.toString()}%'),
        Widgets.input(discount, context,
            icondata: FontAwesomeIcons.moneyBill, enable: false),
        Widgets.text('Password'),
        Widgets.input(password, context,
            icondata: FontAwesomeIcons.key,
            type: TextInputType.visiblePassword),
        Widgets.button('Continue', context, () {
          if (!user.isloading) {
            if ([number.text, password.text, network, priceString]
                .contains('')) {
              return Widgets.snackbar(msg: 'All inputs are required');
            }
            var data = {
              'network': network,
              'number': number.text,
              'password': password.text,
              'price': priceString,
            };
            return transaction('data', data, context);
          }
        }),
      ],
    );
    //}),
    //);
  }
}
