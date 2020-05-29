import 'package:flutter/material.dart';
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
  @override
  void initState() {
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
            return Center(
              child: Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: MediaQuery.of(context).size.height / 2,
                child: Card(
                  color: primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Widgets.text(
                            "Fund your wallet by transfering to the account details below, the account is unique to your wallet.",
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
                        Widgets.text('Bank Name: ${user.getUser.bankName}',
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
              ),
            );
          }),
        ));
  }
}
