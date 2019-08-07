import 'package:flutter/material.dart';
import 'HTTPExchange.dart';
import 'styledwidgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'PriceDialog.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart' as globals;


class HomeScreenState extends State<HomeScreen> {

  int inn;
  String display;
  final txt1= TextEditingController();

  var name = 'Неопределено';

  Widget futureText(){
    return new FutureBuilder<String>(
        builder: (context, snapshot) {
          return new Text(name);
        }
    );
  }



  Future getData(input) async{
    //var input;
    var post=new Post1c();
    post.metod="baseinfo";
    post.input="";
    await post.HttpGet();
    name=post.text;
    setState(() {
      name=post.text;

    });
  }

  void redraw(){
    //print('order redraw');
    name = 'Неопределено';
    setState(() {

    });
  }

  Future showPriceInfo() async
  {
    Navigator.pushNamed(context, '/Price');
  }

  Future showBalance() async
  {
    Navigator.pushNamed(context, '/Balance');
  }

  Widget build(BuildContext context) {
    globals.tabredraw[0]=redraw;
    if(name=='Неопределено'){
      getData('');
      return LinearProgressIndicator();}
    return
      ListView(children: <Widget>[

            Center(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Group(
                       Text(getParam(name, "Контрагент")),
                      'Контрагент'),
                  Group(
                      Row(
                          children:
                          [Expanded(child: LightButton( getParam(name, "ТипЦен"),
                             () {showPriceInfo();},
                          )),
                          ]),
                          'Тип цен'),


                  Group(
                      Row(children: <Widget>[Expanded(child: LightButton(
                         getParam(name, "Баланс").toString(),  () {showBalance();},
                      )),

                      ]), 'Баланс'),
                  Group(
                      Column(children: <Widget>[
                        Row(children: <Widget>[Icon(Icons.person),Expanded(child: Center(child: Text(getParam(name, "СтрМенеджер")['Имя']) )),]),
                        Row(children: <Widget>[Icon(Icons.phone),Expanded(child: LightButton(getParam(name, "СтрМенеджер")['Телефон'], () {launch("tel:"+getParam(name, "СтрМенеджер")['Телефон']);}) ),]),
                        Row(children: <Widget>[Icon(Icons.email),Expanded(child: LightButton(getParam(name, "СтрМенеджер")['ЕМайл'], () {launch("mailto:"+getParam(name, "СтрМенеджер")['ЕМайл']);}) ),]),
                        Row(children: <Widget>[Icon(Icons.comment),Expanded(child: LightButton('Skype', () {launch("skype:"+getParam(name, "СтрМенеджер")['Скайп']);}) ),]),
                        Row(children: <Widget>[Icon(Icons.location_on),Expanded(child: LightButton("Контакты организации", () {Navigator.pushNamed(context, '/Contacts');}) ),]),
                        //Row(children: <Widget>[Icon(Icons.location_on),Expanded(child: Center(child: LightButton("Как к нам проехать (Я.Карты)", () {launch("yandexmaps://build_route_on_map?lat_to=55.53685594035359&lon_to=37.575195730163564" /*"yandexnavi://build_route_on_map?lat_to=55.53685594035359&amp;lon_to=37.575195730163564"*/);}) )),]),
                      ],)
                      , 'Менеджер'),
                ])),


        ],);


  }
}

class HomeScreen extends StatefulWidget {
  @override
  createState() => new HomeScreenState();
}

