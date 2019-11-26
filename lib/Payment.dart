import 'package:flutter/cupertino.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'styledwidgets.dart';
import 'package:flutter/material.dart';

import 'Alarms.dart';

class Payment extends StatelessWidget {
  final struct;
  Payment(this.struct);



  Widget build(BuildContext context)
  {
    print('Payment');

  return new WebviewScaffold(
      appBar: AppBar(title: Text('Оплата')),
      url: Uri.encodeFull('https://3dsec.sberbank.ru/payment/docsite/payform-1.html?token=YRF3C5RFICWISEWFR6GJ&def=%7B%22amount%22:%22'+struct['Sum']+'%22%7D&def=%7B%22description%22:%22'+struct['Order']+'%22%7D&ask=email'),//'http://tehno-parts.ru/MyScript/SberPay.php',//'https://3dsec.sberbank.ru/payment/docsite/payform-1.html?token=YRF3C5RFICWISEWFR6GJ&def=%7B"amount":"'+struct['Sum']+'"%7D&def=%7B%22description%22:"'+struct['Order']+'"%7D&ask=email',//
      withZoom: false,
      allowFileURLs: true,
      withLocalStorage: true,
      persistentFooterButtons: <Widget>[LightButton("Закрыть", () {Navigator.of(context).pop();})],
      hidden: true,
      initialChild: Container(
          color: Colors.amber,
          child: const Center(child: Text('Идет обработка.')))
  );

  }
}

String refString(String unString){
  unString=unString.toString();
  unString=unString.replaceAll(',','.');
  unString= unString.replaceAll(' ','');
  unString= unString.replaceAll('\u00A0','');
  unString= unString.replaceAll('\u00a9','');
  return unString;
}

/*
_makeStripePayment() async {
  var environment = 'rest'; // or 'production'

  if (!(await FlutterGooglePay.isAvailable(environment))) {
    _showToast(scaffoldContext, 'Google pay not available');
  } else {
    PaymentItem pm = PaymentItem(
        stripeToken: 'pk_test_1IV5H8NyhgGYOeK6vYV3Qw8f',
        stripeVersion: "2018-11-08",
        currencyCode: "usd",
        amount: "0.10",
        gateway: 'stripe');

    FlutterGooglePay.makePayment(pm).then((Result result) {
      if (result.status == ResultStatus.SUCCESS) {
        _showToast(scaffoldContext, 'Success');
      }
    }).catchError((dynamic error) {
      _showToast(scaffoldContext, error.toString());
    });
  }
}*/

/*makePayment(struct,context){
  makeCustomPayment(struct,context);
}

String refString(String unString){
  unString=unString.toString();
  unString=unString.replaceAll(',','.');
  unString= unString.replaceAll(' ','');
  unString= unString.replaceAll('\u00A0','');
  unString= unString.replaceAll('\u00a9','');
  return unString;
}

makeCustomPayment(struct,context) async {
  var environment = 'TEST'; // or 'production'

  if (!(await FlutterGooglePay.isAvailable(environment))) {
    PopUpDialog('Payment','Google pay not available',context );
  } else {
    ///docs https://developers.google.com/pay/api/android/guides/tutorial
    PaymentBuilder pb = PaymentBuilder()
      ..addGateway("example")//, "exampleMerchantId"
      ..addTransactionInfo(struct['Sum'], "RUB")
      ..addAllowedCardAuthMethods(["PAN_ONLY", "CRYPTOGRAM_3DS"])
      ..addAllowedCardNetworks(
          ["MASTERCARD", "VISA"])
      ..addBillingAddressRequired(true)
      ..addPhoneNumberRequired(true)
      ..addShippingAddressRequired(false)
      ..addShippingSupportedCountries(["RU"])
      ..addMerchantInfo("Example");
  var paym=pb.build();
    FlutterGooglePay.makeCustomPayment(paym).then((Result result) {
      if (result.status == ResultStatus.SUCCESS) {
        PopUpDialog('Payment','Success',context );
      } else if (result.error != null) {
        PopUpDialog('Payment',result.error,context);
      }
    }).catchError((error) {
      //TODO
    });
  }
}*/