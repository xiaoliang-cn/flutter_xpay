import 'dart:async';

import 'package:flutter/services.dart';

class Xpay {
  static const MethodChannel _channel = MethodChannel('com.xl/xpay');

  static Future<String?> get getAliPayVersion async {
    final String? version = await _channel.invokeMethod('aliVersion');
    return version;
  }

  static Future<String> aliPay(String order) async {
    return await _channel.invokeMethod('aliPay', {'order': order, 'payEnv': 0});
  }

  static Future<bool> aliIsAliPayInstalled() async {
    return await _channel.invokeMethod('aliIsAliPayInstalled');
  }
}

//在线支付或者沙箱
enum AliPayEvn { ONLINE, SANDBOX }
