import 'package:flutter/material.dart';
import 'package:flutter_cache_store/flutter_cache_store.dart';
import 'HTTPExchange.dart';
import 'globals.dart' as globals;
import 'styledwidgets.dart';
import 'dart:convert';
import 'package:flutter/scheduler.dart';

class Chat extends StatefulWidget {
  //var struct;//содержит структуру с номером и датой
  //Order(this.struct);

  bool isloading = false;
  @override
  createState() => new ChatState();
}

class Msg extends StatelessWidget {
  final child;
  final annotation;
  final pos;
  var lft,rt,align,msgcolor;
  Msg(this.child,this.annotation,this.pos);

  @override
  Widget build(BuildContext context) {
    if(pos=='left'){
      lft=2.0;
      rt=30.0;
      align=Alignment(-1.0, 0.0);
      msgcolor=Colors.amber[50];
    }
    else{
      lft=30.0;
      rt=2.0;
      align=Alignment(1.0, 0.0);
      msgcolor=Colors.green[50];
    }
    return new Container(
        padding: new EdgeInsets.fromLTRB(3.0, 0.0, 3.0, 0.0),
        margin: EdgeInsets.fromLTRB(2.0, 2.0, 3.0, 2.0),
        decoration: BoxDecoration(
          color: msgcolor,
          boxShadow:[
            BoxShadow(
              color: Colors.black,
              offset: Offset(1.0, 1.0),
              blurRadius: 1.0,
            ),
          ] ,
          border: Border.all(color: Colors.green[900], width: 1.0
          ),
          borderRadius: BorderRadius.all(
            const Radius.circular(3.0),
          ),
        ),
        child: Container(
          child: Column(children:[
            Container(alignment: align,child: Text(annotation,textScaleFactor: 0.8,overflow: TextOverflow.fade,style:TextStyle(color: Colors.green[900]))),
            Container(alignment: align,child: child)]),
        )
    );
  }
}



class ChatState extends State<Chat> {
  bool isloading = true;
  var chatjson;
  List messages=[];
  var controller = ScrollController();
  final txt1= TextEditingController();

  Future showChat() async {
    var post = new Post1c();

    post.metod = "chatlist";
    post.input = '?messagesquantity=' + 100.toString();
    await post.HttpGet();
    chatjson = post.text;
    var mstring=getParam(chatjson,'Сообщения');
    if(mstring==""){
      messages=[];
    }
    else{
      messages=mstring;
    }
    isloading = false;
    setState(() {});
    SchedulerBinding.instance.addPostFrameCallback((_) => controller.jumpTo(controller.position.maxScrollExtent));
  }



  Widget message(struct){
    if(struct['Чат']=='Обычный'){
      return Msg(Text(struct['Сообщение']),struct['Автор']+' '+struct['Период'],'right');
    }
    else{
      return Msg(Text(struct['Сообщение']),struct['Автор']+' '+struct['Период'],'left');
    }
    //return Text(struct['Сообщение']);
  }

  Widget messageBoard(){
    print(globals.screenSize.height);
    var bottomHeight=100.0;
    var BHeight=globals.screenSize.height-bottomHeight-200.0;


    return Flexible(
      child: Container(
            padding: new EdgeInsets.fromLTRB(3.0, 0.0, 3.0, 0.0),
            margin: EdgeInsets.fromLTRB(2.0, 2.0, 3.0, 3.0),
            //constraints: BoxConstraints.expand(),//BoxConstraints.expand(height:BHeight),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              boxShadow:[
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(1.0, 1.0),
                  blurRadius: 1.0,
                ),
              ] ,
              border: Border.all(color: Colors.green[900], width: 1.0
              ),
              borderRadius: BorderRadius.all(
                const Radius.circular(3.0),
              ),
            ),
        child: ListView.builder(
            controller: controller,
            itemCount: messages.length,
            itemBuilder: (BuildContext ctxt, int index) => message(messages[index])) ,),
    );

  }

  Future sendMessage(message)async{
    var post=new Post1c();
    post.metod="sendmessage";
    post.input = '?messagesquantity=' + 100.toString();
    await post.HttpPost(message);
    var jsont=post.text;
    if (post.state == 'ok') {
      var data = jsonDecode(jsont);
      var mstring=getParam(jsont,'Сообщения');
      if(mstring==""){
        messages=[];
      }
      else{
        messages=mstring;
        txt1.clear();
      }
    }
    setState((){});
    SchedulerBinding.instance.addPostFrameCallback((_) => controller.animateTo(controller.position.maxScrollExtent, duration: Duration(seconds: 1),curve: Curves.ease));
  }

  Widget inputField(){
    return Container(
      //color: Colors.green,
      alignment: Alignment.bottomCenter,
      child: new Row(children:[
          Expanded(child:ContSmallBorder(TextFormField(controller: txt1, keyboardType: TextInputType.multiline, maxLines: 2,),
          //width: 20.0
          )),
          IconButton(
          icon: Icon(Icons.send,color: Colors.green,size: 35.0,),
            onPressed: (){sendMessage(txt1.value.text);},
      )
      ]),
    );
  }


  void redraw(){
    print('redraw catalog');

    setState(() {isloading=true;
    });
    SchedulerBinding.instance.addPostFrameCallback((_) => controller.animateTo(controller.position.maxScrollExtent, duration: Duration(seconds: 1),curve: Curves.ease));
  }

  void initState(){
    SchedulerBinding.instance.addPostFrameCallback((_) => controller.animateTo(controller.position.maxScrollExtent, duration: Duration(seconds: 1),curve: Curves.ease));
    Timer.periodic(Duration(seconds: 5),(timer){MissedMessages();});
  }

  Future MissedMessages()async{
    if(globals.missedMessages>0){
      showChat();
      setState(() {});
      //redraw();
    }
  }

  Widget build(BuildContext context) {
    //print('dialog');
    globals.tabredraw[3]=redraw;
    //Timer(Duration(seconds: 10),MissedMessages);

    if (isloading) {
      showChat();
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
