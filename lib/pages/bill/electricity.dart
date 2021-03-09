import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../global.dart';
import '../../providers/user.dart';
import '../../value.dart';
import '../../widgets/drawer.dart';
import '../../widgets/widgets.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;

class Electricity extends StatefulWidget {
  Electricity({Key? key}) : super(key: key);

  _ElectricityState createState() => _ElectricityState();
}

class _ElectricityState extends State<Electricity> {
  var number = TextEditingController();
  var discount = TextEditingController();
  var password = TextEditingController();
  var smart = TextEditingController();
  var name = TextEditingController();
  var amount = TextEditingController();
  Map<String, dynamic> network = {};
  String type = '1';
  String service = '';
  var multiples = 1;
  double discountPercentage = 0;
  bool enable = false;
  Map<String, dynamic> data = {};
  Map<String, dynamic> electricity = {};
  List<dynamic> products = [];

  //{user.getUser.settings['Cable_discount']}
  @override
  void initState() {
    var user = Provider.of<UserModel>(context, listen: false);
    electricity = user.getUser?.settings['bills']['electricity'];
    products = electricity['products'];
    network = products[0];
    //print(electricity);

    setState(() {
      discountPercentage = double.parse(
          user.getUser?.settings['electricity_discount'].toString() ?? '0');
    });

    if (user.getUser?.settings['electricity_alert'] != "" && cableAlert) {
      Timer.run(() =>
          Widgets.alert(user.getUser?.settings['electricity_alert'], context));
    }
    cableAlert = false;
    smart.addListener(() {
      print(smart.text);
      print(network);
      print(service);
      //return;
      if (network.isNotEmpty) {
        confirmIUC(service, smart.text, context);
      } else {
        setState(() {
          enable = false;
          name.value = TextEditingValue(text: "");
        });
      }
    });
    amount.addListener(() {
      print(amount.text);

      setState(() {
        var electricity = user.getUser?.settings['bills']['electricity'];
        multiples = (int.parse(amount.text) /
                user.getUser?.settings['electricity_discount_multiple'])
            .ceil();
        var charges = (electricity['charges'] * multiples) -
            ((discountPercentage / 100) * (electricity['charges'] * multiples));
        discount.value = TextEditingValue(
            text: (int.parse(amount.text) + charges).toString());
      });
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
      var link = '$url/verify/meter_no/$type/$number';
      final response = await http.get(link, headers: {
        'Accept': 'application/json',
      });
      //user.setLoading(false);

      var body = json.decode(response.body);

      print(body);

      setState(() {
        enable = false;
      });

      if (body.containsKey('code') && body['code'] == 100) {
        name.value = TextEditingValue(text: body['message']);

        setState(() {
          enable = true;
          print(data);
        });
      } else if (body == '') {
        setState(() {
          name.value = TextEditingValue(text: "Unable to validate meter");
        });
      } else {
        setState(() {
          name.value = TextEditingValue(text: 'Meter number does not exist');
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
          appBar: Widgets.appbar('Electricity', context),
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
    //print(products);
    //return Container();

    return ListView(
      children: <Widget>[
        Widgets.text('Service Type'),
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
              child: DropdownButton<Map<String, dynamic>>(
                //isExpanded: true,
                items: products.map((product) {
                  String string = product['name'];
                  return DropdownMenuItem<Map<String, dynamic>>(
                    child: Row(
                      children: <Widget>[
                        Text(string),
                      ],
                    ),
                    value: product,
                  );
                }).toList(),
                /* (products.length, (product) {
                  String string = products[index]['name'];
                  return DropdownMenuItem<Map<String, dynamic>>(
                    child: Row(
                      children: <Widget>[
                        Text(string),
                      ],
                    ),
                    value: products[index],
                  );
                  //Widgets.dropItem(string.toUpperCase(), string);
                }).toList(), */
                /* products.map<DropdownMenuItem<Map>>((product) {
                  //var string = networks[index];
                  return DropdownMenuItem<Map>(
                    child: Row(
                      children: <Widget>[
                        Text(product['name']),
                      ],
                    ),
                    value: product,
                  );
                }).toList(), */
                hint: Widgets.text('Select Type'),
                value: network,

                onChanged: (dynamic value) {
                  //print(plans);
                  closeKeybord(context);
                  setState(() {
                    network = value;
                    service = network['product_id'];
                  });
                },
              ),
            ),
          ),
        ),
        Widgets.text('Meter Type'),
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
                items: [
                  ['prepaid', '1'],
                  ['postpaid', '0']
                ].map<DropdownMenuItem<dynamic>>((type) {
                  //var Cable = plans[index];

                  return DropdownMenuItem(
                    value: type[1],
                    child: Text(type[0].toUpperCase()),
                  );
                }).toList(),
                hint: Widgets.text('Select Type'),
                value: type,
                /* networkPrice != null ? networkPrice : null, */

                onChanged: (dynamic value) {
                  closeKeybord(context);
                  setState(() {
                    type = value;
                  });
                },
              ),
            ),
          ),
        ),
        Widgets.text('Meter Number'),
        Widgets.input(
          smart,
          context,
          icondata: FontAwesomeIcons.calculator,
          type: TextInputType.number,
          enable: service.isNotEmpty,
        ),
        Widgets.text('Customer Name'),
        Widgets.input(name, context,
            icondata: FontAwesomeIcons.userAlt, enable: false),
        Widgets.text(
            'Amount (Charges of NGN${(electricity['charges'] * multiples).toString()})'),
        Widgets.input(amount, context,
            icondata: FontAwesomeIcons.moneyBill, type: TextInputType.number),
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
            if (!enable) {
              return Widgets.snackbar(msg: 'Validate Meter number');
            }
            if ([password.text, network, smart.text, amount.text, type]
                .contains('')) {
              return Widgets.snackbar(msg: 'All inputs are required');
            }
            data = {
              'type': type,
              'service': service,
              'amount': amount.text,
              'password': password.text,
              'meter_no': smart.text,
            };

            print(data);
            return transaction('electricity', data, context);
          }
        }, enable: enable),
      ],
    );
    //}),
    //);
  }
}
