import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moniwallet/value.dart';
import 'package:moniwallet/widgets/widgets.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  var username = TextEditingController();
  var password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        physics: BouncingScrollPhysics(),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded( child: Container() ),

              SizedBox(height: 20,),
              Icon(FontAwesomeIcons.userLock, size: 28, color: primaryColor,),
              SizedBox(height: 25,),
              Container(
                alignment: Alignment.center,
                child: Text('Moniwallet Account', style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold )),
              ),
              SizedBox(height: 30,),

              Widgets.input( username, hintText: 'Username' ),
              Widgets.input( password, hintText: '********', type: TextInputType.visiblePassword ),

              SizedBox(height: 10,),
              Widgets.button( 'LOGIN', (){
                Widgets.waiting(context, task: () async {
                  await Future.delayed(Duration(seconds: 3), () async {
                    return true;
                  });
                }, whenComplete: () async => 
                    await Widgets.popup(context, 'logged in successfully'));
              }),

              Expanded( child: Container() ),
            ],
          ),
        ),
      ),
    );
  }
}