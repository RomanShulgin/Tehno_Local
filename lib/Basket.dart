import 'package:flutter/material.dart';
import 'HTTPExchange.dart';
import 'styledwidgets.dart';
import 'Goods.dart';
import 'Catalog.dart';
import 'globals.dart' as globals;
import 'dart:convert';

void dialogBasket(code, name, price, parameters, redraw, context) {
  // flutter defined function
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return WillPopScope(
          child: AlertDialog(
            //title: new Text("Номенклатура"),
            content: BasketAdd(code, name, price, parameters),
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
          ),
          onWillPop: () {
            if (redraw != null) {
              redraw();
            }
            Navigator.of(context).pop();
          });
    },
  );
}

class BasketAdd extends StatefulWidget {
  var code;
  var name;
  var parameters;
  var price;
  BasketAdd(this.code, this.name, this.price, this.parameters);
  @override
  createState() => new BasketAddState();
}

class BasketAddState extends State<BasketAdd> {
  final txt1 = TextEditingController();
  var code, name, parameters, price;
  double amountOur() {
    if (globals.basket.isEmpty) return 0;
    var code = widget.code;

    for (var el in globals.basket)
      if (el['code'] == code) {
        return el['amount'].toDouble();
      }

    return 0.0;
  }

  addToBasket() {
    for (var el in globals.basket)
      if (el['code'] == code) {
        el['amount'] = el['amount'] + 1;
        txt1.text = el['amount'].toString();
        return el['amount'].toDouble();
      }

    Map el = {
      "code": code,
      "amount": 1,
      "name": name,
      "price": price,
      "parameters": parameters
    };
    globals.basket.add(el);
    txt1.text = el['amount'].toString();
    return 1.0;
  }

  reduceInBasket(amount) {
    var code = widget.code;

    for (var el in globals.basket)
      if (el['code'] == code) {
        if (el['amount'] > 0) {
          if (amount == 0)
            el['amount'] = 0;
          else
            el['amount'] = el['amount'] - amount;

          txt1.text = el['amount'].toString();
          return el['amount'].toDouble();
        } else {
          txt1.text = el['amount'].toString();
          return el['amount'];
        }
      }

    return 0.0;
  }

  Widget build(BuildContext context) {
    double amount;
    amount = amountOur();
    txt1.text = amount.toString();
    code = widget.code;
    name = widget.name;
    parameters = widget.parameters;
    price = widget.price;
    return Row(
      children: [
        //Text("Заказать:"),
        Container(
            width: 50,
            child: ContSmallBorder(TextFormField(
              controller: txt1,
              style: TextStyle(fontSize: 18.0),
            ))),
        IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              size: 35.0,
            ),
            onPressed: () {
              addToBasket();
              setState(() {});
            }),
        IconButton(
            icon: Icon(
              Icons.remove_circle_outline,
              size: 35.0,
            ),
            onPressed: () {
              reduceInBasket(1);
              setState(() {});
            }),
        IconButton(
            icon: Icon(
              Icons.highlight_off,
              size: 35.0,
              color: Colors.red,
            ),
            onPressed: () {
              reduceInBasket(0);
              setState(() {});
            }),
      ],
    );
  }
}

class Basket extends StatefulWidget {
  @override
  createState() => new BasketState();
}

class BasketState extends State<Basket> {
  void redraw() {
    setState(() {});
  }

  List<TableRow> getBasketList() {
    //List<Widget> blist = new List();
    var bordersList = new List<TableRow>();

    for (var el in globals.basket) {
      if (el['amount'] == 0) continue;

      Map struct = new Map();
      //Map struct = {"Код": el['code'], "Номенклатура":el['name'],"Параметры":el['parameters']};
      struct['Код'] = el['code'];
      struct['Наименование'] = el['name'];
      struct['Параметры'] = el['parameters'];
      bordersList.add(TableRow(
        //decoration: BoxDecoration(border: Border.all(color: Colors.green[900], width: 1.0), ),
        children: <Widget>[
          TableCell(
              //width: 100,
              child: nomItem(struct, redraw)),
          TableCell(child: BasketSum(el, redraw))
        ],
      ));
    }
    //суммарно
    bordersList.add(TableRow(
      decoration: BoxDecoration(color: Colors.amber[50]),
      children: <Widget>[
        TableCell(
            //width: 100,
            child: Text(
          "Всего в корзине",
        )),
        TableCell(child: BasketSum('all', redraw))
      ],
    ));
    return bordersList;
  }

  Future addOrder(isOrder) async
  {
    var post=new Post1c();
    post.metod="sendneworder";
    var jsontext=json.encode(globals.basket);
    print(jsontext);
    post.input='?isorder='+isOrder.toString();
    await post.HttpPost(jsontext);
    var jsont=post.text;
    if (post.state == 'ok') {
      var data = jsonDecode(jsont);
       showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Создан новый КП'),
              content: Text('Создан новый КП №'+data['Номер']),
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

  void onTabTapped(int index) {
    if(index==0)
      addOrder(true);
    else
      addOrder(false);
  }

  Widget build(BuildContext context) {
    var basketList = getBasketList();

    return Scaffold(
      appBar: AppBar(title: Text('Корзина'), actions: <Widget>[
        new IconButton(
          icon: new Icon(Icons.autorenew),
          onPressed: () {
            setState(() {});
          },
        )
      ]),
      body: //Column(
          // children: <Widget>[
          SingleChildScrollView(
        child: Table(
            columnWidths: {0: FlexColumnWidth(1.0), 1: FixedColumnWidth(120.0)},
            //shrinkWrap: true,
            children: basketList),
      ),
      /*RButton('Назад', () {
              Navigator.of(context).pop();
            })*/
      //  ],
      bottomNavigationBar: new BottomNavigationBar(onTap: onTabTapped, items: [
        new BottomNavigationBarItem(
          icon: new Icon(Icons.input),
          title: new Text("Отправить заказ"),
        ),
        new BottomNavigationBarItem(
          icon: new Icon(Icons.edit),
          title: new Text("Сохранить черновик"),
        ),
      ]),
    );
  }
}

class BasketSum extends StatelessWidget {
  var position;
  var redraw;
  var amount = 0;
  var sum = 0.0;
  var ed= 'руб.';

  BasketSum(this.position, this.redraw);
  @override
  Widget build(BuildContext context) {

    if (position == 'all') {
      for (var el in globals.basket) {
        amount = amount + el['amount'];
        sum = sum + (el["amount"] * (double.tryParse(el["price"])??0));
        ed = 'руб.';
      };
      sum=(sum*100).roundToDouble();
      sum=sum/100;
    } else {
      sum = double.tryParse(position[
          "price"])??0; //position["amount"] * double.parse(position["price"]);
      amount = position["amount"];
      ed = 'р/шт.';
      //var price=position["price"].toString();
    }

    return InkWell(
        onTap: () {
          if (position != 'all') {
            dialogBasket(position['code'], position['name'], position['price'],
                position['parameters'], redraw, context);
            //redraw();
          }
        },
        child: ContSmallMargin(Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  amount.toString() + ' шт.',
                  textScaleFactor: 1.2,
                ),
                //Icon(Icons.clear),
              ],
            ),
            Row(children: [
              Text(
                sum.toString(), //position["price"].toString(),
                textScaleFactor: 1.0,
              ),
              Text(
                ed,
                textScaleFactor: 0.8,
              )
            ])
          ],
        )));
  }
}
