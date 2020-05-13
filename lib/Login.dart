import 'package:flutter/material.dart';
import 'HTTPExchange.dart';
import 'styledwidgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart' as globals;

class IdentForm extends StatefulWidget {
  @override
  createState() => new IdentFormState();
}

class IdentFormState extends State<IdentForm> {
  String user;
  String password;
  final txt1 = TextEditingController();
  final txt2 = TextEditingController();
  bool isloading = true;

  var name = 'Авторизуйтесь';
  bool storepass = false;

  Future<void> greeting(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Авторизация'),
          content: Text(name),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget futureText() {
    return new FutureBuilder<String>(builder: (context, snapshot) {
      return new Text(name);
    });
  }

  loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = (prefs.getString('user') ?? "");
    print('User found ' + user);
    if (txt1.text.isEmpty) {
      txt1.text = user;
    }
    ;
    password = (prefs.getString('password') ?? "");
    print('password found ' + password);
    if (password.isNotEmpty) {
      storepass = true;
    }
    ;
    if (txt2.text.isEmpty) {
      txt2.text = password;
    }
    print(storepass);
    isloading = false;
    setState(() {});
  }

  storeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('User stored ' + globals.user);
    prefs.setString('user', globals.user);
    if (storepass) {
      prefs.setString('password', globals.password);
    }
    ;
  }

  Future getData(ipadress) async {
    //var input;
    var post = new Post1c();
    globals.ipadress = ipadress;
    globals.authOK = false;
    post.metod = "auth";
    post.input = ''; //"?number=7719816961";
    post.user = txt1.text.toString().trim();
    if (txt2.text.trim() == '') {
      post.password = 'empty';
    } else {
      post.password = txt2.text.trim();
    }
    ;

    await post.HttpGet();
    name = post.text;
    await greeting(context);
    setState(() {
      if (globals.authOK) {
        globals.password = post.password;
        globals.user = post.user;
        globals.curdate = new DateTime.now();
        globals.datefrom = new DateTime(globals.curdate.year,
            globals.curdate.month, globals.curdate.day - 1);
        globals.dateto = globals.curdate;
        storeUser();
        Navigator.pushNamed(context, '/Home');
      } else {
        globals.password = '';
        globals.user = '';
      }
    });
  }

  Widget build(BuildContext context) {
    if (isloading) {
      loadUser();
    }
    ;

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(title: Text('Авторизация')),
        body: Center(
            child: ListView(children: [
          Group(TextFormField(controller: txt1), 'Пользователь'),
          //Divider(),
          Group(
              TextFormField(
                controller: txt2,
                obscureText: true,
              ),
              'Пароль'),
          Row(
            children: <Widget>[
              Checkbox(
                  value: storepass,
                  onChanged: (value) {
                    setState(() {
                      storepass = value;
                    });
                  }),
              Text(' сохранять пароль')
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RButton('Дома', () {
                  getData('46.34.155.26');
                }),
              ),
              RButton('В офисе', () {
                getData('192.168.1.251');
              })
            ],
          ),
          futureText(),
          LGroup(
              Column(
                children: <Widget>[
                  Row(children: <Widget>[
                    Icon(Icons.phone),
                    Expanded(
                        child: LightButton('+7 (495) 308-00-61', () {
                      launch("tel:" + '+7 (495) 308-00-61');
                    })),
                  ]),
                  Row(children: <Widget>[
                    Icon(Icons.email),
                    Expanded(
                        child: LightButton('sale@tehno-parts.ru', () {
                      launch("mailto:" + 'sale@tehno-parts.ru');
                    })),
                  ]),
                  //Row(children: <Widget>[Icon(Icons.location_on),Expanded(child: Center(child: LightButton("Как к нам проехать (Я.Карты)", () {launch("yandexmaps://build_route_on_map?lat_to=55.53685594035359&lon_to=37.575195730163564" /*"yandexnavi://build_route_on_map?lat_to=55.53685594035359&amp;lon_to=37.575195730163564"*/);}) )),]),
                ],
              ),
              'Добро пожаловать в систему Технопартс:'),
        ])));
  }
}
