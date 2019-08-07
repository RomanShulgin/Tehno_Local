import 'package:flutter/material.dart';
import 'HTTPExchange.dart';
import 'styledwidgets.dart';
import 'package:indexed_list_view/indexed_list_view.dart';
import 'package:flutter/scheduler.dart';

import 'globals.dart' as globals;




class PriceDialog extends StatefulWidget {
  var json;
  bool isloading=false;
  @override
  createState() => new PriceDialogState();
}

class PriceDialogState extends State<PriceDialog> {
  bool isloading=true;
  var json;

  Future showPriceInfo() async
  {
    var post=new Post1c();
    post.metod="priceinfo";
    post.input='';
    await post.HttpGet();
    json=post.text;
    print("Тип цен"+getParam(json,"ТипЦен"));
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

  Widget build(BuildContext context)
  { print('dialog');

    if (isloading) {
      showPriceInfo();
      return Scaffold(
          appBar: AppBar(title: Text('Ценообразование')),
          body:
        Column(children: <Widget>[LinearProgressIndicator(),
        RButton('Назад', (){Navigator.of(context).pop(); })
        ],
        )

    );
    }
    else {
      return Scaffold(
          appBar: AppBar(title: Text('Ценообразование')),
          body: Column(children:
          [
            Group(Text(getParam(json, "ТипЦен")), 'Тип цен'),
            Group(Text(getParam(json, "Состояние")), 'Состояние:'),
            PriceGauge(getParam(json, "Границы")),
            RButton('Назад', () {
              Navigator.of(context).pop();
            })
          ],
          ));

    };

  }
}

class PriceGauge extends StatelessWidget {
  final borders;
  var pixelcur=0.0;
  final itemsize=70.0;
  PriceGauge(this.borders);
  var controller = ScrollController();

  List getBordersList(){
    var bordersList = new List();
    for (var border in borders){
      bordersList.add(Text(border['ТипЦены']));
      if(border['Текущая']){print('Border '+borders.indexOf(border).toString());pixelcur=borders.indexOf(border)*itemsize;};
    }
    return bordersList;
  }

  void scrollToCur(){
    for (var border in borders){
      if(border['Текущая']){print('Border '+borders.indexOf(border).toString());pixelcur=borders.indexOf(border)*itemsize;};
    }
    print('Scroll '+pixelcur.toString());
    controller.animateTo(pixelcur, duration: Duration(seconds: 1),curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    SchedulerBinding.instance.addPostFrameCallback((_) => scrollToCur());
    var list = new ListView.builder
      (
        itemCount: borders.length,
        //itemExtent: 80.0,
        controller: controller,
        itemBuilder: (context, position) {
          //return ListTile(title: new Text("Number $position"));
          if(borders[position]['Текущая']){
          return ListTile(
            title:  Column(children:[
              Text('${borders[position]['ТипЦены']}'),
              LinearProgressIndicator(value: borders[position]['Прогресс'].toDouble())
            ]),
            subtitle: Text('${borders[position]['Диапазон']}'),
            selected: borders[position]['Текущая'],
          );
          }
          else
            {
              return ListTile(
                title:   Text('${borders[position]['ТипЦены']}'),
                subtitle: Text('${borders[position]['Диапазон']}'),
                selected: borders[position]['Текущая'],
                onTap: (){print(borders.length);},
              );
            }
        }
    );
    //controller.
    return Flexible(child:list);
  }

}

/*class PriceInfo extends StatelessWidget {
  final Price;
  final PriceText;
  final Limits;
  PriceInfo(this.Limits,this.Price,this.PriceText);

}*/
