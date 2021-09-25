import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:xpay/xpay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;

    try {
      platformVersion =
          await Xpay.getAliPayVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: GestureDetector(
          onTap: () async {
            await Xpay.aliPay(
                'alipay_sdk=alipay-sdk-java-dynamicVersionNo&app_id=2021002156668698&biz_content=%7B%22body%22%3A%22XPassword%22%2C%22out_trade_no%22%3A%22092520334011552%22%2C%22passback_params%22%3A%220.1%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%2C%22subject%22%3A%22XPasswordVip%22%2C%22timeout_express%22%3A%2260m%22%2C%22total_amount%22%3A%22200%22%7D&charset=utf-8&format=json&method=alipay.trade.app.pay&sign=RRo2c7XAVbjQpRFfWtWObt%2BrDRM%2FzA9XIhlJOsf2fKNMe9LFR2t8r36TxCdTPxdl9RW52mBeSPEZ3PpUHPRJPfsrS3M7OUfOoCRyx61gPLKjkFe0xsotl2aHhyR78aIDtZ5e%2BnLNwyB4mf9OJjQUYNqYhyGih07EvDfGKp38yq6Z8JZDewDawW1dPrxK99X7hn7jc9F%2FNrB2hGngZGoOXmtKC88x%2F3JcjhceOapLJbX21SgXqDyg%2BzGu6t5krbELboF0yiHX3Ec6PHGWo0OFiM4J0a%2F3EooQUcwhOyaXLig573ROwZhjLMx1RTBCqTKp0Oxo78r5zxw5H16TMBh9hA%3D%3D&sign_type=RSA2&timestamp=2021-09-25+20%3A33%3A40&version=1.0');
          },
          child: Center(
            child: Text('Running on: $_platformVersion\n'),
          ),
        ),
      ),
    );
  }
}
