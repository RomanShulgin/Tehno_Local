import 'package:flutter/material.dart';
import 'package:tehnoparts/Alarms.dart';
import 'HTTPExchange.dart';
import 'styledwidgets.dart';
import 'package:date_format/date_format.dart';
import 'Goods.dart';
import 'Payment.dart';

import 'globals.dart' as globals;


class OrderLight extends StatelessWidget {
  final struct;

  OrderLight(this.struct);

  @override
  Widget build(BuildContext context) {
    return new RaisedButton(
      padding: new EdgeInsets.fromLTRB(2.0, 1.0, 2.0, 1.0),
      //margin: EdgeInsets.fromLTRB(2.0, 2.0, 3.0, 3.0),
      color: Colors.amber[50],
      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
      onPressed: (){Navigator.pushNamed(context, '/Order',arguments: <String, String>{'date':struct['Дата'],'number':struct['Номер'],'type':'Order'});},
      child: Text('№'+struct['Номер']+' от '+struct['Дата'],textScaleFactor: 0.8),
    );

  }
}

class OrderMicro extends StatelessWidget {
  final struct;

  OrderMicro(this.struct);

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: (){Navigator.pushNamed(context, '/Order',arguments: <String, String>{'date':struct['Дата'],'number':struct['Номер'],'type':'Order'});},
      child: Container(
      padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      //margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      color: Colors.amber[50],
      //shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(3.0)),
      //onPressed: (){Navigator.pushNamed(context, '/Order',arguments: <String, String>{'date':struct['Дата'],'number':struct['Номер']});},
      child: Column(children:[Text(struct['Номер'],textScaleFactor: 0.8,),Text(struct['Дата'],textScaleFactor: 0.8,)]) ,
    ),
    );

  }
}


class KPMicro extends StatelessWidget {
  final struct;

  KPMicro(this.struct);

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: (){Navigator.pushNamed(context, '/Order',arguments: <String, String>{'date':struct['Дата'],'number':struct['Номер'],'type':'KP'});},
      child: Container(
        padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        //margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        color: Colors.amber[50],
        //shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(3.0)),
        //onPressed: (){Navigator.pushNamed(context, '/Order',arguments: <String, String>{'date':struct['Дата'],'number':struct['Номер']});},
        child: Column(children:[Text(struct['Номер'],textScaleFactor: 0.7,),Text(struct['Дата'],textScaleFactor: 0.7,)]) ,
      ),
    );

  }
}


class Order extends StatefulWidget {
  //var struct;//содержит структуру с номером и датой
  //Order(this.struct);

  bool isloading=false;
  @override
  createState() => new OrderState();
}

class OrderState extends State<Order> {
  bool isloading=true;
  var json;


  Future showOrderInfo(Number,Date,typeDoc) async
  {
    print("Type "+typeDoc);
    var post=new Post1c();
    post.metod="orderinfo";
    post.input='?number='+Number+'&date='+Date+'&type='+typeDoc;
    await post.HttpGet();
    json=post.text;
    //print("Заказ"+getParam(json,"Заказ"));
    isloading=false;
    setState((){});
  }

  Widget circular(bool loading){
    return new FutureBuilder<String>(
        builder: (context, snapshot) {
          return loading? CircularProgressIndicator():Text('OK') ;
        }
    );
  }



  Future fixDraft(struct)async
  {
    var post=new Post1c();
    post.metod="fixdraft";
    post.input='?number='+struct['number']+'&date='+struct['date']+'&type='+struct['type'];
    await post.HttpGet();
    var jsont=post.text;
    if (post.state == 'ok') {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Зафиксирован новый КП'),
            content: Text('Зафиксирован новый КП №'+struct['number']),
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
    //print("Заказ"+getParam(json,"Заказ"));
    //isloading=false;
    setState((){});
  }

  void Pay(struct){
    if(getParam(json,"Оплачен")=='Оплачен'){
      var buttons = new  List<Widget>();
      buttons.add(FlatButton(
          child: Text('Оплатить'),
          onPressed: ()  {Navigator.push(context, MaterialPageRoute(
              builder: (context) => Payment(struct)));},
          ));
      buttons.add(FlatButton(
        child: Text('Возврат'),
        onPressed: () {
          Navigator.of(context).pop();
        }));
      PopUpDialog('Платеж', "Данный документ уже оплачен", buttons, context);
    }
    else{
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => Payment(struct)));
    }
  }

  Widget FixDraft(struct,json){
  if(struct['type']=='KP'&&getParam(json,"Проведен")=='Нет'){
    return RButton('Сделать заказ',(){
      fixDraft(struct);
      print('Ok');});
   }else
     {
       return Container();
     }
  }

  List getGoods(strings){
    var bordersList = new List<TableRow>();
    bordersList.add(
        TableRow(
          decoration: BoxDecoration(color: Colors.amber[50]),
            children:[
              TableCell(child: Text('N',textScaleFactor: 0.8,)),
              TableCell(child: Text('Код',textScaleFactor: 0.8,)),
              TableCell(child: Text('Номенклатура',textScaleFactor: 0.8,)),
              TableCell(child:Column(children: <Widget>[Text('Кол-во',textScaleFactor: 0.8,),Text('Цена',textScaleFactor: 0.8,)],) ),
              //TableCell(child: Text('Цена',textScaleFactor: 0.8,)),
              TableCell(child: Text('Сумма',textScaleFactor: 0.8)),
              TableCell(child: Text('Поставка',textScaleFactor: 0.7,)),
            ]
        ));
    for (var doc in strings){
      bordersList.add(
          TableRow(
              children:[
                TableCell(child: Text(doc['НомерСтроки'],textScaleFactor: 0.8)),
                TableCell(child: Text(doc['Код'],textScaleFactor: 0.8)),
                TableCell(verticalAlignment: TableCellVerticalAlignment.middle ,child: GoodsMicro(doc)),
                TableCell(child: Column(children: <Widget>[Text(doc['Количество'],textScaleFactor: 0.8, style: TextStyle(fontWeight: FontWeight.bold),),Text(doc['Цена'],textScaleFactor: 0.8)],)),
                //TableCell(child: Text(doc['Цена'],textScaleFactor: 0.8)),
              TableCell(child: Text(doc['Сумма'],textScaleFactor: 0.8)),
                TableCell(child: Text(doc['СрокПоставки'],textScaleFactor: 0.5)),]
          )
      );
    }
    return bordersList;
  }

  Widget build(BuildContext context)
  { //print('dialog');

     Map struct =  ModalRoute.of(context).settings.arguments;
     var Number=struct['number'];
     var Date=struct['date'];
      var typeDoc=struct['type'];
      if (isloading) {
        print(typeDoc);
      showOrderInfo(Number,Date,typeDoc);
      return Scaffold(
          appBar: AppBar(title: Text('Заказ...')),
          body:
        Column(children: <Widget>[LinearProgressIndicator(),
        Row(
          children: <Widget>[

            RButton('Назад', (){Navigator.of(context).pop(); }),
          ],
        )
        ],
        )

    );
    }
    else {
      Map payStruct = new Map();
      payStruct['Sum']=refString(getParam(json,"СуммаДокумента"));
      payStruct['Order']=getParam(json,"Ссылка");

      return Scaffold(
          appBar: AppBar(title: Text(getParam(json,"Ссылка"))),
          body: ListView(children:
          [ Row(children:[
            Group(Text(getParam(json,"Номер")),'Номер'),
            LGroup(Text(getParam(json,"Дата").substring(0,10)),'Дата'),
            LGroup(Check(getParam(json,"Проведен")),'Согласован'),
          ]),
          Row(children:[
            LGroup(Text(getParam(json,"ТипЦен")),'Тип цен'),
            Group(Text(getParam(json,"СуммаДокумента")),'Сумма'),
          ]),
          Row(children:[
            LGroup(Check(getParam(json,"Оплачен")=='Оплачен'?'Да':'Нет'),'Оплата'),
            LGroup(Check(getParam(json,"Отгружен")=='Отгружен'?'Да':'Нет'),'Отгрузка'),
            LGroup(Check(getParam(json,"Документы")),'Документы'),
          ]),
          Table(
            columnWidths: {0: FixedColumnWidth(15.0),1: FixedColumnWidth(65.0),2: FlexColumnWidth(1.0),3: FixedColumnWidth(60.0),4: FixedColumnWidth(60.0),5: FlexColumnWidth(0.5),},
            border: TableBorder.all(),
            children: getGoods(getParam(json,"Товары")),
          ),
          Group(Text(getParam(json,"Комментарий")),'Комментарий'),
          FixDraft(struct,json),
            Row(
              children: <Widget>[
                RButton("Оплатить",() {Pay(payStruct);}),
                RButton('Назад', () {
                  Navigator.of(context).pop();
                }),
              ],
            )
          ],
          ));

    };

  }
}

class OrderList extends StatefulWidget {
  //var struct;//содержит структуру с номером и датой
  //Order(this.struct);
  var datefrom, dateto;
  OrderList(this.datefrom,this.dateto);

  bool isloading=false;
  @override
  createState() => new OrderListState();
}

class OrderListState extends State<OrderList> {
  bool isloading=true;
  var json;



  Future showOrderList(datefrom,dateto) async
  {
    var post=new Post1c();
    post.metod="orderlist";
    post.input='?datefrom='+formatDate(datefrom, [dd,'.',mm,'.',yy])+'&dateto='+formatDate(dateto, [dd,'.',mm,'.',yy]);
    await post.HttpGet();
    json=post.text;
    isloading=false;
    setState((){});
  }

  List getOrders(strings){
    var bordersList = new List<TableRow>();
    bordersList.add(
        TableRow(
            decoration: BoxDecoration(color: Colors.amber[50]),
            children:[
              TableCell(child:Column(children:[Text('№ КП',textScaleFactor: 0.8,),Text('Дата',textScaleFactor: 0.8,)]) ),
              TableCell(child:Column(children:[Text('№ Заказ',textScaleFactor: 0.8,),Text('Дата',textScaleFactor: 0.8,)]) ),
              TableCell(child:Column(children:[ Text('Отг ',textScaleFactor: 0.8,),Text('Опл ',textScaleFactor: 0.8,),Text('Док',textScaleFactor: 0.8)],) ),
              //TableCell(child: Text('Док',textScaleFactor: 0.8)),
              TableCell(child: Text('Сумма',textScaleFactor: 1.0)),
              TableCell(child: Text('Комментарий',textScaleFactor: 0.8,)),
            ]
        ));
    for (var doc in strings){
      if(doc['ЕстьЗаказ']){
      bordersList.add(
          TableRow(
              children:[
                TableCell(child:KPMicro ({'Номер': doc['НомерКП'],'Дата':doc['ДатаКП']}),verticalAlignment: TableCellVerticalAlignment.middle),
                TableCell(child:OrderMicro ({'Номер': doc['Номер'],'Дата':doc['Дата']}),verticalAlignment: TableCellVerticalAlignment.middle,),
                TableCell(child:Column(children:[
                  Check(doc["Оплачен"]=='Оплачен'?'Да':'Нет',12.0),Check(doc["Отгружен"]=='Отгружен'?'Да':'Нет',12.0), Check(doc["Документы"],12.0)],),),

                //TableCell(child: Check(doc["Документы"],12.0)),
                TableCell(child: Text(doc['СуммаДокумента'],textScaleFactor: 0.9),verticalAlignment: TableCellVerticalAlignment.middle),
                TableCell(child: Text(doc['Комментарий'],textScaleFactor: 0.5,),verticalAlignment: TableCellVerticalAlignment.middle),]
          )
      );
    }
    else
      {
        bordersList.add(
            TableRow(
                children:[
                  TableCell(child:KPMicro ({'Номер': doc['НомерКП'],'Дата':doc['ДатаКП']})),
                  TableCell(child: Text('--')),
                  TableCell(child: Text('--')),

                  //TableCell(child: Text('--')),
                  TableCell(child: Text('--')),
                  TableCell(child: Text(doc['Черновик'],textScaleFactor: 1.0,),verticalAlignment: TableCellVerticalAlignment.middle)]
            )
        );
      }
    }
    return bordersList;
  }

  Future<Null> _selectDate(BuildContext context,var type) async {
    var datechange;
    if (type=='from') datechange=globals.datefrom; else datechange=globals.dateto;
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: datechange,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != datechange)
      setState(() {
        isloading=true;
        if (type=='from') globals.datefrom = picked; else globals.dateto = picked;
      });
  }

  void redraw(){
    //print('order redraw');
    isloading=true;
    setState(() {

    });
  }

  Widget build(BuildContext context)
  { print('dialog');
  globals.tabredraw[1]=redraw;
  if (isloading) {
    showOrderList(globals.datefrom,globals.dateto);
    return LinearProgressIndicator();

  }
  else {
    return
      Column(children: <Widget>[
      Row(children: <Widget>[Text("Период с "+formatDate(globals.datefrom, [dd,'.',mm,'.',yy])),IconButton(icon: Icon(Icons.date_range), onPressed: () =>_selectDate(context,'from')),
      Text(" по "+formatDate(globals.dateto, [dd,'.',mm,'.',yy])),IconButton(icon: Icon(Icons.date_range), onPressed: () =>_selectDate(context,'to'))],),
      Expanded(
        //height: 500.0,
        child: ListView(children:
        [
          Table(
        columnWidths: {0: FlexColumnWidth(1.2),1: FlexColumnWidth(1.4),2: FlexColumnWidth(0.5),3: FlexColumnWidth(1.2),4: FlexColumnWidth(2.0),},
      border: TableBorder.all(),
      children: getOrders(getParam(json,"Заказы")),
    ),]

        ),)
    ],);
  };

  }
}

