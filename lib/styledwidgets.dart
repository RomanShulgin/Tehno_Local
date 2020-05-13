import 'package:flutter/material.dart';

class ContP extends StatelessWidget {
  final child;

  ContP(this.child);

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.green[900], width: 2.0),
          borderRadius: BorderRadius.all(
            const Radius.circular(8.0),
          ),
        ),
        child: child);
  }
}

class ContColorSmall extends StatelessWidget {
  final child;
  final color;

  ContColorSmall(this.child, this.color);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: new Container(
          constraints: BoxConstraints.expand(height: 60.0),
          padding: new EdgeInsets.fromLTRB(4.0, 1.0, 4.0, 1.0),
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.green[900], width: 2.0),
            borderRadius: BorderRadius.all(
              const Radius.circular(8.0),
            ),
          ),
          child: child),
    );
  }
}

class ContSmall extends StatelessWidget {
  final child;

  ContSmall(this.child);

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: new EdgeInsets.fromLTRB(4.0, 1.0, 4.0, 1.0),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: child);
  }
}

class ButtonTab extends StatelessWidget {
  final columns;
  List buttons;

  ButtonTab(this.columns, this.buttons);

  Widget build(BuildContext context) {
    List<TableRow> widgetrows = new List();
    Map<int, TableColumnWidth> wights = new Map();
    for (var i = 0; i <= columns - 1; i++) {
      wights[i] = FlexColumnWidth(1.0);
    }
    int numbuttons = buttons.length;
    List<Widget> listRow = new List();
    int d = 0;
    for (var i = 1; i <= numbuttons; i++) {
      if (d == 0) {
        listRow.clear();
      }
      listRow.add(buttons[i - 1]);

      if (d == (columns - 1) || i == numbuttons) {
        for (var t = d; t <= (columns - 2); t++) {
          listRow.add(Container());
          //добиваем последний ряд
        }
        List<Widget> currentRow = new List.from(listRow);
        var tr = TableRow(children: currentRow);
        widgetrows.add(tr);
        listRow.clear();
        d = 0;
      } else
        d++;
    }

    return new Table(
      columnWidths: wights,
      children: widgetrows,
    );
  }
}

class ContSmallBorder extends StatelessWidget {
  final child;

  ContSmallBorder(this.child);

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: new EdgeInsets.fromLTRB(4.0, 1.0, 4.0, 1.0),
        margin: EdgeInsets.fromLTRB(2.0, 2.0, 3.0, 3.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.green[900], width: 2.0),
          borderRadius: BorderRadius.all(
            const Radius.circular(8.0),
          ),
        ),
        child: child);
  }
}

class ButtonDecorated extends StatelessWidget {
  final text;
  final function;
  final icon;

  ButtonDecorated(this.text, this.icon, this.function);

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
        onPressed: function,
        child: Column(
          children: <Widget>[icon, Text(text)],
        ),
      ),
    );
  }
}

class ContRaised extends StatelessWidget {
  final child;

  ContRaised(this.child);

  @override
  Widget build(BuildContext context) {
    return new Container(
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
        child: child);
  }
}

class ContWithoutBorder extends StatelessWidget {
  final child;

  ContWithoutBorder(this.child);

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: new EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
        margin: EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.green[900], width: 2.0),
          borderRadius: BorderRadius.all(
            const Radius.circular(8.0),
          ),
        ),
        child: child);
  }
}

class ContSmallMargin extends StatelessWidget {
  final child;

  ContSmallMargin(this.child);

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: new EdgeInsets.fromLTRB(4.0, 1.0, 4.0, 1.0),
        margin: EdgeInsets.fromLTRB(2.0, 2.0, 3.0, 3.0),
        child: child);
  }
}

class Check extends StatelessWidget {
  final txt, isize;

  Check(this.txt, [this.isize = 24.0]);

  @override
  Widget build(BuildContext context) {
    //print(isize);
    if (txt == 'Да' || txt == true) {
      return new Icon(
        Icons.check,
        color: Colors.green,
        size: isize,
      );
    } else {
      return new Icon(
        Icons.clear,
        color: Colors.red,
        size: isize,
      );
    }
  }
}

class Group extends StatelessWidget {
  final child;
  final annotation;

  Group(this.child, this.annotation);

  @override
  Widget build(BuildContext context) {
    return new Container(
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
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              textDirection: TextDirection.ltr,
              children: [
                //Expanded(child:
                Text(
                  annotation,
                  style: TextStyle(color: Colors.green[900]),
                  overflow: TextOverflow.clip,
                )
                //)
              ]),
          child
        ]));
  }
}

class LGroup extends StatelessWidget {
  final child;
  final annotation;

  LGroup(this.child, this.annotation);

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: new EdgeInsets.fromLTRB(3.0, 0.0, 3.0, 0.0),
        margin: EdgeInsets.fromLTRB(2.0, 2.0, 3.0, 3.0),
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
        child: Column(children: [
          Container(
              alignment: Alignment(-1.0, 0.0),
              child: Text(annotation,
                  overflow: TextOverflow.fade,
                  style: TextStyle(color: Colors.green[900]))),
          child
        ]));
  }
}

class RButton extends StatelessWidget {
  final text;
  final onpressed;

  RButton(this.text, this.onpressed);

  @override
  Widget build(BuildContext context) {
    return new RaisedButton(
      padding: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      color: Colors.orange,
      onPressed: onpressed,
      child: Text(text),
    );
  }
}

class LightButton extends StatelessWidget {
  final text;
  final onpressed;

  LightButton(this.text, this.onpressed);

  @override
  Widget build(BuildContext context) {
    return new RaisedButton(
      padding: new EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 3.0),
      //margin: EdgeInsets.fromLTRB(2.0, 2.0, 3.0, 3.0),
      color: Colors.amber[50],
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0)),
      onPressed: onpressed,
      child: Text(text),
    );
  }
}

class ChatButtonOff extends StatelessWidget {
  final text;
  final messages;
  final onpressed;

  ChatButtonOff(this.text, this.messages, this.onpressed);
  var Col;

  @override
  Widget build(BuildContext context) {
    Col = (double.parse(messages) > 0.0) ? Colors.amber : Colors.grey[50];
    return new RaisedButton(
      padding: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      color: Colors.grey[50],
      onPressed: onpressed,
      child: Row(
        children: <Widget>[
          Expanded(child: Text(text)),
          Text(
            messages,
            style: TextStyle(fontWeight: FontWeight.bold, backgroundColor: Col),
          )
        ],
      ),
    );
  }
}

class ChatButtonOn extends StatelessWidget {
  final text;
  final messages;
  final onpressed;

  ChatButtonOn(this.text, this.messages, this.onpressed);
  var Col;
  @override
  Widget build(BuildContext context) {
    Col = (double.parse(messages) > 0.0) ? Colors.amber : Colors.green[50];
    return new RaisedButton(
      padding: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      color: Colors.green[50],
      onPressed: onpressed,
      child: Row(
        children: <Widget>[
          Expanded(child: Text(text)),
          Text(messages,
              style:
                  TextStyle(fontWeight: FontWeight.bold, backgroundColor: Col))
        ],
      ),
    );
  }
}
