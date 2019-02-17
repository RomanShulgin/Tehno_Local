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

class RButton extends StatelessWidget {
  final text;
  final onpressed;

  RButton(this.text,this.onpressed);

  @override
  Widget build(BuildContext context) {
    return new RaisedButton(
        padding: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        color: Colors.orange,
        onPressed:onpressed,
        child: Text(text),
        );
  }
}