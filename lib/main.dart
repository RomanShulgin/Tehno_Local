import 'package:flutter/material.dart';
import 'package:flutter_cache_store/flutter_cache_store.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'styledwidgets.dart';
import 'Forms.dart';
import 'Homescreen.dart';
import 'PriceDialog.dart';
import 'Contacts.dart';
import 'Balance.dart';
import 'Order.dart';
import 'Catalog.dart';
import 'Basket.dart';
import 'Chat.dart';

import 'globals.dart' as globals;

void main() => runApp(MyApp());

Future getStoreInstance() async
{ if(globals.storeSet==false){
  CacheStore.setPolicy(LRUCachePolicy(maxCount: 200));
  CacheStore store = await CacheStore.getInstance();
  globals.store=store;
  globals.storeSet=true;}
  return globals.store;
}

class LRUCachePolicy extends LessRecentlyUsedPolicy {
  LRUCachePolicy({int maxCount}) : super(maxCount: maxCount);

  @override
  String generateFilename({final String key, final String url}) => key; // use key as the filename

}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    globals.currentcatalog=globals.baseCatalog;//основа

    getStoreInstance();
   // globals.store=store;
    return MaterialApp(
      routes: {'/': (BuildContext context) => IdentForm(),
        '/Home': (BuildContext context) => InfoScreen(),
        '/Price': (BuildContext context) => PriceDialog(),
        '/Balance': (BuildContext context) => Balance(),
        '/Contacts': (BuildContext context) => Contacts(),
        '/Order': (BuildContext context) => Order(),
        '/Catalog': (BuildContext context) => Catalog(),
        '/Basket': (BuildContext context) => Basket(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Технопартс',
      theme: ThemeData(primarySwatch: Colors.orange, //fontFamily: 'Xolonium',
        textTheme: TextTheme(
            button: TextStyle(fontSize: 16.0, letterSpacing: 0.0),
            body1: TextStyle(fontSize: 16.0),
          //body2: TextStyle(fontSize: 20.0),
        ),

      ),
    );
  }
}


class MyBody extends StatelessWidget {

  MyBody();

  Widget build(BuildContext context) {
     return new HomeScreen();
    //);

  }
}

class InfoScreen extends StatefulWidget{
  @override
  createState() => new InfoScreenState();
}

class basketIcon extends StatefulWidget{
  @override
  createState() => new basketIconState();
}

class basketIconState extends State<basketIcon>{
  void redraw() {

    setState(() {});
  }
  Widget build(BuildContext context) {
    var basketcolor,amount;
    globals.redrawBasketIcon=redraw;

    amount=0;
    basketcolor=Colors.black;
    if (globals.basket.isNotEmpty)
    {
    for (var el in globals.basket) {
      amount = amount + el['amount'];
    };
    if(amount>0)
      basketcolor=Colors.green;
    }

    else
      basketcolor=Colors.black;
    /*print("В корзине "+globals.basket.last.toString());*/

  if (amount>0){
    print('корзина перерисовывается '+amount.toString());
  return Stack(
      alignment: Alignment.centerRight,
      children:[
  IconButton(
    color: basketcolor,
    icon: new Icon(Icons.shopping_cart),
    onPressed: () {Navigator.pushNamed(context, '/Basket');},
    ),
  Positioned(child:Text(amount.toString()),right: 3.0,)
  ]
  );}
  else{
    return Stack(
        alignment: Alignment.centerRight,
        children:[
          IconButton(
            color: basketcolor,
            icon: new Icon(Icons.shopping_cart),
            onPressed: () {Navigator.pushNamed(context, '/Basket');},
          ),
        ]
    );
  }
  }
}


class InfoScreenState extends State<InfoScreen>{


  List<Widget> tabs=[MyBody(),OrderList(globals.datefrom,globals.dateto),Catalog(),Chat()];

  void onTabTapped(int index) {
    setState(() {
      globals.currentIndex = index;
    });
  }

  Future<bool> logoffDialog(){
    if((globals.currentIndex==2)&&(globals.currentcatalog!= globals.baseCatalog)){
      return Future.value(true);
    }
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          //title: new Text("Номенклатура"),
          content: Text('Вы хотите выйти из приложения?'),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Да"),
              onPressed: () => Navigator.of(context).pop(true)
              ,
            ),
            new FlatButton(
              child: new Text("Нет"),
              onPressed: () {
                return Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var basketcolor,amount;
    globals.screenSize=MediaQuery.of(context).size;
    basketcolor=Colors.black;
    if (globals.basket.isNotEmpty)
      { amount=0;
        for (var el in globals.basket) {
          amount = amount + el['amount'];
        };
        if(amount>0)
        basketcolor=Colors.green;
      }

    else
      basketcolor=Colors.black;
    /*print("В корзине "+globals.basket.last.toString());*/
    return WillPopScope(
      onWillPop: logoffDialog,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: new Icon(Icons.menu),
        title: Text(globals.firm),
        actions: <Widget>[
          new basketIcon(),
          /*new IconButton(
            color: basketcolor,
            icon: new Icon(Icons.shopping_cart),
            onPressed: () {Navigator.pushNamed(context, '/Basket');},
          ),*/
          new IconButton(
            icon: new Icon(Icons.autorenew),
            onPressed: () {
              //print('renew');
              globals.tabredraw[globals.currentIndex]();
              },
          )
        ],
      ),
      body: tabs[globals.currentIndex],

      bottomNavigationBar: new BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: globals.currentIndex,
          type: BottomNavigationBarType.fixed,
          items: [
        new BottomNavigationBarItem(
          icon: new Icon(Icons.home),
          title: new Text("Главная"),
        ),
        new BottomNavigationBarItem(
          icon: new Icon(Icons.list),
          title: new Text("Заказы"),

        ),
        new BottomNavigationBarItem(
        icon: new Icon(Icons.category),
        title: new Text("Каталог"),
        ),
        new BottomNavigationBarItem(
          icon: new Icon(Icons.chat_bubble_outline),
          title: new Text("Чат"),
          //backgroundColor: Colors.green
        )
      ]),
    ));
  }
}
