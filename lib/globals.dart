library flutter_app.globals;

String user = '', password = '', firm = '';
String baseCatalog = '000000001';
List basket = new List();
Map tabredraw = new Map();
Map bartabredraw = new Map();
var barcoderedraw;
var curentbardoc;
bool basketChanged = false;
var screenSize;
var chatLocalUser = "1. Общий чат", chatWebUser = "", emailgroup = 'Входящие';
var datefrom,
    dateto,
    curdate,
    currentcatalog,
    currentIndex = 0,
    currentBarIndex = 0,
    store,
    storeSet = false;
Map filters = new Map();
var redrawBasketIcon = null, basketKey;
int missedMessages = 0, missedEmails = 0;
int missedWebMessages = 0;
bool authOK = false;
var redrawreport;
var ipadress;
