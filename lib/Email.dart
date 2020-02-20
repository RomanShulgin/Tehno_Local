import 'package:flutter/material.dart';
import 'package:flutter_cache_store/flutter_cache_store.dart';
import 'HTTPExchange.dart';
import 'globals.dart' as globals;
import 'styledwidgets.dart';
import 'dart:convert';
import 'Alarms.dart';
import 'main.dart';

class listGroups extends StatefulWidget {
  @override
  createState() => new listGroupsState();
}

class listGroupsState extends State {
  bool isloading = true;
  var data;

  void redrawname() {
    var statescaffold = context.findAncestorStateOfType<InfoScreenState>();
    if (statescaffold != null) {
      statescaffold.setState(() {});
      print('перерисовываем имя');
    }
  }

  Future getEmailGroups() async {
    var post = new Post1c();
    post.metod = "missedmessages";
    post.input = '?messagesquantity=' + 100.toString();
    await post.HttpGet();
    var json = post.text;
    if (post.state == 'ok') {
      data = jsonDecode(json);
      isloading = false;
      int missedEmails = getParam(post.text, 'КоличествоПисем');
      if (missedEmails != globals.missedEmails)
        globals.missedEmails = missedEmails;
      setState(() {});
    } else
      return null;
  }

  List groupList() {
    List groups = ['Входящие', "Полученные", "Отправленные", "Исходящие"];
    var listGroups = List<Widget>();
    for (var group in groups) {
      listGroups.add(ChatButtonOff(
          group, (group == 'Входящие') ? globals.missedEmails.toString() : '0',
          () {
        globals.emailgroup = group;
        globals.tabredraw[3]();
        redrawname();
        Navigator.pop(context);
      }));
    }
    ;

    return listGroups;
  }

  Widget build(BuildContext context) {
    print('Bild drawer');
    if (isloading) {
      getEmailGroups();
      return LinearProgressIndicator();
    } else {
      return ListView(
        children: groupList(),
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

class EmailList extends StatefulWidget {
  //var struct;//содержит структуру с номером и датой
  //Order(this.struct);

  bool isloading = false;
  @override
  createState() => new EmailListState();
}

class EmailListState extends State<EmailList> {
  bool isloading = true;
  var chatjson;
  List messages = [];
  var _controller = ScrollController();
  final txt1 = TextEditingController();

  Future showChat() async {
    var post = new Post1c();
    var group;
    post.metod = 'getemails';
    post.input =
        '?messagesquantity=' + 20.toString() + "&group=" + globals.emailgroup;
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
    var mescolor = Colors.amber[50];
    var msstyle =
        (struct['НеРассмотрено']) ? FontWeight.bold : FontWeight.normal;
    var recipient = (globals.emailgroup == 'Входящие')
        ? struct['Отправитель']
        : struct['Получатель'];
    return new Container(
        padding: new EdgeInsets.fromLTRB(3.0, 0.0, 3.0, 0.0),
        margin: EdgeInsets.fromLTRB(2.0, 2.0, 3.0, 3.0),
        decoration: BoxDecoration(
          color: mescolor,
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
        child: Column(children: [
          Container(
              alignment: Alignment(-1.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    struct['Дата'],
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.fade,
                    style: TextStyle(color: Colors.green[900]),
                    textScaleFactor: 0.7,
                  ),
                  Text(recipient,
                      overflow: TextOverflow.fade,
                      style:
                          TextStyle(color: Colors.black, fontWeight: msstyle)),
                ],
              )),
          ContSmallBorder(Text(struct['Тема'],
              overflow: TextOverflow.fade,
              style: TextStyle(color: Colors.black, fontWeight: msstyle)))
        ]));

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
            //reverse: true,
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

  void redraw() {
    print('redraw почта');
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
    globals.tabredraw[3] = redraw;
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

class EmailForm extends StatefulWidget {
  String number = "";
  @override
  createState() => new EmailFormState();
}

class EmailFormState extends State<EmailForm> {
  bool isloading = true;
  var json;
  var data;
  var _controller = ScrollController();
  final txt1 = TextEditingController();

  Future showEmail() async {
    var post = new Post1c();
    var group;
    post.metod = 'getemail';
    post.input = '?number=' + widget.number;
    await post.HttpGet();
    json = post.text;

    if (post.state == "error") {
      PopUpInfo("Почта", "Сообщение не найдено", context);
    } else {
      data = getParam(json, 'Сообщениe');
    }
    isloading = false;
    setState(() {});
  }

  Widget message(struct) {
    var mescolor = Colors.amber[50];
    var msstyle =
        (struct['НеРассмотрено']) ? FontWeight.bold : FontWeight.normal;
    var recipient = (globals.emailgroup == 'Входящие')
        ? struct['Отправитель']
        : struct['Получатель'];
    return new Container(
        padding: new EdgeInsets.fromLTRB(3.0, 0.0, 3.0, 0.0),
        margin: EdgeInsets.fromLTRB(2.0, 2.0, 3.0, 3.0),
        decoration: BoxDecoration(
          color: mescolor,
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
        child: Column(children: [
          Container(
              alignment: Alignment(-1.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    struct['Дата'],
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.fade,
                    style: TextStyle(color: Colors.green[900]),
                    textScaleFactor: 0.7,
                  ),
                  Text(recipient,
                      overflow: TextOverflow.fade,
                      style:
                          TextStyle(color: Colors.black, fontWeight: msstyle)),
                ],
              )),
          ContSmallBorder(Text(struct['Тема'],
              overflow: TextOverflow.fade,
              style: TextStyle(color: Colors.black, fontWeight: msstyle)))
        ]));

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
            //reverse: true,
            controller: _controller,
            itemCount: messages.length,
            itemBuilder: (BuildContext ctxt, int index) =>
                message(messages[index])),
      ),
    );
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

  void redraw() {
    print('redraw почта');
    setState(() {
      isloading = true;
    });
    /*SchedulerBinding.instance.addPostFrameCallback((_) => _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: Duration(seconds: 1),
        curve: Curves.ease));*/
  }

  void initState() {}

  Widget build(BuildContext context) {
    //print('dialog');
    globals.tabredraw[3] = redraw;
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
