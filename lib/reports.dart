// ignore: avoid_web_libraries_in_flutter
//import 'dart:js';

import 'HTTPExchange.dart';
import 'Alarms.dart';
import 'package:flutter/material.dart';
import 'styledwidgets.dart';
import 'globals.dart' as globals;
import 'dart:convert';
import 'package:date_format/date_format.dart';

class ReportList extends StatefulWidget {
  @override
  createState() => new ReportListState();
}

class ReportListState extends State {
  bool isloading = true;
  var data;

  Widget reportList() {
    List<Widget> Reports = new List();
    for (var el in data['Отчеты']) {
      Reports.add(ReportButton(
          el,
          new Icon(
            Icons.description,
            size: 30.0,
          )));
    }

    return ButtonTab(3, Reports);
  }

  Future GetActualReports() async {
    var post = new Post1c();
    post.metod = "reportslist";
    post.input = '?messagesquantity=' + 100.toString();
    await post.HttpGet();
    var json = post.text;
    if (post.state == 'ok') {
      data = jsonDecode(json);
      isloading = false;
      setState(() {});
    } else
      return null;
  }

  Widget build(BuildContext context) {
    if (isloading) {
      GetActualReports();
      return LinearProgressIndicator();
    } else {
      return ContRaised(
        ExpansionTile(
          //backgroundColor: Colors.amber[50],
          title: Text(
            'Отчеты',
          ),
          children: [
            reportList(),
          ],
        ),
      );
    }
    ;
  }
}

class ReportButton2 extends StatelessWidget {
  final data;
  ReportButton2(this.data);
  Widget build(BuildContext context) {
    return LightButton(data['Заголовок'], () {
      print('report');
      Navigator.pushNamed(context, '/Report', arguments: data);
    });
  }
}

class ReportButton extends StatelessWidget {
  final data;
  final icon;

  ReportButton(this.data, this.icon);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: new RaisedButton(
        padding: new EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 3.0),
        //margin: EdgeInsets.fromLTRB(2.0, 2.0, 3.0, 3.0),
        color: Colors.amber[50],
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0)),
        onPressed: () {
          print('report');
          Navigator.pushNamed(context, '/Report', arguments: data);
        },
        child: Column(
          children: <Widget>[icon, Text(data['Заголовок'])],
        ),
      ),
    );
  }
}

class Report extends StatefulWidget {
  @override
  createState() => new ReportState();
}

class ReportState extends State<Report> {
  var data;
  var ready = false;
  var redraw = true;
  final txt1 = TextEditingController(); //параметры отчета будем так хранить.
  final txt2 = TextEditingController();
  final txt3 = TextEditingController();
  List tecs = List();
  //Report(this.data);

  Future<Null> _selectDate(BuildContext context, var nom) async {
    var datechange;
    var txtcont = tecs[nom];
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: globals.curdate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != datechange)
      txtcont.text = formatDate(picked, [dd, '.', mm, '.', yy]);
  }

  List ActionList(context) {
    var actions = new List<Widget>();

    var nom = 0;
    for (var el in data['Параметры']) {
      if (el['Тип'] == "Дата") {
        int pos = nom;
        actions.add(Group(
            TextFormField(
              controller: tecs[nom],
              onTap: () {
                _selectDate(context, pos);
              },
            ),
            el['Заголовок']));
        nom = nom + 1;
      }
    }
    return actions;
  }

  @override
  void initState() {
    tecs.add(txt1);
    tecs.add(txt2);
    tecs.add(txt3);
  }

  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;

    var repBody = ReportBody(data);
    //var repBodyState = repBody.createState();
    return Scaffold(
      appBar: AppBar(
        title: Text(data['Заголовок']),

        //actions: ActionList(context),
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 40.0, 8.0, 8.0),
          child: LGroup(Column(children: ActionList(context)), 'Параметры'),
        ),
      ),
      body: repBody,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RButton('Назад', () {
                Navigator.pop(context);
              }),
            ),
            RButton('Сформировать', () {
              ready = true;
              globals.redrawreport(true, tecs);
              //ready = true;
              /*setState(() {
                ready = true;
                redraw = true;
              });*/
              //setState();
            })
          ],
        ),
      ),
    );
  }
}

class ReportBody extends StatefulWidget {
  var ready;
  var data;
  var redraw;
  ReportBody(this.data);
  createState() => new ReportBodyState();
}

class ReportBodyState extends State<ReportBody> {
  bool isloading;
  var data;
  var results;
  var ready = false;
  var tecs;

  Future getData() async {
    var post = new Post1c();
    var paramstring = '';
    int nom = 0;
    for (var el in data['Параметры']) {
      paramstring = paramstring + '&' + el['Имя'] + '=' + tecs[nom].text;
      nom = nom + 1;
    }

    post.metod = "report";
    post.input = '?report=' + data['Заголовок'] + paramstring;
    await post.HttpGet();
    var json = post.text;
    if (post.state == 'ok') {
      results = jsonDecode(json);
      isloading = false;
      setState(() {});
    } else
      return null;
  }

  Widget reportBody() {
    Map<int, TableColumnWidth> wights = new Map();
    Map<int, double> scales = new Map();
    var firstRowCells = new List<TableCell>();
    int nom = 0;
    var ListRows = new List<TableRow>();
    for (var el in results['Шапка']) {
      //print('Доля' + el['Доля'].toString());
      wights[nom] = FlexColumnWidth(el['Доля'].toDouble());
      scales[nom] = (el['РазмерТело'] == 0) ? 1.0 : el['РазмерТело'].toDouble();
      nom = nom + 1;
      double scale =
          (el['РазмерЗаголовок'] == 0) ? 1.0 : el['РазмерЗаголовок'].toDouble();
      firstRowCells.add(TableCell(
          child: Text(el['Заголовок'],
              style: TextStyle(fontWeight: FontWeight.bold),
              textScaleFactor: scale)));
    }
    ListRows.add(TableRow(
        children: firstRowCells,
        decoration: BoxDecoration(color: Colors.amber[50])));
    for (var el in results['Отчет']) {
      var rowCells = new List<TableCell>();
      nom = 0;
      for (var el2 in el.values) {
        rowCells.add(TableCell(
            child: InkWell(
          child: Text(
            el2['Значение'].toString(),
            textScaleFactor: scales[nom],
          ),
          onTap: () {
            PopUpInfo(el2['Значение'].toString(), el2['Расшифровка'], context);
          },
        )));
        nom = nom + 1;
      }
      ListRows.add(TableRow(
        children: rowCells,
      ));
    }
    var table = Table(
      columnWidths: wights,
      border: TableBorder.all(),
      children: ListRows,
    );
    return table;
  }

  void redraw(isready, _tecs) {
    print('report redraw');
    isloading = true;
    ready = isready;
    tecs = _tecs;
    setState(() {});
  }

  Widget build(BuildContext context) {
    globals.redrawreport = redraw;

    data = widget.data;
    if (!ready)
      return Container();
    else if (isloading) {
      getData();
      return LinearProgressIndicator();
    } else
      return reportBody();
  }
}
