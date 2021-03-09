import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../global.dart';
import '../../providers/user.dart';
import '../../value.dart';
import '../../widgets/drawer.dart';
import '../../widgets/widgets.dart';
import 'package:provider/provider.dart';

class Fund extends StatefulWidget {
  @override
  _FundState createState() => _FundState();
}

class _FundState extends State<Fund> {
  var amount = TextEditingController();
  @override
  void initState() {
    //PaystackPlugin.initialize(publicKey: publicKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: whiteColor,
          drawer: DrawerWidget(),
          appBar: Widgets.appbar('Fund Wallet', context),
          body: Consumer<UserModel>(builder: (context, user, child) {
            var minFund = user.getUser?.settings['min_fund'].toString() ?? '0';
            var maxFund = user.getUser?.settings['max_fund'].toString() ?? '0';
            bool enablePayment =
                user.getUser?.settings['enable_online_payment'];

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
                                  "Transfer charges of ${user.getUser?.settings['transfer_fee']}% applies.",
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
                                  'Bank Name: ${user.getUser?.bankName}',
                                  color: secondaryColor),
                              SizedBox(
                                height: 10,
                              ),
                              Widgets.text(
                                  'Account Name: MoniWallet-${user.getUser?.fullname}',
                                  color: secondaryColor),
                              SizedBox(
                                height: 10,
                              ),
                              Widgets.text(
                                  'Account Number: ${user.getUser?.accountNumber}',
                                  color: secondaryColor),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (enablePayment) Widgets.text('Amount'),
                      if (enablePayment)
                        Widgets.input(amount, context,
                            type:
                                TextInputType.numberWithOptions(decimal: true),
                            icondata: FontAwesomeIcons.moneyBillAlt),
                      if (enablePayment)
                        Widgets.button('Fund Wallet Online', context, () {
                          if (!user.isloading) {
                            if (amount.text == '') {
                              return Widgets.snackbar(
                                  msg: "Amount is required");
                            }

                            if (double.parse(amount.text) <
                                int.parse(minFund)) {
                              return Widgets.snackbar(
                                  msg: "Minimum Allowed amount is $minFund");
                            }
                            if (double.parse(amount.text) >
                                int.parse(maxFund)) {
                              return Widgets.snackbar(
                                  msg: "Maximum Allowed amount is $maxFund");
                            }
                            return checkOut(
                              context,
                              user: user,
                              amount: double.parse(amount.text),
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
