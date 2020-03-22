import 'package:flutter/material.dart';
import 'package:flutter_cache_store/flutter_cache_store.dart';
import 'HTTPExchange.dart';
import 'globals.dart' as globals;
import 'styledwidgets.dart';
import 'dart:convert';
import 'Alarms.dart';
import 'main.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:open_file/open_file.dart';

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
    List groups = ['Входящие', "Отправленные", "Удаленные", "Исходящие"];
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
    var mescolor = Colors.white;
    var msstyle =
        (struct['НеРассмотрено']) ? FontWeight.bold : FontWeight.normal;
    var recipient = (globals.emailgroup == 'Входящие')
        ? struct['Отправитель']
        : struct['Получатель'];
    Widget iconHaveFiles =
        (struct['ЕстьВложения']) ? Icon(Icons.assignment) : new Container();
    struct['type'] = globals.emailgroup;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/Email', arguments: struct);
      },
      child: Container(
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
                    Row(
                      children: <Widget>[
                        iconHaveFiles,
                        Flexible(
                          child: Text(recipient,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                  color: Colors.black, fontWeight: msstyle)),
                        ),
                      ],
                    ),
                  ],
                )),
            ContSmallBorder(Text(struct['Тема'],
                overflow: TextOverflow.fade,
                style: TextStyle(color: Colors.black, fontWeight: msstyle)))
          ])),
    );

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
          color: Colors.amber[100],
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
        children: <Widget>[messageBoard()],
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
  var emaitype; // тип почтового сообщения, входящее, исходящее, пересылаемое или ответное
  var json;
  var data;
  var struct;
  var _controller = ScrollController();
  WebViewController _webViewController;
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
      data = getParam(json, 'Сообщение');
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

  openFile(filename) async {
    var store = globals.store;
    var user = globals.user;
    var password = globals.password;
    var number = data['Номер'];
    var imageaddr =
        'http://46.34.155.26/Tehno/hs/GetBasicInfo/$user/$password/getfile/?number=$number&filename=$filename';
    final file = await store.getFile(imageaddr, key: number + filename);
    var lenght = await file.length();
    OpenFile.open(
      file.path, /*type: "application/pdf"*/
    );
    /*var post = new Post1c();
    post.metod = "getfile";
    post.input = '?number=' + data['Номер'] + '&filename' + filename;
    await post.HttpGet();
    var file = post.text;
    if (post.state == 'ok') {
      data = jsonDecode(json);
      isloading = false;
      int missedEmails = getParam(post.text, 'КоличествоПисем');
      if (missedEmails != globals.missedEmails)
        globals.missedEmails = missedEmails;
      setState(() {});
    } else
      return null;*/
  }

  openFiles() {
    List<Widget> Buttons = List();
    for (var fil in data['Вложения'].values) {
      Buttons.add(LightButton(fil, () {
        openFile(fil);
      }));
    }
    PopUpFiles('Выберите файл', Buttons, context);
  }

  Widget fileList() {
    if (data['ЕстьВложения']) {
      return InkWell(
        child: ContSmallBorder(Row(children: <Widget>[
          Icon(Icons.assignment),
          Text('Вложений: ' + data['Вложено'].toString())
        ])),
        onTap: openFiles,
      );
    } else {
      return Container();
    }
  }

  Widget emailBody() {
    var body;
    if (data['ФорматТекста'] == 'HTML') {
      //Text('Test');

      body = WebView(
        onWebViewCreated: (WebViewController wvc) {
          _webViewController = wvc;
          loadHTML();
        },
        initialUrl: '',
      );
    } else
      body = SingleChildScrollView(
        child: ContSmallBorder(Text(data['ТекстПисьма'])),
      );

    return Expanded(child: body);
  }

  loadHTML() async {
    _webViewController.loadUrl(Uri.dataFromString(data['ТекстПисьма'],
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  /*class BottomBar extends StatelessWidget{
    if (struct['type'] == 'Входящие') {
      return Row(
        children: <Widget>[
          LightButton('Ответить', () {
            print('showBottom');
            showBottomSheet(
                context: context,
                builder: (context) => Container(
                      color: Colors.red,
                    ));
          })
        ],
      );
    }
  }*/

  Widget build(BuildContext context) {
    //print('dialog');
    struct = ModalRoute.of(context).settings.arguments;
    widget.number = struct['Номер'];
    globals.tabredraw[3] = redraw;
    //Timer(Duration(seconds: 10),MissedMessages);

    if (isloading) {
      showEmail();
      return LinearProgressIndicator();
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text(struct['type']),
          ),
          body: Column(children: <Widget>[
            LGroup(Text(data['Отправитель']),
                "Отправитель" + ' ' + data['ДатаОтправления']),
            LGroup(Text(data['Получатель']),
                "Получатель" + ' ' + data['ДатаПолучения']),
            LGroup(Text(data['Тема']), "Тема"),
            fileList(),
            emailBody()
          ]),
          bottomNavigationBar: BottomAppBar(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: bottomBar(data['Номер']),
            ),
          ));
    }
    ;
  }
}

class bottomBar extends StatelessWidget {
  bottomBar(this.number);
  String number;
  final txt1 = TextEditingController();
  SendReply(context) async {
    var post = new Post1c();
    post.metod = "sendreply";
    var jsontext = txt1.text; //json.encode(globals.basket);
    print(jsontext);
    post.input = '?number=' + number;
    await post.HttpPost(jsontext);
    var jsont = post.text;
    if (post.state == 'ok') {
      var data = jsonDecode(jsont)['Сообщение'];
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Отправлен ответ'),
            content: Text('Отправлено ответное письмо №' + data['Номер']),
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
  }

  Widget build(context) {
    return LightButton('Написать ответ', () {
      print('showBottom');
      showBottomSheet(
          context: context,
          builder: (context) => Column(
                children: <Widget>[
                  Group(
                      TextFormField(
                        controller: txt1,
                        maxLines: null,
                        //expands: true,
                        minLines: null,
                      ),
                      'Текст ответа'),
                  Row(
                    children: <Widget>[
                      LightButton('Отправить', () {
                        SendReply(context);
                        //Navigator.pop(context);
                      }),
                      LightButton('Закрыть', () {
                        Navigator.pop(context);
                      })
                    ],
                  )
                ],
              ));
    });
  }
}
