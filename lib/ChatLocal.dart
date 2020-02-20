import 'package:flutter/material.dart';
import 'package:flutter_cache_store/flutter_cache_store.dart';
import 'HTTPExchange.dart';
import 'globals.dart' as globals;
import 'styledwidgets.dart';
import 'dart:convert';
import 'package:flutter/scheduler.dart';
import 'main.dart';

class ChatLocal extends StatefulWidget {
  //var struct;//содержит структуру с номером и датой
  //Order(this.struct);

  bool isloading = false;
  @override
  createState() => new ChatLocalState();
}

class listLocalUsers extends StatefulWidget {
  @override
  createState() => new listLocalUsersState();
}

class listLocalUsersState extends State {
  bool isloading = true;
  var data;

  void redrawname() {
    var statescaffold = context.findAncestorStateOfType<InfoScreenState>();
    if (statescaffold != null) {
      statescaffold.setState(() {});
      print('перерисовываем имя');
    }
  }

  Future getLocalUsers() async {
    var post = new Post1c();
    post.metod = "chatusers";
    post.input = '';
    await post.HttpGet();
    var json = post.text;
    if (post.state == 'ok') {
      data = jsonDecode(json);
      isloading = false;
      setState(() {});
    } else
      return null;
  }

  List userList(users) {
    users.sort((a, b) {
      if (a['Сообщения'] > b['Сообщения'])
        return -1;
      else if (a['Сообщения'] < b['Сообщения'])
        return 1;
      else if (a["Активен"])
        return -1;
      else if (b["Активен"]) return 1;
      return 0;
    });

    var listUsers = List<Widget>();
    for (var user in users) {
      if (user["Активен"] == false)
        listUsers
            .add(ChatButtonOff(user['Имя'], user['Сообщения'].toString(), () {
          globals.chatLocalUser = user['Имя'];
          globals.tabredraw[1]();
          redrawname();
          Navigator.pop(context);
        }));
      else
        listUsers
            .add(ChatButtonOn(user['Имя'], user['Сообщения'].toString(), () {
          globals.chatLocalUser = user['Имя'];
          globals.tabredraw[1]();
          redrawname();
          Navigator.pop(context);
        }));
    }
    return listUsers;
  }

  Widget build(BuildContext context) {
    print('Bild drawer');
    if (isloading) {
      getLocalUsers();
      return LinearProgressIndicator();
    } else {
      return ListView(
        children: userList(data),
      );
    }
    ;
  }
}

class Msg extends StatelessWidget {
  final child;
  final annotation;
  final pos;
  var lft, rt, align, msgcolor;
  Msg(this.child, this.annotation, this.pos);

  @override
  Widget build(BuildContext context) {
    if (pos == 'left') {
      lft = 2.0;
      rt = 30.0;
      align = Alignment(-1.0, 0.0);
      msgcolor = Colors.amber[50];
    } else {
      lft = 30.0;
      rt = 2.0;
      align = Alignment(1.0, 0.0);
      msgcolor = Colors.green[50];
    }
    return new Container(
        padding: new EdgeInsets.fromLTRB(3.0, 0.0, 3.0, 0.0),
        margin: EdgeInsets.fromLTRB(2.0, 2.0, 3.0, 2.0),
        decoration: BoxDecoration(
          color: msgcolor,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(1.0, 1.0),
              blurRadius: 1.0,
            ),
          ],
          border: Border.all(color: Colors.green[900], width: 1.0),
          borderRadius: BorderRadius.all(
            const Radius.circular(3.0),
          ),
        ),
        child: Container(
          child: Column(children: [
            Container(
                alignment: align,
                child: Text(annotation,
                    textScaleFactor: 0.8,
                    overflow: TextOverflow.fade,
                    style: TextStyle(color: Colors.green[900]))),
            Container(alignment: align, child: child)
          ]),
        ));
  }
}

class ChatLocalState extends State<ChatLocal> {
  bool isloading = true;
  var chatjson;
  List messages = [];
  var _controller = ScrollController();
  final txt1 = TextEditingController();

  Future showChat() async {
    var post = new Post1c();
    var recipient;
    recipient =
        (globals.chatLocalUser == '1. Общий чат') ? '' : globals.chatLocalUser;
    post.metod = "chatlist";
    post.input =
        '?messagesquantity=' + 20.toString() + "&recipient=" + recipient;
    globals.chatLocalUser;
    await post.HttpGet();
    chatjson = post.text;
    var mstring = getParam(chatjson, 'Сообщения');
    if (mstring == "") {
      messages = [];
    } else {
      messages = mstring;
    }
    isloading = false;
    setState(() {});
    await WidgetsBinding.instance.addPostFrameCallback(
        (_) => _controller.jumpTo(_controller.position.minScrollExtent));
    Future.delayed(Duration(milliseconds: 500), () {
      _controller.jumpTo(
        _controller.position.minScrollExtent,
      );
    });
    /*WidgetsBinding.instance.addPostFrameCallback((_) => controller.animateTo(
        controller.position.maxScrollExtent,
        curve: Curves.ease,
        duration: Duration(milliseconds: 10)));*/
  }

  Widget message(struct) {
    if (struct['Направление'] == 'Исходящее') {
      return Msg(
          Text(struct['Сообщение']),
          ((struct['Прочтено'] == 'истина') ? 'Прочтено' : '') +
              ' ' +
              struct['Период'],
          'right');
    } else {
      return Msg(Text(struct['Сообщение']),
          struct['Автор'] + ' ' + struct['Период'], 'left');
    }
    //return Text(struct['Сообщение']);
  }

  Widget messageBoard() {
    print(globals.screenSize.height);
    var bottomHeight = 100.0;
    var BHeight = globals.screenSize.height - bottomHeight - 200.0;

    return Flexible(
      child: Container(
        padding: new EdgeInsets.fromLTRB(3.0, 0.0, 3.0, 0.0),
        margin: EdgeInsets.fromLTRB(2.0, 2.0, 3.0, 3.0),
        //constraints: BoxConstraints.expand(),//BoxConstraints.expand(height:BHeight),
        decoration: BoxDecoration(
          color: Colors.amber[50],
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(1.0, 1.0),
              blurRadius: 1.0,
            ),
          ],
          border: Border.all(color: Colors.green[900], width: 1.0),
          borderRadius: BorderRadius.all(
            const Radius.circular(3.0),
          ),
        ),
        child: ListView.builder(
            reverse: true,
            controller: _controller,
            itemCount: messages.length,
            itemBuilder: (BuildContext ctxt, int index) =>
                message(messages[index])),
      ),
    );
  }

  Future sendMessage(message) async {
    var post = new Post1c();
    post.metod = "sendmessage";
    post.input = '?messagesquantity=' +
        20.toString() +
        '&recipient=' +
        globals.chatLocalUser;
    await post.HttpPost(message);
    var jsont = post.text;
    if (post.state == 'ok') {
      var data = jsonDecode(jsont);
      var mstring = getParam(jsont, 'Сообщения');
      if (mstring == "") {
        messages = [];
      } else {
        messages = mstring;
        txt1.clear();
      }
    }
    setState(() {
      isloading = true;
    });
    /*SchedulerBinding.instance.addPostFrameCallback((_) => _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: Duration(seconds: 1),
        curve: Curves.ease));*/
  }

  Widget inputField() {
    return Container(
      //color: Colors.green,
      alignment: Alignment.bottomCenter,
      child: new Row(children: [
        Expanded(
            child: ContSmallBorder(
          TextFormField(
            controller: txt1,
            keyboardType: TextInputType.multiline,
            maxLines: 2,
          ),
          //width: 20.0
        )),
        IconButton(
          icon: Icon(
            Icons.send,
            color: Colors.green,
            size: 35.0,
          ),
          onPressed: () {
            sendMessage(txt1.value.text);
          },
        )
      ]),
    );
  }

  void redrawchat() {
    print('redraw свои');
    setState(() {
      isloading = true;
    });
    /*SchedulerBinding.instance.addPostFrameCallback((_) => _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: Duration(seconds: 1),
        curve: Curves.ease));*/
  }

  void initState() {
    /*SchedulerBinding.instance.addPostFrameCallback((_) => _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: Duration(seconds: 1),
        curve: Curves.ease));*/
    Timer.periodic(Duration(seconds: 50), (timer) {
      MissedMessages();
    });
  }

  Future MissedMessages() async {
    if (globals.missedMessages > 0) {
      showChat();
      setState(() {});
      //redraw();
    }
  }

  Widget build(BuildContext context) {
    //print('dialog');
    globals.tabredraw[1] = redrawchat;
    //Timer(Duration(seconds: 10),MissedMessages);

    if (isloading) {
      showChat();
      return LinearProgressIndicator();
    } else {
      return Column(
        children: <Widget>[messageBoard(), inputField()],
      );
    }
    ;
  }
}
