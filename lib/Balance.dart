import 'package:flutter/material.dart';
import 'HTTPExchange.dart';
import 'styledwidgets.dart';
import 'Order.dart';
import 'package:indexed_list_view/indexed_list_view.dart';
import 'package:flutter/scheduler.dart';

import 'globals.dart' as globals;




class Balance extends StatefulWidget {
  var json;
  bool isloading=false;
  @override
  createState() => new BalanceState();
}

class BalanceState extends State<Balance> {
  bool isloading=true;
  var json;

  Future showBalance() async
  {
    var post=new Post1c();
    post.metod="balancerep";
    post.input='';
    await post.HttpGet();
    json=post.text;
    print("Отчет"+getParam(json,"Отчет").toString());
    isloading=false;
    setState((){});
  }


  Widget build(BuildContext context)
  { print('dialog');

    if (isloading) {
      showBalance();
      return Scaffold(
          appBar: AppBar(title: Text('Расшифровка баланса')),
          body:
        Column(children: <Widget>[LinearProgressIndicator(),
        RButton('Назад', (){Navigator.of(context).pop(); })
        ],
        )

    );
    }
    else {
      return Scaffold(
          appBar: AppBar(title: Text('Расшифровка баланса')),
          body: ListView(children:
          [
            BalanceSheet(getParam(json, "Отчет")),
            RButton('Назад', () {
              Navigator.of(context).pop();
            })
          ],
          ));

    };

  }
}

class BalanceSheet extends StatelessWidget {
  final docs;
  var pixelcur=0.0;
  final itemsize=70.0;
  BalanceSheet(this.docs);
  var controller = ScrollController();

  List getDocList(){
    var bordersList = new List<TableRow>();
    for (var doc in docs){
      bordersList.add(
      TableRow(
          children:[TableCell(child: OrderLight(doc)),
                    TableCell(child: Container(padding: new EdgeInsets.fromLTRB(3.0, 3.0, 1.0, 1.0), child:Text(doc['СуммаОстаток'],textScaleFactor: 0.8))),]
      )
      );
    }
    return bordersList;
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //SchedulerBinding.instance.addPostFrameCallback((_) => scrollToCur());
    var list = new Table(
        columnWidths: {0: FlexColumnWidth(1.0),1: FixedColumnWidth(120.0)},
      border: TableBorder.all(),
      children: getDocList()
    );


    return list;//Flexible(child:list);
  }

}


