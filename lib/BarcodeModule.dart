import 'package:flutter/cupertino.dart';

import 'HTTPExchange.dart';
import 'Alarms.dart';
import 'package:flutter/material.dart';
import 'styledwidgets.dart';
import 'globals.dart' as globals;
import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'Goods.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

class Barcode extends StatefulWidget {
  @override
  createState() => new BarcodeState();
}

class MainTab extends StatefulWidget {
  MainTabState createState() => new MainTabState();
}

class MainTabState extends State<MainTab> {
  String barcode = "";
  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  void redraw() {
    setState(() {});
  }

  Widget DocButton(data, icon) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: new RaisedButton(
        padding: new EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 3.0),
        //margin: EdgeInsets.fromLTRB(2.0, 2.0, 3.0, 3.0),
        color: Colors.amber[50],
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0)),
        onPressed: () {
          //print('doc ' + data);
          globals.curentbardoc = data['id'];
          globals.barcoderedraw(1);
          globals.currentBarIndex = 1;
          //redraw();
        },
        child: Column(
          children: <Widget>[icon, Text(data['name'])],
        ),
      ),
    );
  }

  Widget docsButtonList() {
    List<Widget> Reports = new List();
    List data = new List();
    data.add({'id': 'kp', 'name': 'КП'});
    data.add({'id': 'real', 'name': 'Реализации'});
    data.add({'id': 'retbyer', 'name': 'Возвраты покупателя'});
    data.add({'id': 'ordsup', 'name': 'Заказы поставщика'});
    data.add({'id': 'inv', 'name': 'Инвентаризация'});
    //data.add('КП');
    for (var el in data) {
      Reports.add(DocButton(
          el,
          new Icon(
            Icons.description,
            size: 30.0,
          )));
    }

    return Group(ButtonTab(2, Reports), 'Документы');
  }

  Widget build(BuildContext context) {
    globals.bartabredraw[0] = redraw;
    return ListView(children: [
      Text(barcode),
      RButton('Отсканировать', () {
        scan();
      }),
      docsButtonList(),
    ]);
    //);
  }
}

class DocTab extends StatefulWidget {
  DocTabState createState() => new DocTabState();
}

class DocTabState extends State<DocTab> {
  String barcode = "";
  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  void redraw() {
    setState(() {});
  }

  Widget build(BuildContext context) {
    globals.bartabredraw[1] = redraw;
    globals.currentBarIndex = 1;
    return DocList(globals.curentbardoc);
  }
}

class DocList extends StatefulWidget {
  final type;
  DocList(this.type);
  DocListState createState() => new DocListState();
}

class DocListState extends State<DocList> {
  bool isloading = true;
  var json;

  Future showDocList(datefrom, dateto) async {
    var post = new Post1c();
    post.metod = widget.type + "barlist";
    post.input = '?datefrom=' +
        formatDate(datefrom, [dd, '.', mm, '.', yy]) +
        '&dateto=' +
        formatDate(dateto, [dd, '.', mm, '.', yy]);
    await post.HttpGet();
    json = post.text;
    isloading = false;
    setState(() {});
  }

  List getDocs(strings) {
    var bordersList = new List<TableRow>();
    bordersList.add(
        TableRow(decoration: BoxDecoration(color: Colors.amber[50]), children: [
      TableCell(
          child: Column(children: [
        Text(
          '№',
          textScaleFactor: 1.0,
        ),
        Text(
          'Дата',
          textScaleFactor: 1.0,
        )
      ])),
      TableCell(
          child: Center(
        child: Text(
          'Контрагент',
          textScaleFactor: 1.0,
        ),
      )),
      TableCell(child: Center(child: Text('Сумма', textScaleFactor: 1.0))),
    ]));
    for (var doc in strings) {
      var color =
          doc['Подобран'] ? Colors.lightGreenAccent : Colors.transparent;
      bordersList.add(TableRow(children: [
        TableCell(
            child: InkWell(
          child: ContColorSmall(
              Column(
                children: <Widget>[
                  Text(doc['Номер'], textScaleFactor: 0.8),
                  Text(doc['Дата'])
                ],
              ),
              color),
          onTap: () {
            opendoc(doc);
          },
        )),
        TableCell(
            child: InkWell(
          child: ContColorSmall(Text(doc['Контрагент']), color),
          onTap: () {
            opendoc(doc);
          },
        )),
        TableCell(
            child: InkWell(
          child: ContColorSmall(Text(doc['СуммаДокумента'].toString()), color),
          onTap: () {
            opendoc(doc);
          },
        )),
      ]));
    }
    return bordersList;
  }

  void opendoc(doc) {
    Map data = Map();
    data['Тип'] = widget.type;
    data['Номер'] = doc['Номер'];
    data['Дата'] = doc['Дата'];

    Navigator.pushNamed(context, "/BarDoc", arguments: data);
    print(doc['Номер']);
  }

  Future<Null> _selectDate(BuildContext context, var type) async {
    var datechange;
    if (type == 'from')
      datechange = globals.datefrom;
    else
      datechange = globals.dateto;
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: datechange,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != datechange)
      setState(() {
        isloading = true;
        if (type == 'from')
          globals.datefrom = picked;
        else
          globals.dateto = picked;
      });
  }

  Widget build(BuildContext context) {
    if (isloading) {
      showDocList(globals.datefrom, globals.dateto);
      return LinearProgressIndicator();
    } else {
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text("Период с " +
                  formatDate(globals.datefrom, [dd, '.', mm, '.', yy])),
              IconButton(
                  icon: Icon(Icons.date_range),
                  onPressed: () => _selectDate(context, 'from')),
              Text(" по " + formatDate(globals.dateto, [dd, '.', mm, '.', yy])),
              IconButton(
                  icon: Icon(Icons.date_range),
                  onPressed: () => _selectDate(context, 'to'))
            ],
          ),
          Expanded(
            //height: 500.0,
            child: ListView(children: [
              Table(
                columnWidths: {
                  0: FlexColumnWidth(0.8),
                  1: FlexColumnWidth(1.4),
                  2: FlexColumnWidth(0.8),
                },
                border: TableBorder.all(),
                children: getDocs(getParam(json, "Документы")),
              ),
            ]),
          )
        ],
      );
    }
    ;
  }
}

class BarcodeState extends State {
  bool isloading = true;
  var data;

  List<Widget> tabs = [
    MainTab(),
    DocTab(),
  ];

  void onTabTapped(int index) {
    setState(() {
      globals.currentBarIndex = index;
    });
  }

  Future Scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      //PopUpInfo('Штрихкод', barcode, context);

      var post = new Post1c();
      if (globals.currentBarIndex == 0) {
        post.metod = "findbargood";
        post.input = '?barcode=' + barcode;
      } else {
        post.metod = "findbardoc";
        post.input = '?barcode=' + barcode + '&doctype=' + globals.curentbardoc;
      }

      await post.HttpGet();
      var json = post.text;
      var res = getParam(json, "Найдено");
      if (!res)
        PopUpInfo('Штрихкод', barcode + ' не найден!', context);
      else {
        if (globals.currentBarIndex == 0) {
          dialogGoodsCard(getParam(json, "Данные")['Код'], 'Coded', context);
        } else {
          Navigator.pushNamed(context, "/BarDoc",
              arguments: getParam(json, "Данные"));
        }
      }
      //isloading = false;

      //setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          PopUpInfo('Ошибка сканера',
              'The user did not grant the camera permission!', context);
          //this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        PopUpInfo('Ошибка сканера', 'Unknown error: $e', context);
        //setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      /*setState(() => this.barcode =
      'null (User returned using the "back"-button before scanning anything. Result)');*/
    } catch (e) {
      PopUpInfo('Ошибка сканера', 'Unknown error: $e', context);
      //setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  Widget build(BuildContext context) {
    globals.barcoderedraw = onTabTapped;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        // leading: IconButton(icon: new Icon(Icons.menu), onPressed: () {}),
        title: Text('Штрихкоды'),
        actions: <Widget>[
          new iconButton(
              new Icon(
                CupertinoIcons.barcode_viewfinder,
                size: 40.0,
              ), () {
            Scan();
          }),
          new IconButton(
            icon: new Icon(Icons.autorenew),
            onPressed: () {
              print('renew ' + globals.currentBarIndex.toString());
              globals.bartabredraw[globals.currentBarIndex]();
            },
          )
        ],
      ),
      body: tabs[globals.currentBarIndex],
      bottomNavigationBar: new BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: globals.currentBarIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            new BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text("Типы документов"),
            ),
            new BottomNavigationBarItem(
              icon: new Icon(
                Icons.assignment,
              ),
              title: new Text('Документы'),
            ),
          ]),
    );
  }
}

class BarDoc extends StatefulWidget {
  BarDocState createState() => new BarDocState();
}

class BarDocState extends State {
  bool isloading = true;
  var json;
  Map struct;
  var data;
  bool rescan = false;

  Future getdata() async {
    var post = new Post1c();
    post.metod = "bardoc";
    post.input = '?doctype=' +
        struct['Тип'] +
        '&number=' +
        struct['Номер'] +
        '&date=' +
        struct['Дата'];

    await post.HttpGet();
    json = post.text;
    isloading = false;
    setState(() {});
  }

  Future Scan() async {
    var rescan = true;
    while (rescan) {
      rescan = false;
      try {
        String barcode = await BarcodeScanner.scan();
        //PopUpInfo('Штрихкод', barcode, context);

        var post = new Post1c();
        post.metod = "findbargoodindoc";
        post.input = '?barcode=' +
            barcode +
            '&doctype=' +
            data['Тип'] +
            '&id=' +
            data['Ид'];

        await post.HttpGet();
        var json = post.text;
        var res = getParam(json, "Найдено");
        if (!res)
          PopUpInfo('Штрихкод', barcode + ' в документе не найден!', context);
        else {
          rescan = await dialogGoodsBar(
              getParam(json, "Данные")['Код'], data, renew, context);
          //print('Rescan ' + rescan.toString());
        }
        //isloading = false;

        //setState(() => this.barcode = barcode);
      } on PlatformException catch (e) {
        if (e.code == BarcodeScanner.CameraAccessDenied) {
          setState(() {
            PopUpInfo('Ошибка сканера',
                'The user did not grant the camera permission!', context);
            //this.barcode = 'The user did not grant the camera permission!';
          });
        } else {
          PopUpInfo('Ошибка сканера', 'Unknown error: $e', context);
          //setState(() => this.barcode = 'Unknown error: $e');
        }
      } on FormatException {
        /*setState(() => this.barcode =
      'null (User returned using the "back"-button before scanning anything. Result)');*/
      } catch (e) {
        PopUpInfo('Ошибка сканера', 'Unknown error: $e', context);
        //setState(() => this.barcode = 'Unknown error: $e');
      }
    }
  }

  void renew() {
    setState(() {
      isloading = true;
    });
  }

  void opennom(data) {
    dialogGoodsCard(data['Код'], 'Coded', context);
  }

  void openmark(code, data) {
    dialogMarks(code, data, renew, context);
  }

  List nomList(data) {
    var bordersList = new List<TableRow>();
    bordersList.add(
        TableRow(decoration: BoxDecoration(color: Colors.amber[50]), children: [
      TableCell(
          child: Column(children: [
        Text(
          'Код',
          textScaleFactor: 1.0,
        ),
        Text(
          'Ячейка',
          textScaleFactor: 1.0,
        )
      ])),
      TableCell(
          child: Center(
        child: Text(
          'Номенклатура',
          textScaleFactor: 1.0,
        ),
      )),
      TableCell(
          child: Column(
        children: <Widget>[
          Center(child: Text('Кол.', textScaleFactor: 1.0)),
          Center(child: Text('Подб.', textScaleFactor: 1.0))
        ],
      )),
      (data['Тип'] == 'real')
          ? (TableCell(
              child: Center(
                  child: Text(
                'Мар.',
                textScaleFactor: 1.0,
              )),
            ))
          : TableCell(
              child: Container(),
            ),
    ]));
    for (var doc in data['Товары']) {
      var markBcolor;
      var markcolor;
      var color = (doc['Количество'] == doc['Подобрано'])
          ? Colors.lightGreenAccent
          : Colors.transparent;
      if (doc['Количество'] == doc['Маркировано']) {
        markBcolor = Colors.lightGreenAccent;
        markcolor = Colors.black;
      } else {
        markBcolor = Colors.transparent;
        if (doc['ЕстьМаркировки']) {
          markcolor = Colors.black;
          markBcolor = Colors.amberAccent;
        } else
          markcolor = Colors.grey[300];
      }

      bordersList.add(TableRow(children: [
        TableCell(
            child: InkWell(
          child: ContColorSmall(
              Column(
                children: <Widget>[
                  Text(doc['Код'], textScaleFactor: 0.8),
                  Text(doc['Ячейка'])
                ],
              ),
              color),
          onTap: () {
            opennom(doc);
          },
        )),
        TableCell(
            child: InkWell(
          child: ContColorSmall(Text(doc['Номенклатура']), color),
          onTap: () {
            opennom(doc);
          },
        )),
        TableCell(
            child: InkWell(
          child: ContColorSmall(
              Column(
                children: <Widget>[
                  Text(doc['Количество'].toString()),
                  Text(doc['Подобрано'].toString())
                ],
              ),
              color),
          onTap: () {
            opennom(doc);
          },
        )),
        (data['Тип'] == 'real')
            ? TableCell(
                child: InkWell(
                child: ContColorSmall(
                    Icon(
                      CupertinoIcons.barcode,
                      color: markcolor,
                    ),
                    markBcolor),
                onTap: () {
                  openmark(doc['Код'], data);
                },
              ))
            : TableCell(
                child: Container(),
              ),
      ]));
    }
    return bordersList;
  }

  Widget docBody() {
    if (isloading) {
      getdata();
      return LinearProgressIndicator();
    } else {
      data = getParam(json, 'Данные');
      var colwid; // = new Map();
      if (data['Тип'] == 'real') {
        colwid = {
          0: FlexColumnWidth(0.8),
          1: FlexColumnWidth(1.4),
          2: FlexColumnWidth(0.5),
          3: FlexColumnWidth(0.5),
        };
      } else {
        colwid = {
          0: FlexColumnWidth(0.8),
          1: FlexColumnWidth(1.4),
          2: FlexColumnWidth(0.5),
          3: FlexColumnWidth(0.01),
        };
      }
      return Column(
        children: <Widget>[
          Row(children: [
            Group(Text(data['Номер']), "Номер"),
            Group(Text(data['Дата']), "Дата"),
            Group(Check(data['Подобран'], 20.0), 'Подобран'),
          ]),
          Group(Text(data['Контрагент']), "Контрагент"),
          Expanded(
            //height: 500.0,
            child: ListView(children: [
              Table(
                columnWidths: colwid,
                border: TableBorder.all(),
                children: nomList(data),
              ),
            ]),
          )
        ],
      );
    }
  }

  Widget build(BuildContext context) {
    struct = ModalRoute.of(context).settings.arguments;
    print(rescan);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        // leading: IconButton(icon: new Icon(Icons.menu), onPressed: () {}),
        title: Text('Документ'),
        actions: <Widget>[
          iconButton(new Icon(CupertinoIcons.barcode_viewfinder, size: 40.0),
              () {
            Scan();
          }),
          new IconButton(
            icon: new Icon(Icons.autorenew),
            onPressed: () {
              renew();
            },
          )
        ],
      ),
      body: docBody(),
    );
  }
}

Future dialogGoodsBar(code, struct, renew, context) {
  // flutter defined function
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        //title: new Text("Номенклатура"),
        content: GoodsBar(code, struct),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              renew();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class GoodsBar extends StatefulWidget {
  var code, struct;
  GoodsBar(this.code, this.struct);
  @override
  createState() => new GoodsBarState();
}

class GoodsBarState extends State<GoodsBar> {
  bool isloading = true;
  var json;
  var struct;
  var scrollController = new ScrollController();

  Future showGoodsCard(code) async {
    var post = new Post1c();
    post.metod = "docgoodsinfo";
    post.input =
        '?doctype=' + struct['Тип'] + '&id=' + struct['Ид'] + '&code=' + code;
    await post.HttpGet();
    json = post.text;
    isloading = false;
    setState(() {});
  }

  List cellList(cell) {
    var params;
    var listparams = new List<Widget>();

    params = cell;
    listparams.add(RButton(params, () {}));
    /*for (var par in params) {
      listparams.add(RButton(par['Имя'], () {}));
    }*/
    return listparams;
  }

  void moveGoodsBarDown(String change) {
    print('goin down');
    scrollController.animateTo(70,
        duration: Duration(milliseconds: 500), curve: Curves.linear);
    scrollController.animateTo(70,
        duration: Duration(milliseconds: 500), curve: Curves.linear);
  }

  void addtsd(int col, data, {contscan = false}) async {
    int amount = data['Количество'] - data['Подобрано'];
    if (col > amount) {
      await PopUpInfo(
          'Баркод', 'Количество подобранного больше необходимого', context);
    } else {
      var post = new Post1c();
      post.metod = "addposition";
      post.input = '?doctype=' +
          struct['Тип'] +
          '&id=' +
          struct['Ид'] +
          '&code=' +
          data['Код'] +
          '&amount=' +
          col.toString();
      await post.HttpGet();
      json = post.text;
      //isloading = false;
      if (getParam(json, 'Обработано'))
        await PopUpInfo('Баркод', 'Обработано.', context);
      else
        await PopUpInfo(
            'Баркод', 'Обработать не удалось. Проверьте количество.', context);

      //setState(() {});
    }
    Navigator.of(context).pop(contscan);
  }

  Widget build(BuildContext context) {
    if (isloading) {
      struct = widget.struct;
      print(struct);
      showGoodsCard(widget.code);
      return Container(
          child: Column(
        children: [
          LinearProgressIndicator(),
        ],
      ));
    } else {
      print(widget.code);
      var data = getParam(json, "Данные");
      var name = data['Номенклатура'];
      var txt2 = TextEditingController();
      //txt2.
      txt2.text = '1';
      return Container(
          child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  Group(Text(data['Код']), "Код"),
                  LGroup(Text(name),
                      "Наименование"), //getParam(json,"Наименование")),"Наименование"),
                  Group(
                      Column(
                        children: cellList(data['Ячейка']),
                      ),
                      "Ячейки"),
                  Group(Text(data['Количество'].toString()), "Количество"),
                  Group(Text(data['Подобрано'].toString()), "Подобрано"),
                  LGroup(
                      Column(
                        children: <Widget>[
                          ContSmall(TextFormField(
                            controller: txt2,
                            obscureText: false,
                            onTap: () {
                              moveGoodsBarDown('');
                            },
                            onChanged: (dt) {
                              moveGoodsBarDown('changed');
                            },
                            keyboardType: TextInputType.number,
                          )),
                          Row(
                            children: <Widget>[
                              ContSmall(
                                RButton("Штук", () {
                                  addtsd(int.tryParse(txt2.text) ?? 0, data);
                                }),
                              ),
                              ContSmall(
                                RButton('Коробок', () {
                                  addtsd(
                                      data['Кратность'] *
                                              int.tryParse(txt2.text) ??
                                          0,
                                      data);
                                }),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              ContSmall(
                                RButton("Шт.+Скан", () {
                                  addtsd(int.tryParse(txt2.text) ?? 0, data,
                                      contscan: true);
                                }),
                              ),
                              ContSmall(
                                RButton('Кор.+Скан', () {
                                  addtsd(
                                      data['Кратность'] *
                                              int.tryParse(txt2.text) ??
                                          0,
                                      data,
                                      contscan: true);
                                }),
                              )
                            ],
                          )
                        ],
                      ),
                      "Количество"),

                  /*RButton('Назад', () {
              Navigator.of(context).pop();
            })*/
                ],
              )));
    }
  }
}

void dialogMarks(code, struct, renew, context) {
  // flutter defined function
  print('Dialog');
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("Номенклатура"),
        content: Marks(code, struct),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              renew();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class Marks extends StatefulWidget {
  var code, struct;
  Marks(this.code, this.struct);
  @override
  createState() => new MarksState();
}

class MarksState extends State<Marks> {
  bool isloading = true;
  var json;
  var struct;
  var scrollController = new ScrollController();

  Future showGoodsCard(code) async {
    var post = new Post1c();
    post.metod = "docgoodmarks";
    post.input =
        '?doctype=' + struct['Тип'] + '&id=' + struct['Ид'] + '&code=' + code;
    await post.HttpGet();
    json = post.text;
    isloading = false;
    setState(() {});
  }

  Future ScanMark(code, mark) async {
    try {
      String barcode = await BarcodeScanner.scan();
      //PopUpInfo('Штрихкод', barcode, context);

      var post = new Post1c();
      post.metod = "addmark";
      post.input = '?barcode=' +
          barcode +
          '&doctype=' +
          struct['Тип'] +
          '&id=' +
          struct['Ид'] +
          '&oldmark=' +
          mark +
          '&code=' +
          code;

      await post.HttpGet();
      var Ljson = post.text;
      var res = getParam(Ljson, "Найдено");
      if (!res)
        PopUpInfo(
            'Штрихкод', barcode + getParam(Ljson, "СтатусПоиска"), context);
      else {
        PopUpInfo('Штрихкод', getParam(Ljson, "СтатусПоиска"), context);
        //json=Ljson;
        isloading = true;
        setState(() {});
      }
      //isloading = false;

      //setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          PopUpInfo('Ошибка сканера',
              'The user did not grant the camera permission!', context);
          //this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        PopUpInfo('Ошибка сканера', 'Unknown error: $e', context);
        //setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      /*setState(() => this.barcode =
      'null (User returned using the "back"-button before scanning anything. Result)');*/
    } catch (e) {
      PopUpInfo('Ошибка сканера', 'Unknown error: $e', context);
      //setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  List cellList(data) {
    var params;
    var listparams = new List<Widget>();

    var num = data['Всего'];
    var over = num - data['Маркировано'];
    var code = data['Код'];
    var bordersList = new List<TableRow>();
    bordersList.add(
        TableRow(decoration: BoxDecoration(color: Colors.amber[50]), children: [
      TableCell(
          child: Center(
        child: Text(
          'Маркировка',
          textScaleFactor: 1.0,
        ),
      )),
      TableCell(
          child: Center(
        child: Text(
          'C',
          textScaleFactor: 1.0,
        ),
      )),
    ]));

    for (var marking in data['Маркировки']) {
      bordersList.add(TableRow(
          decoration: BoxDecoration(color: Colors.grey[50]),
          children: [
            TableCell(
                child: Center(
              child: Text(
                marking['Маркировка'],
                textScaleFactor: 1.0,
              ),
            )),
            TableCell(
                child: Center(
                    child:
                        iconButton(Icon(CupertinoIcons.barcode_viewfinder), () {
              ScanMark(code, marking['Маркировка']);
            }))),
          ]));
    }
    for (var i = 1; i <= over; i++)
      bordersList.add(TableRow(
          decoration: BoxDecoration(color: Colors.grey[50]),
          children: [
            TableCell(
                child: Center(
              child: Text(
                '',
                textScaleFactor: 1.0,
              ),
            )),
            TableCell(
                child: Center(
                    child:
                        iconButton(Icon(CupertinoIcons.barcode_viewfinder), () {
              ScanMark(code, '');
              isloading = true;
              setState(() {});
            }))),
          ]));

    return bordersList;
  }

  Widget build(BuildContext context) {
    var colwid = {
      0: FlexColumnWidth(2.0),
      1: FlexColumnWidth(0.5),
    };

    print(isloading);
    if (isloading) {
      struct = widget.struct;
      print('Структура ');
      print(struct);
      showGoodsCard(widget.code);
      return Container(
          child: Column(
        children: [
          LinearProgressIndicator(),
        ],
      ));
    } else {
      print(widget.code);
      var data = getParam(json, "Данные");
      var name = data['Наименование'];
      var txt2 = TextEditingController();
      //txt2.
      txt2.text = '1';
      return Container(
          child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  Group(Text(data['Код']), "Код"),
                  LGroup(Text(name),
                      "Наименование"), //getParam(json,"Наименование")),"Наименование"),
                  Group(
                      Table(
                        columnWidths: colwid,
                        border: TableBorder.all(),
                        children: cellList(data),
                      ),
                      "Маркировки"),

                  /*RButton('Назад', () {
              Navigator.of(context).pop();
            })*/
                ],
              )));
    }
  }
}
