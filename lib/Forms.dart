import 'package:flutter/material.dart';
import 'HTTPExchange.dart';
import 'styledwidgets.dart';
import 'dart:convert';
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

  var name = 'Авторизуйтесь';

  Future<void> greeting (BuildContext context) {
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
    return new FutureBuilder<String>(
        builder: (context, snapshot) {
          return new Text(name);
        }
    );
  }

  loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = (prefs.getString('user') ?? "");
    print('User found '+user);
    if(txt1.text.isEmpty){
      txt1.text=user;
    }
  }

  storeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('User stored '+globals.user);
    prefs.setString('user',globals.user);
  }


  Future getData(input) async {
    //var input;
    var post = new Post1c();
    globals.authOK=false;
    post.metod = "auth";
    post.input = input; //"?number=7719816961";
    post.user=txt1.text.toString().trim();
    if(txt2.text.trim()=='')
      {post.password='empty';}
    else
      {post.password=txt2.text.trim();};

    await post.HttpGet();
    name = post.text;
    await greeting(context);
    setState(() {
      if (globals.authOK){
        globals.password=post.password;
        globals.user=post.user;
        storeUser();
        Navigator.pushNamed(context, '/second');
      }
      else {
        globals.password='';
        globals.user='';
      }

    });
  }

  Widget build(BuildContext context) {
    loadUser();
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(title: Text('Авторизация')),
        body:
        Center(child:
          ContP(
              ListView(
                  children: [
                    Text('Пользователь'),
                    TextFormField(controller: txt1),
                    Divider(),
                    Text('Пароль'),
                    TextFormField(controller: txt2),
                    RButton('Войти', (){getData(''); }),
                    futureText(),
                  ])
          ),
        )
    );

  }
}

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
    setState(() {
      name=post.text;

    });
  }

  Widget build(BuildContext context) {
    return
          Column(children: <Widget>[
          new Row(children: [
            new Column(children: [
              Text('Контрагент'),
              Text('Тип цены'),
              Text('Баланс', textDirection: TextDirection.ltr),
            ],
            ),
            new Column(children: [
              Text('Контрагент'),
              Text('Тип цены'),
              Text('Баланс'),
            ]),
            new Column(children: [
              IconButton(
                onPressed: () {getData('');},
                icon: Icon(Icons.cached),
                color: Colors.red),

              Text('Тип цены'),
              Text('Баланс'),
            ]),
          ],),
          new Row(
              children: [
                futureText(),
              ]
          ),
        ],);


  }
}

class HomeScreen extends StatefulWidget {
  @override
  createState() => new HomeScreenState();
}


