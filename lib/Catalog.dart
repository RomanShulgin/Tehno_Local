import 'package:flutter/material.dart';
import 'HTTPExchange.dart';
import 'styledwidgets.dart';
import 'package:flutter_cache_store/flutter_cache_store.dart';
import 'Goods.dart';
import 'dart:io';
import 'dart:convert';

import 'globals.dart' as globals;

class CatGroup extends StatefulWidget {
  final child;
  final annotation;
  CatGroup(this.child, this.annotation);
  @override
  createState() => new CatGroupState();
}

class CatGroupState extends State<CatGroup> {
  var child;
  var annotation;
  var isopen = true;

  void shrink() {
    isopen = false;
    setState(() {});
  }

  void expand() {
    isopen = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    child = widget.child;
    annotation = widget.annotation;
    if (isopen) {
      return new Container(
          padding: new EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
          margin: EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                offset: Offset(1.0, 1.0),
                blurRadius: 5.0,
              ),
            ],
            border: Border.all(color: Colors.green[900], width: 1.0),
            borderRadius: BorderRadius.all(
              const Radius.circular(3.0),
            ),
          ),
          child: Column(children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                textDirection: TextDirection.ltr,
                children: [
                  IconButton(
                      icon: Icon(Icons.expand_less),
                      onPressed: () {
                        shrink();
                      }),
                  Text(
                    annotation,
                    style: TextStyle(color: Colors.green[900]),
                    overflow: TextOverflow.clip,
                  ),
                ]),
            child
          ]));
    } else {
      return new Container(
          padding: new EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
          margin: EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
          decoration: BoxDecoration(
            color: Colors.amber[50],
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                offset: Offset(1.0, 1.0),
                blurRadius: 5.0,
              ),
            ],
            border: Border.all(color: Colors.green[900], width: 1.0),
            borderRadius: BorderRadius.all(
              const Radius.circular(3.0),
            ),
          ),
          child: ListView(children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                textDirection: TextDirection.ltr,
                children: [
                  //Expanded(child:
                  IconButton(
                      icon: Icon(Icons.expand_more),
                      onPressed: () {
                        expand();
                      }),
                  Text(
                    annotation,
                    style: TextStyle(color: Colors.green[900]),
                    overflow: TextOverflow.clip,
                  ),

                  //)
                ]),
            //child
          ]));
    }
  }
}

class ImageCat extends StatelessWidget {
  final data;
  ImageCat(this.data);

  Future getCatIcon(imageaddr, route) async {
    var store = globals.store;
    final file = await store.getFile(imageaddr, key: route);
    var lenght = await file.length();
    //print('size of file ' + file.path + ' ' + lenght.toString());
    return file;
  }

  @override
  Widget build(BuildContext context) {
    String user = globals.user;
    String password = globals.password;
    String code = data['Код'];
    var size = data['ИконкаРазмер'];
    var imageaddr =
        'http://46.34.155.26/dist/hs/GetBasicInfo/$user/$password/caticon/?code=$code&size=$size';
    var route = '$code/$size';
    return FutureBuilder(
        future: getCatIcon(imageaddr, route),
        builder: (context, snapshots) {
          if (snapshots.hasError) return Icon(Icons.photo_camera);
          switch (snapshots.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              return Expanded(
                child: Image.file(snapshots.data),
              );
            case ConnectionState.none:
              return Center();
          }
        });
  }
}

class CatBlock extends StatelessWidget {
  final data;
  final annotation;
  final code;
  var textSize = 0.9;

  CatBlock(this.data, this.annotation, this.code);

  @override
  Widget build(BuildContext context) {
    if (annotation.toString().length > 20) {
      textSize = 0.6;
    }
    ;
    return new InkWell(
        highlightColor: Colors.amber,
        onTap: () {
          globals.currentcatalog = code;
          Navigator.pushNamed(context, '/Home');
        },
        child: Container(
            padding: new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            margin: EdgeInsets.fromLTRB(2.0, 2.0, 3.0, 3.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(1.0, 1.0),
                  blurRadius: 5.0,
                ),
              ],
              border: Border.all(color: Colors.green[900], width: 1.0),
              borderRadius: BorderRadius.all(
                const Radius.circular(3.0),
              ),
            ),
            child: Column(children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: TextDirection.ltr,
                  children: [
                    Expanded(
                        child: Container(
                            height: 35,
                            child: Text(
                              annotation,
                              style: TextStyle(
                                  color: Colors.green[900],
                                  fontWeight: FontWeight.bold),
                              textScaleFactor: textSize,
                              overflow: TextOverflow.clip,
                            )))
                  ]),
              ImageCat(data)
            ])));
  }
}

class overGroup extends StatefulWidget {
  var data;
  overGroup(this.data);
  createState() => new overGroupState();
}

class overGroupState extends State<overGroup> {
  var data;

  listOfTiles(groups) {
    var itemG;
    List<Widget> groupList = new List<Widget>();
    for (var group in groups) {
      itemG = itemGroup(group);
      groupList.add(itemG);
    }
    return groupList;
    /*/Expanded(
        ListView(
      shrinkWrap: true,
      children: groupList,
    //)
    );*/
  }

  Widget build(BuildContext context) {
    data = widget.data;
    var groups = data['Группы'];
    var itemG;
    var groupList = listOfTiles(groups);

    //print(groupList.)
    return ContSmallBorder(ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        data['Наименование'],
      ),
      backgroundColor: Colors.amber[50],
      children: groupList,
    )); //CatGroup(itemG, data['Наименование']);
  }
}

class itemGroup extends StatefulWidget {
  var data;
  itemGroup(this.data);
  createState() => new itemGroupState();
}

class itemGroupState extends State<itemGroup> {
  var data;

  Widget build(BuildContext context) {
    data = widget.data;
    var items = data['Элементы'];
    var title = "------------------------";
    List itemList = new List<Widget>();
    String user = globals.user;
    String password = globals.password;
    var src = data['Наименование'];

    var imageaddr =
        'http://46.34.155.26/dist/hs/GetBasicInfo/$user/$password/groupicon/?name=$src';
    if (src != "Остальное") title = src;
    for (var item in items) itemList.add(nomItem(item));
    return ExpansionTile(
      title: Text(title),
      leading: Image.network(imageaddr),
      children: itemList,
    ); //CatGroup(Text('Items'), data['Наименование']);
  }
}

class findBCWidget extends StatefulWidget {
  createState() => new findBCWidgetState();
}

class findBCWidgetState extends State<findBCWidget> {
  final txt1 = TextEditingController();
  bool isloading = false;
  bool loaded = false;
  List<Widget> foundNom = new List();
  var json;
  var data;

  Future getListByCode(code) async {
    var post = new Post1c();
    post.metod = "findbycode";
    post.input = '?code=' + code;
    await post.HttpGet();
    json = post.text;
    isloading = false;
    print(post.state);
    if (post.state == 'ok') {
      data = jsonDecode(json);
      loaded = true;
      foundNom.clear();
      foundNom.add(Text("Найдено."));
      foundNom.add(nomItem(data));
      setState(() {});
    } else {
      loaded = false;
      foundNom.clear();
      foundNom.add(Text("Не найдено."));
      setState(() {});
    }
  }

  Widget build(BuildContext context) {
    /*if(loaded==false)
      { foundNom.clear();
        foundNom.add(Text("Не найдено."));}
    else
      {
      }*/

    return new Column(
      children: <Widget>[
        LGroup(
            Row(children: [
              Expanded(
                  child: TextFormField(
                controller: txt1,
                style: TextStyle(fontSize: 24.0),
              )),
              ContWithoutBorder(IconButton(
                  icon: Icon(Icons.search, color: Colors.green[900]),
                  onPressed: () {
                    getListByCode(txt1.text);
                  }))
            ]),
            'Введите код'),
        Column(
          // shrinkWrap: true,
          children: foundNom,
        )
      ],
    );
  }
}

void findByCode(context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return WillPopScope(
          child: AlertDialog(
            //title: new Text("Поиск по коду"),
            contentPadding: EdgeInsets.all(5.0),
            content: findBCWidget(),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          onWillPop: () {
            Navigator.of(context).pop();
          });
    },
  );
}

class filterWidget extends StatefulWidget {
  var structCode, selected;
  filterWidget(this.structCode, this.selected);
  createState() => new filterWidgetState();
}

class filterWidgetState extends State<filterWidget> {
  final txt1 = TextEditingController();
  bool isloading = true;
  bool loaded = false;
  List<Widget> paramList = new List();
  Map<String, String> ParaMap=new Map();
  Map<String,List> AvailPar=new Map();//доступные для выбора параметры
  var json;
  var data;

  Future getParByCode(code) async {
    var post = new Post1c();
    post.metod = "structbycode";
    post.input = '?code=' + code;
    await post.HttpGet();
    json = post.text;
    isloading = false;
    //print(post.text);
    if (post.state == 'ok') {
      data = jsonDecode(json);
      loaded = true;
      if (globals.filters.containsKey(code)) {
        //параметры уже задавались
        ParaMap = globals.filters[code];
      } else {
        for(var par in data["Структура"]){
          ParaMap[par]=null;//забиваем пустыми фильтрами по умолчанию
        }
      }
      await getAvailParByCode(code,'');
      setState(() {});
    } else {
      loaded = false;
      setState(() {});
    }
  }

  Future getAvailParByCode(code,parameter) async {
    String paramstring='';
    var post = new Post1c();
    int num=0;
    for(var el in ParaMap.values){
      num++;
      if(el!=null)
      if(el.isNotEmpty)
      paramstring=paramstring+'Измерение'+num.toString()+"="+el+";";
    }

    post.metod = "availparbycode";
    post.input = '?code=' + code+'&list='+paramstring+'&parameter='+parameter;
    await post.HttpGet();
    json = post.text;
    isloading = false;
    //print(post.text);



    if (post.state == 'ok') {
      data = jsonDecode(json);
      var struct=data["Структура"];

      loaded = true;
      num=0;
      for(var par in ParaMap.keys){//ключи уже должны быть заданы...
        num++;
        AvailPar[par]=struct['Измерение'+num.toString()];
      }
      setState(() {});
    } else {
      loaded = false;
      setState(() {});
    }
  }

  Widget build(BuildContext context) {
    if (isloading) {
      getParByCode(widget.structCode);
      //getAvailParByCode(widget.structCode);
      return LinearProgressIndicator();
    } else {
      //print(data['Структура']);

      //for(var ap in )
      paramList.clear();
      for (var par in ParaMap.keys){
        List<DropdownMenuItem>DDMI=new List();
        if(AvailPar[par]!=null)
          for(var ap in AvailPar[par])
            DDMI.add(DropdownMenuItem(child: Text(ap),value: ap));
        paramList.add(
            LGroup(
                Center(
                  child: Row(
                    children: <Widget>[
                      DropdownButton(
                        items: DDMI,
                        value: ParaMap[par],
                        onChanged: (value){setState(() {ParaMap[par]=value; globals.filters[widget.structCode]=ParaMap; getAvailParByCode(widget.structCode,par);});},
                        hint: Text('Выберите фильтр.......'),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.highlight_off,
                            size: 35.0,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {ParaMap[par]=null; globals.filters[widget.structCode]=ParaMap;getAvailParByCode(widget.structCode,par);});
                          }),
                    ],
                  ),
                )
                ,par));
      }
    }

    return new SingleChildScrollView(child:Column(children: paramList));
  }
}

void filter(structCode, selected, context,redraw) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return WillPopScope(
          child: AlertDialog(
            //title: new Text("Поиск по коду"),
            contentPadding: EdgeInsets.all(5.0),
            content: filterWidget(structCode, selected),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Применить"),
                onPressed: () {
                  redraw();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          onWillPop: () {
            Navigator.of(context).pop();
          });
    },
  );
}

String getParamText(data) {
  var params = data['Параметры'];
  String paramString = '';
  for (var par in params.entries) {
    if (par.value['Значение'] != data['Наименование']) {
      paramString = paramString + ' ' + par.value['Значение'];
    }
  }
  return paramString;
}

class nomItem extends StatelessWidget {
  var data, redraw;
  nomItem(this.data, [this.redraw]);
  Widget build(BuildContext context) {
    String user = globals.user;
    String password = globals.password;
    var src = data['Наименование'];
    var imageaddr =
        'http://46.34.155.26/dist/hs/GetBasicInfo/$user/$password/groupicon/?name=$src';
    var paramText = getParamText(data);
    return new InkWell(
        onTap: () {
          dialogGoodsCard(data['Код'], 'Parametric', context, data['Параметры'],
              data['Наименование'], redraw); //
        },
        child: ContSmallBorder(
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Image.network(imageaddr),
              Expanded(
                  child: Container(
                      //height: 35,
                      child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  //Text(data['Код']),
                  Text(data['Наименование']),
                  Text(
                    paramText,
                    textScaleFactor: 0.8,
                    overflow: TextOverflow.fade,
                  ),
                ],
              )))
            ],
          ),
        ));
  }
}

class Catalog extends StatefulWidget {
  //var struct;//содержит структуру с номером и датой
  //Order(this.struct);

  bool isloading = false;
  @override
  createState() => new CatalogState();
}

class CatalogState extends State<Catalog> {
  bool isloading = true;
  var json;

  Future showCatalog(current) async {
    var post = new Post1c();
    var ParaMap;
    var paramstring='';
    if (globals.filters.containsKey(current)) {
      //параметры уже задавались
      ParaMap = globals.filters[current];
      int num=0;
      for(var el in ParaMap.values){
        num++;
        if(el!=null)
          if(el.isNotEmpty)
            paramstring=paramstring+'Измерение'+num.toString()+"="+el+";";
      }

    }


    post.metod = "catalog";
    post.input = '?current=' + current + '&list=' +paramstring;
    await post.HttpGet();
    json = post.text;
    isloading = false;
    setState(() {});
  }


  bool catBack() {
    isloading = true;
    var parentCode = getParam(json, 'КодРодителя');
    var code = getParam(json, 'Код');

    //globals.currentcatalog=parentCode;
    if (code != globals.baseCatalog) {
      Navigator.pop(context); //pushNamed(context, '/Home');
    }

    //showCatalog(parentCode);
  }

  bool catHome() {
    isloading = true;

    globals.currentcatalog = globals.baseCatalog;
    Navigator.pushNamed(context, '/Home');

    //showCatalog(parentCode);
  }

  List getCatalogList(strings) {
    List catalogList = new List<Widget>();

    for (var doc in strings) {
      catalogList.add(CatBlock(doc, doc['Наименование'], doc['Код']));
    }
    return catalogList;
  }

  Widget CatalogGroups() {
    var groups = getParam(json, 'Группы');
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.more),
                onPressed: () {
                  catBack();
                }),
            IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  catHome();
                }),
            RaisedButton(
              padding: new EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 3.0),
              //margin: EdgeInsets.fromLTRB(2.0, 2.0, 3.0, 3.0),
              color: Colors.amber[50],
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              onPressed: () {
                findByCode(context);
              },
              child: Text("Поиск по коду"),
            )
          ],
        ),
        Expanded(
          //height: 500.0,
          child: GridView.count(
            crossAxisCount: 3,
            children: getCatalogList(groups),
          ),
        )
      ],
    );
  }

  List getCatalogItemList(data) {
    List<Widget> overgroupList = new List<Widget>();
    for (var overgroup in data) {
      overgroupList.add(overGroup(overgroup));
    }
    return overgroupList;
  }

  void redraw(){
    print('redraw catalog');
    setState(() {isloading=true;

    });
  }

  Widget CatalogItemList() {
    var overgroups = getParam(json, 'Сверхгруппы');
    var structCode = getParam(json, "Код");

    Map selected;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.more),
                onPressed: () {
                  catBack();
                }),
            IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  catHome();
                }),
            RaisedButton(
              padding: new EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 3.0),
              //margin: EdgeInsets.fromLTRB(2.0, 2.0, 3.0, 3.0),
              color: Colors.amber[50],
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              onPressed: () {
                filter(structCode, selected, context,redraw);

              },
              child: Text("Фильтр"),
            ),
           // Text(structCode),
          ],
        ),
        Expanded(
            child: SingleChildScrollView(
          //shrinkWrap: true,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: getCatalogItemList(overgroups)),
        )),
      ],
    );
  }

  Widget build(BuildContext context) {
    //print('dialog');
    globals.tabredraw[2]=redraw;
    if (isloading) {
      showCatalog(globals.currentcatalog);
      return LinearProgressIndicator();
    } else {
      if (getParam(json, 'ЭтоГруппа'))
        return CatalogGroups();
      else
        return CatalogItemList();
    }
    ;
  }
}
