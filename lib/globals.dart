library flutter_app.globals;

String user='',password='',firm='';
String baseCatalog='000000001';
List basket=new List();
Map tabredraw=new Map();
bool basketChanged=false;
var screenSize;
var datefrom, dateto, curdate, currentcatalog, currentIndex=0,store,storeSet=false;
Map filters = new Map();

bool authOK=false;