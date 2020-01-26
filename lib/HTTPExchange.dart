//import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'globals.dart' as globals;

getParam(String JsonString,String param)
{
  //print('JSON' +JsonString);
  //JsonString= '{"Контрагент":"Атлант (РТЦ)","Тип цен":"Дилерская -7,5%","Баланс":"-281 678,53"}';
  try
  {var dec=jsonDecode(JsonString);
  return dec[param];}
  catch(error)
  {return '';}
}

class Post1c
{

  var input;
  var metod;
  var text;
  var user;
  var password;
  var state;


  HttpGet() async {
    if (metod!='auth') {
      user=globals.user;
      password=globals.password;
    }

    print("Input=" + input);
    print("Rec=" + 'http://46.34.155.26/Tehno/hs/GetBasicInfo/$user/$password/$metod/$input');//'http://46.34.155.26/dist/hs/GetBasicInfo/patamdart/170574/$metod/?$input'
    var response = await http.get('http://46.34.155.26/Tehno/hs/GetBasicInfo/$user/$password/$metod/$input',headers: {"Content-Type":"text/html; charset=utf-8" });
    print("DATAResult=" + response.body.toString());
    print("Code= "+response.statusCode.toString());
    if (response.statusCode==200){
      text=response.body;
      if (metod=='auth'){
        globals.authOK=true;
      }
      state='ok';
      return response.body;
    }
    else {
      text=response.body;
      state='error';
      return "error";
    }

  }

  HttpPost(body) async {
    if (metod!='auth') {
      user=globals.user;
      password=globals.password;
    }

    print("Input=" + input);
    print("Rec=" + 'http://46.34.155.26/dist/hs/GetBasicInfo/$user/$password/$metod/$input');//'http://46.34.155.26/dist/hs/GetBasicInfo/patamdart/170574/$metod/?$input'
    var response = await http.post('http://46.34.155.26/dist/hs/GetBasicInfo/$user/$password/$metod/$input',headers: {"Content-Type":"text/html; charset=utf-8" },body: body);
    print("DATAResult=" + response.body.toString());
    print("Code= "+response.statusCode.toString());
    if (response.statusCode==200){
      text=response.body;
      if (metod=='auth'){
        globals.authOK=true;
      }
      state='ok';
      return response.body;
    }
    else {
      text=response.body;
      state='error';
      return "error";
    }

  }

}