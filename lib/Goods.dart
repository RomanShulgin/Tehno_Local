import 'package:flutter/material.dart';
import 'HTTPExchange.dart';
import 'styledwidgets.dart';
import 'dart:typed_data';
import 'Basket.dart';
import 'globals.dart' as globals;
import 'main.dart';

class GoodsMicro extends StatelessWidget {
  final struct;

  GoodsMicro(this.struct);

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: () {
        dialogGoodsCard(struct['Код'], 'Coded', context);
      },
      child: Center(
          child: Container(
        constraints: BoxConstraints(minHeight: 30.0),
        alignment: Alignment(0.0, 0.0),
        padding: new EdgeInsets.fromLTRB(2.0, 0.0, 0.0, 0.0),
        color: Colors.amber[50],
        child: Column(
          children: <Widget>[
            Text(
              struct['Номенклатура'],
              textScaleFactor: 0.8,
            ),
          ],
        ),
      )),
    );
  }
}

void dialogGoodsCard(code, nomType, context, [fixparams, name, redraw]) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        //title: new Text("Номенклатура"),
        content: GoodsCard(code, nomType, fixparams, name),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              if (redraw != null) {
                redraw();
              }

              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class Nomicon extends StatefulWidget {
  var code;
  Nomicon(this.code);
  @override
  createState() => new NomiconState();
}

class NomiconState extends State<Nomicon> {
  bool isloading = true;
  Uint8List binaryData;

  String getGoodsPicture(code) {
    String user = globals.user;
    String password = globals.password;
    return 'http://46.34.155.26/tehno/hs/GetBasicInfo/$user/$password/goodsicon/?code=$code';
  }

  Widget build(BuildContext context) {
    var imagepath = getGoodsPicture(widget.code);
    return Container(
      child: Image.network(imagepath),
    );
  }
}

class GoodsCard extends StatefulWidget {
  var code, nomType, fixparams, name;
  GoodsCard(this.code, this.nomType, [this.fixparams, this.name]);
  @override
  createState() => new GoodsCardState();
}

class GoodsCardState extends State<GoodsCard> {
  bool isloading = true;
  var json;
  var fixparams, nomtype, name;

  Future showGoodsCard(code) async {
    var post = new Post1c();
    post.metod = "goodsinfo";
    post.input = '?code=' + code;
    await post.HttpGet();
    json = post.text;
    isloading = false;
    setState(() {});
  }

  List paramList() {
    var params;
    var listparams = new List<TableRow>();
    if (nomtype == 'Coded') {
      params = getParam(json, "Параметры");
    } else {
      params = fixparams;
      name = widget.name;
    }
    for (var par in params.entries) {
      listparams.add(TableRow(children: [
        TableCell(
            child: ContSmall(Text(par.value['ИмяПараметра'],
                textScaleFactor: 0.8))), //.['ИмяПараметра']
        TableCell(
            child:
                ContSmall(Text(par.value['Значение'], textScaleFactor: 0.8))),
      ]));
    }
    return listparams;
  }

  List cellList() {
    var params;
    var listparams = new List<Widget>();

    params = getParam(json, "Ячейка");
    listparams.add(RButton(params, () {}));
    /*for (var par in params) {
      listparams.add(RButton(par['Имя'], () {}));
    }*/
    return listparams;
  }

  Widget build(BuildContext context) {
    if (isloading) {
      print(widget.code);
      showGoodsCard(widget.code);
      nomtype = widget.nomType;
      fixparams = widget.fixparams;
      name = widget.name;
      return Container(
          child: Column(
        children: [
          LinearProgressIndicator(),
        ],
      ));
    } else {
      print(widget.code);
      if (name == null) {
        name = getParam(json, "Наименование");
      }
      return Container(
          child: SingleChildScrollView(
              child: Column(
        children: [
          Group(Text(getParam(json, "Код")), "Код"),
          Nomicon(getParam(json, "Код")),
          LGroup(Text(name),
              "Наименование"), //getParam(json,"Наименование")),"Наименование"),
          Group(
              Column(
                children: cellList(),
              ),
              "Ячейки"),
          Group(Text(getParam(json, "Наличие").toString()), "Наличие"),
          Group(
              Table(
                  //columnWidths: {0: FixedColumnWidth(15.0),1: FixedColumnWidth(65.0),2: FlexColumnWidth(1.0),3: FixedColumnWidth(60.0),4: FixedColumnWidth(60.0),5: FlexColumnWidth(0.5),},
                  border: TableBorder.all(),
                  children:
                      paramList() //[TableRow(children: [TableCell(child: Text("1"))])]//paramList(),
                  ),
              "Параметры"),
          /*RButton('Назад', () {
              Navigator.of(context).pop();
            })*/
        ],
      )));
    }
  }
}
