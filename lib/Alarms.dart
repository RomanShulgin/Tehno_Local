import 'package:flutter/material.dart';

Future<void> PopUpInfo(title, text, context) {
  print('Popup fired');
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      print('Popup fired2');
      return AlertDialog(
        title: Text(title),
        content: Text(text),
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

Future<void> PopUpDialog(title, text, buttons, context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: buttons,
      );
    },
  );
}

Future<void> PopUpFiles(title, buttons, context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        //content: Text(text),
        actions: buttons,
      );
    },
  );
}
