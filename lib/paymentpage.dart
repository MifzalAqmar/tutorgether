import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'user.dart';

class PaymentPage extends StatefulWidget {
  final User user;
  final String orderid, val;
  PaymentPage({this.user, this.orderid, this.val});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('PAYMENT'),
          // backgroundColor: Colors.deepOrange,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: WebView(
                initialUrl:
                    'https://tutorgether.000webhostapp.com/TutorGether/php/payment.php?email=' +
                        widget.user.email +
                        '&mobile=' +
                        widget.user.phone +
                        '&name=' +
                        widget.user.name +
                        '&amount=' +
                        widget.val +
                        '&orderid=' +
                        widget.orderid,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
              ),
            )
          ],
        ));
  }
}
