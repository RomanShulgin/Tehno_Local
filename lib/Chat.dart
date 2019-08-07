import 'package:flutter/material.dart';
import 'HTTPExchange.dart';
import 'globals.dart' as globals;
import 'styledwidgets.dart';
import 'dart:convert';

class Chat extends StatefulWidget {
  //var struct;//содержит структуру с номером и датой
  //Order(this.struct);

  bool isloading = false;
  @override
  createState() => new ChatState();
}

class ChatState extends State<Chat> {
  bool isloading = true;
  var json;
  final txt1= TextEditingController();

  Future showCatalog(current) async {
    var post = new Post1c();
    var ParaMap;
    var paramstring='';
    if (globals.filters.containsKey(current)) {
      //параметры уже задавались
      ParaMap = globals.filters[current];
      int num=0;
      for(var el in ParaMap.values){
        num++;
        if(el!=null)
          if(el.isNotEmpty)
            paramstring=paramstring+'Измерение'+num.toString()+"="+el+";";
      }

    }


    post.metod = "catalog";
    post.input = '?current=' + current + '&list=' +paramstring;
    await post.HttpGet();
    json = post.text;
    isloading = false;
    setState(() {});
  }

  Widget messageBoard(){
    return new LGroup(Text('ok'),'Чат');
  }

  Widget inputField(){
    return new Row(children:[
        Expanded(child:ContP(TextFormField(controller: txt1),
        //width: 20.0
        )),
        IconButton(
        icon: Icon(Icons.send),
    )
    ]);
  }


  void redraw(){
    print('redraw catalog');
    setState(() {isloading=true;

    });
  }


  Widget build(BuildContext context) {
    //print('dialog');
    globals.tabredraw[3]=redraw;
    if (isloading) {
      showCatalog(globals.currentcatalog);
      return LinearProgressIndicator();
    } else {
      return
          Column(
            children: <Widget>[
              messageBoard(),
              inputField()
            ],
          );
    }
    ;
  }
}
