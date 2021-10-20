import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
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
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    var version = await Xpay.getAliPayVersion;
                    Logger().d(version);
                  },
                  child: Text('Running on: $_platformVersion\n')),
              ElevatedButton(
                  onPressed: () async {
                    var result = await Xpay.aliPay(
                        'charset\u003dutf-8\u0026biz_content\u003d%7B%22timeout_express%22%3A%2230m%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%2C%22total_amount%22%3A1%2C%22subject%22%3A%221%22%2C%22body%22%3A%22XPassword%22%2C%22out_trade_no%22%3A%22102020465512740%22%7D\u0026method\u003dalipay.trade.app.pay\u0026app_id\u003d2021002156668698\u0026sign_type\u003dRSA2\u0026version\u003d1.0\u0026timestamp\u003d2021-10-20+20%3A46%3A55\u0026sign\u003djr0x9m9nHXYauTB94M%2FuaqKVLeEDvMvVae3rv2SAtAmELo3o7iyWNi8paGtnQc5lhcwzrdcbAl3PD3FMBRtqsdAMnnZV94Om%2FuGImkvOj6gyn2ns7KwxxdFy%2F6eoMRgkVzbNyjwspJwGSe5IzohE5AjzabQtsOkySwXDiMMl1DvuuyBi1fmFeqf%2B6M2dMn3uUKUbxd827B6bhdGxX98QHQeP6jpJi%2BSF4V8SBuPEesqm67DSOs5Rhz4LRoLqjshiTwDcG3zTfnWk2lSw4cT3FEfNcwbiIJbsi%2Blqt2vTxD%2B9fCT5g6uyrQ%2Fs1d1MUgTwddL31BdxgwsYW9rnlfLRWA%3D%3D');
                    Logger().d(result);
                  },
                  child: const Text('aliPay')),
              ElevatedButton(
                  onPressed: () async {
                    var result = await Xpay.aliIsAliPayInstalled();
                    Logger().d(result);
                  },
                  child: const Text('isInstallAliPay'))
            ],
          ),
        ),
      ),
    );
  }
}
