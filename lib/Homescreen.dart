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
  List warningList =List<Widget>();

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
    post.metod="basicinfo";
    post.input="";
    await post.HttpGet();
    name=post.text;
    setState(() {
      name=post.text;
      var mesMas=getParam(name, "МассивУведомлений");
      warningList.clear();
      for(var message in mesMas){
        warningList.add(LGroup(
             Text('Количество сообщений: '+message['Уведомления'][0]['КоличествоСообщений'].toString()),
            message['Название']
        ));
      }

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
                       Text(getParam(name, "ФИО")),
                      'Пользователь'),

                 Group(
                      Column(children: warningList) //Text('Ok')//
                      , 'Уведомления'),

                ])),


        ],);


  }
}

class HomeScreen extends StatefulWidget {
  @override
  createState() => new HomeScreenState();
}

