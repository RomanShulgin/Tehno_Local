//import 'dart:async';
import 'package:http/http.dart' as http;

import 'globals.dart' as globals;

class Post1c
{

  var input;
  var metod;
  var text;
  var user;
  var password;


  HttpGet() async {
    if (metod!='auth') {
      user=globals.user;
      password=globals.password;
    }

    print("Input=" + input);
    print("Rec=" + 'http://46.34.155.26/dist/hs/GetBasicInfo/$user/$password/$metod/$input');//'http://46.34.155.26/dist/hs/GetBasicInfo/patamdart/170574/$metod/?$input'
    var response = await http.get('http://46.34.155.26/dist/hs/GetBasicInfo/$user/$password/$metod/$input',headers: {"Content-Type":"text/html; charset=utf-8" });
    print("DATAResult=" + response.body.toString());
    print("Code= "+response.statusCode.toString());
    if (response.statusCode==200){
      text=response.body;
      if (metod=='auth'){
        globals.authOK=true;
      }

      return response.body;
    }
    else {
      text=response.body;
      return "error";
    }

  }

}