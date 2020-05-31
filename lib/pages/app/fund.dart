import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moniwallet/global.dart';
import 'package:moniwallet/providers/user.dart';
import 'package:moniwallet/value.dart';
import 'package:moniwallet/widgets/drawer.dart';
import 'package:moniwallet/widgets/widgets.dart';
import 'package:provider/provider.dart';

class Fund extends StatefulWidget {
  @override
  _FundState createState() => _FundState();
}

class _FundState extends State<Fund> {
  var amount = TextEditingController();
  @override
  void initState() {
    var user = Provider.of<UserModel>(context, listen: false);
    var publicKey = user.getUser.settings['paystack_key'];
    print(publicKey);

    PaystackPlugin.initialize(publicKey: publicKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: whiteColor,
          drawer: DrawerWidget(),
          appBar: Widgets.appbar('Fund Wallet'),
          body: Consumer<UserModel>(builder: (context, user, child) {
            return Widgets.body(
                user,
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Card(
                        color: primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Widgets.text(
                                  "You can also fund your wallet by transfering to the account details below, the account is unique to your wallet.",
                                  color: Colors.white),
                              SizedBox(
                                height: 15,
                              ),
                              Widgets.text(
                                  "Transfer charges of ${user.getUser.settings['transfer_fee']}% applies.",
                                  color: Colors.white),
                              SizedBox(
                                height: 15,
                              ),
                              Widgets.text(
                                  'Your wallet will be funded automatically within 5 mins of transfer.',
                                  color: Colors.white),
                              SizedBox(
                                height: 20,
                              ),
                              Widgets.text('Account Details',
                                  color: secondaryColor, fontSize: 20),
                              SizedBox(
                                height: 10,
                              ),
                              Widgets.text(
                                  'Bank Name: ${user.getUser.bankName}',
                                  color: secondaryColor),
                              SizedBox(
                                height: 10,
                              ),
                              Widgets.text(
                                  'Account Name: MoniWallet-${user.getUser.fullname}',
                                  color: secondaryColor),
                              SizedBox(
                                height: 10,
                              ),
                              Widgets.text(
                                  'Account Number: ${user.getUser.accountNumber}',
                                  color: secondaryColor),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Widgets.text('Amount'),
                      Widgets.input(amount, context,
                          type: TextInputType.number,
                          icondata: FontAwesomeIcons.moneyBillAlt),
                      Widgets.button('Fund Wallet Online', context, () {
                        if (!user.isloading) {
                          if (amount.text == '') {
                            return Widgets.snackbar(msg: "Amount is required");
                          }
                          var minFund =
                              user.getUser.settings['min_fund'].toString();
                          if (int.parse(amount.text) < int.parse(minFund)) {
                            return Widgets.snackbar(
                                msg: "Minimum Allowed amount is $minFund");
                          }
                          return checkOut(
                            context,
                            user: user,
                            amount: int.parse(amount.text),
                          );
                        }
                      }),
                    ],
                  ),
                ));
          }),
        ));
  }
}
