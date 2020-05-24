import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moniwallet/value.dart';
import 'package:moniwallet/widgets/widgets.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Widgets.coloredPage(
      context,
      Scaffold(
        backgroundColor: Colors.transparent,
        drawer: Widgets.drawer(),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text( 'Moniwallet' ),
        ),

        body: ListView(
          padding: EdgeInsets.all(20),
          children: <Widget>[
            Container(
              height: 110,
              child: customContainer( '#200,000', 'My Wallet', FontAwesomeIcons.wallet ),
            ),
            SizedBox(height: 15),

            Container(
              height: 110,
              child: customContainer( '#10,500', 'Refferal Wallet', FontAwesomeIcons.user, color: Colors.deepOrangeAccent ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customContainer( String text, String subText, var icon, { Color color=Colors.orangeAccent } ){
    return Container(
      child: Card(
        elevation: 10,
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: <Widget>[
                    Text( subText, style: TextStyle( fontSize: 16, color: Colors.white.withOpacity(0.7) ), ),
                    SizedBox(height: 3,),
                    Text( text, style: TextStyle( fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white ), ),
                  ],
                ),
              ),
              SizedBox(width: 15,),
              Icon( icon, size: 40, ),
            ],
          ),
        ),
      ),
    );
  }
}