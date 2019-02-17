import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'styledwidgets.dart';
import 'Forms.dart';

import 'globals.dart' as globals;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {'/': (BuildContext context) => IdentForm(),
        '/second': (BuildContext context) => InfoScreen()
      },
      debugShowCheckedModeBanner: false,
      title: 'Технопартс',
      theme: ThemeData(primarySwatch: Colors.orange, fontFamily: 'Xolonium',
        textTheme: TextTheme(
            button: TextStyle(fontSize: 18.0, letterSpacing: 0.0),
            body1: TextStyle(fontSize: 18.0),
          //body2: TextStyle(fontSize: 20.0),
        ),

      ),
    );
  }
}


class MyBody extends StatelessWidget {

  MyBody();

  Widget build(BuildContext context) {
     return new ContP(new HomeScreen());
    //);

  }
}

class InfoScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new Icon(Icons.menu),
        title: Text(globals.firm),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
          new IconButton(
            icon: new Icon(Icons.monetization_on),
            onPressed: () {},
          )
        ],
      ),
      body: new MyBody(

      ),

      bottomNavigationBar: new BottomNavigationBar(items: [
        new BottomNavigationBarItem(
          icon: new Icon(Icons.home),
          title: new Text("Home"),
        ),
        new BottomNavigationBarItem(
          icon: new Icon(Icons.search),
          title: new Text("Search"),
        )
      ]),
    );
  }
}
