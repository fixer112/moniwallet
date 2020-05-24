import 'package:flutter/material.dart';
import 'package:moniwallet/pages/app/home.dart';
import 'package:moniwallet/pages/auth/login.dart';

import '../../value.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), (){
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => Home(),
      ));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Card(
        color: primaryColor,
        elevation: 8,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: SizedBox(
                  width: 160,
                  height: 100,
                  child: FittedBox(
                    child: Image.asset( 'assets/img/logo.png' ),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            Text( 'Version: 1.0.0', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), ),
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}