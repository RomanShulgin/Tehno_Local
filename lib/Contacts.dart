import 'package:flutter/material.dart';
import 'HTTPExchange.dart';
import 'styledwidgets.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

import 'globals.dart' as globals;





class Contacts extends StatelessWidget {
  bool isloading=true;
  var json;



  Widget build(BuildContext context)
  { print('Contacts');


  /*if (isloading) {
      loadContacts();
      return Scaffold(
          appBar: AppBar(title: Text('Контакты')),
          body:
        Column(children: <Widget>[LinearProgressIndicator(),
        RButton('Назад', (){Navigator.of(context).pop(); })
        ],
        )

    );
    }
    else {*/
  return new WebviewScaffold(
    appBar: AppBar(title: Text('Контакты')),
    url: 'http://tehno-parts.ru/about/contacts/index.php?app=true',
    withZoom: false,
    allowFileURLs: true,
    withLocalStorage: true,
    persistentFooterButtons: <Widget>[LightButton("Как к нам проехать (Я.Карты)", () {launch("yandexmaps://build_route_on_map?lat_to=55.53685594035359&lon_to=37.575195730163564" /*"yandexnavi://build_route_on_map?lat_to=55.53685594035359&amp;lon_to=37.575195730163564"*/);})],
  hidden: true,
  initialChild: Container(
  color: Colors.amber,
  child: const Center(child: Text('Подождите.....')))
  );

}
}
