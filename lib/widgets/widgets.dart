import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';
import 'package:moniwallet/value.dart';

class Widgets {

  static input( TextEditingController controller, { String hintText='Type something here', TextInputType type=TextInputType.text, bool spaced=true }){
    return Container(
      height: 54,
      margin: EdgeInsets.symmetric(vertical: spaced?15:0 ),
      decoration: BoxDecoration(
        color: Color(0xfff2f2f2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder( borderRadius: BorderRadius.circular(6) ),
          contentPadding: EdgeInsets.all(17),
        ),
        controller: controller,
        keyboardType: type,
        obscureText: type==TextInputType.visiblePassword?true:false,
      ),
    );
  }

  static button( String text, Function action, { bool spaced=true, Color color=Colors.lightBlueAccent, Color textColor=Colors.black } ){
    return Container(
      height: 54,
      margin: EdgeInsets.symmetric(vertical: spaced?15:0 ),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: color,
        child: Text( text, style: TextStyle(color: textColor), ),
        onPressed: action,
      ),
    );
  }

  static waiting( BuildContext context, { Function task, Function whenComplete } ){

    showDialog(
      context: context,
      builder: (context){
        return Scaffold(
          backgroundColor: Colors.black.withOpacity(.1),
          body: SizedBox(
            height: 10,
            child: LinearProgressIndicator(),
          ),
        );
      },
    ).then((value){
      if( whenComplete!=null ){
        whenComplete();
      }
    });

    if( task!=null ){
      Future.microtask((){
        return task();
      }).then((status){
        if( status!=false ){
          Navigator.pop(context);
        }
      });
    }

  }

  static popup( BuildContext context, String text ){
    showDialog(
      context: context,
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(.05),
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
            ),
            height: 120,
            width: 220,
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Text( text, softWrap: true,),
                ),
                SizedBox(height: 20,),
                FlatButton(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: primaryColor),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text( 'CLOSE', style: TextStyle(color: primaryColor), ),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static coloredPage( BuildContext context, Widget widget ){
    var wd = MediaQuery.of(context).size.width+50;

    return Stack(
      children: <Widget>[
        Container( color: whiteColor, ),
        Positioned(
          left: 0, right: -50,
          top: 0, height: 270,

          child: Container(
            width: wd,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only( bottomRight: Radius.elliptical(wd, 150)),
            ),
          ),
        ),
        widget
      ],
    );
  }

  static drawer(){
    return Container(
      width: 250,
      child: GFDrawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('Matnex Mix'),
              accountEmail: Text('matnex@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/img/logo.png'),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(image: AssetImage('assets/img/background (2).jpg')),
              ),
            ),

            ListTile(
              leading: Icon( FontAwesomeIcons.home, size: 21, ),
              title: Text('Home'),
              onTap: (){

              },
            ),
            ListTile(
              leading: Icon( FontAwesomeIcons.history, size: 21, ),
              title: Text('Transaction History'),
              onTap: (){
                
              },
            ),
            ListTile(
              leading: Icon( FontAwesomeIcons.creditCard, size: 21, ),
              title: Text('Deposit'),
              onTap: (){
                
              },
            ),
            ListTile(
              leading: Icon( FontAwesomeIcons.headphonesAlt, size: 21, ),
              title: Text('Support'),
              onTap: (){
                
              },
            ),
            ListTile(
              leading: Icon( FontAwesomeIcons.powerOff, size: 21, ),
              title: Text('Sign Out'),
              onTap: (){
                
              },
            ),
          ]
        ),
      ),
    );
    /*return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('Matnex Mix'),
            accountEmail: Text('matnex@gmail.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/img/logo.png'),
            ),
            decoration: BoxDecoration(
              color: primaryColor
            ),
          ),

          ListTile(
            leading: Icon( FontAwesomeIcons.home, size: 21, ),
            title: Text('Home'),
            onTap: (){

            },
          ),
          ListTile(
            leading: Icon( FontAwesomeIcons.history, size: 21, ),
            title: Text('Transaction History'),
            onTap: (){
              
            },
          ),
          ListTile(
            leading: Icon( FontAwesomeIcons.creditCard, size: 21, ),
            title: Text('Deposit'),
            onTap: (){
              
            },
          ),
          ListTile(
            leading: Icon( FontAwesomeIcons.headphonesAlt, size: 21, ),
            title: Text('Support'),
            onTap: (){
              
            },
          ),
          ListTile(
            leading: Icon( FontAwesomeIcons.powerOff, size: 21, ),
            title: Text('Sign Out'),
            onTap: (){
              
            },
          ),
        ]
      ),
    );*/
  }
  
}