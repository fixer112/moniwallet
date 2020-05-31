import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moniwallet/global.dart';
import 'package:moniwallet/providers/user.dart';
import 'package:moniwallet/value.dart';
import 'package:moniwallet/widgets/drawer.dart';
import 'package:moniwallet/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Cable extends StatefulWidget {
  Cable({Key key}) : super(key: key);

  _CableState createState() => _CableState();
}

class _CableState extends State<Cable> {
  var number = TextEditingController();
  var discount = TextEditingController();
  var password = TextEditingController();
  var smart = TextEditingController();
  var name = TextEditingController();
  String network;
  var plans;
  double price;
  String priceString;
  double topup;
  var plan;
  double discountPercentage = 0;
  bool enable = false;
  Map<String, dynamic> data;
  //{user.getUser.settings['Cable_discount']}
  @override
  void initState() {
    var user = Provider.of<UserModel>(context, listen: false);

    if (user.getUser.settings['cable_alert'] != "" && cableAlert) {
      Timer.run(
          () => Widgets.alert(user.getUser.settings['cable_alert'], context));
    }
    cableAlert = false;
    smart.addListener(() {
      print(smart.text);
      if (smart.text.length >= 10 && network != '') {
        confirmIUC(network, smart.text, context);
      } else {
        setState(() {
          enable = false;
          name.value = TextEditingValue(text: "");
        });
      }
    });
    super.initState();
  }

  Future confirmIUC(
    String type,
    String number,
    BuildContext context,
  ) async {
    //var user = Provider.of<UserModel>(context, listen: false);

    try {
      //user.setLoading(true);
      name.value = TextEditingValue(text: "Loading...");
      var link = '$url/verify/smart_no/$type/$number';
      final response = await http.get(link, headers: {
        'Accept': 'application/json',
      });
      //user.setLoading(false);

      var body = json.decode(response.body);

      print(body);

      setState(() {
        enable = false;
      });

      if (body.containsKey('customerName')) {
        name.value = TextEditingValue(text: body['customerName']);
        var d = {
          'customer_name': body['customerName'],
          'customer_number': body['customerNumber'],
          'invoice_no': body['invoice'],
        };
        setState(() {
          data = d;
          enable = true;
          print(data);
        });
      } else if (body == '') {
        setState(() {
          name.value = TextEditingValue(text: "Unable to validate smartcard");
        });
      } else {
        setState(() {
          name.value =
              TextEditingValue(text: 'SmartCard number does not exist');
        });
      }
    } catch (e) {
      //user.setLoading(false);
      print(e);
      setState(() {
        name.value = TextEditingValue(text: "");
      });
      return Widgets.snackbar(msg: connErrorMsg);
    }
  }

  @override
  void dispose() {
    number.dispose();
    password.dispose();
    discount.dispose();
    smart.dispose();
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: whiteColor,
          drawer: DrawerWidget(),
          appBar: Widgets.appbar('Cable'),
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
    var networks = user.getUser.settings['bills']['cable'].keys.toList();
    return ListView(
      children: <Widget>[
        Widgets.text('Cable Type'),
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
                hint: Widgets.text('Select Type'),
                value: network,

                onChanged: (value) {
                  //print(plans);
                  closeKeybord(context);
                  setState(() {
                    enable = false;
                    name.value = TextEditingValue(text: "");
                    smart.value = TextEditingValue(text: "");
                  });
                  discountPercentage = double.parse(user
                      .getUser.settings['cable_discount'][value]
                      .toString());
                  setState(() {
                    discount.text = '';
                    network = value;
                    print(network);
                    plans = user.getUser.settings['bills']['cable'][value];
                  });
                },
              ),
            ),
          ),
        ),
        Widgets.text('Smart Card Number'),
        Widgets.input(
          smart,
          context,
          icondata: FontAwesomeIcons.tv,
          type: TextInputType.number,
        ),
        Widgets.text('Customer Name'),
        Widgets.input(name, context,
            icondata: FontAwesomeIcons.userAlt, enable: false),
        Widgets.text('Customer Mobile Number'),
        Widgets.input(number, context,
            icondata: FontAwesomeIcons.phone,
            prefix: '+234',
            type: TextInputType.number,
            enable: enable),
        if (plans != null) Widgets.text('Cable Plans'),
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
                  items: plans.map<DropdownMenuItem<dynamic>>((cable) {
                    //var Cable = plans[index];
                    double price = double.parse(cable['price'].toString()) +
                        double.parse(cable['charges'].toString());
                    String string =
                        "${cable['name']} $price ${cable['duration']}";
                    return DropdownMenuItem(
                      value: cable,
                      child: Text(string.toUpperCase()),
                    );
                  }).toList(),
                  hint: Widgets.text('Select Plan'),
                  value: plan,
                  /* networkPrice != null ? networkPrice : null, */

                  onChanged: !enable
                      ? null
                      : (value) {
                          closeKeybord(context);
                          setState(() {
                            plan = value;
                            price = double.parse(value['price'].toString());
                            priceString = value['price'].toString();
                            var chaarges =
                                double.parse(value['charges'].toString());

                            discount.text = (calDiscountAmount(
                                        chaarges, discountPercentage) +
                                    price)
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
            type: TextInputType.visiblePassword,
            enable: enable),
        Widgets.button('Continue', context, () {
          if (!user.isloading) {
            if (!enable || priceString == '' || data == null) {
              return Widgets.snackbar(msg: 'Validate Smart card number');
            }
            if ([number.text, password.text, network, priceString, smart.text]
                .contains('')) {
              return Widgets.snackbar(msg: 'All inputs are required');
            }
            data.addAll({
              'type': network,
              'number': number.text,
              'password': password.text,
              'amount': priceString,
              'smart_no': smart.text,
            });

            print(data);
            return transaction('cable', data, context);
          }
        }, enable: enable),
      ],
    );
    //}),
    //);
  }
}
