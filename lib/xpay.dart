import 'dart:async';

import 'package:flutter/services.dart';


class Xpay {
  static const MethodChannel _channel = MethodChannel('com.xl/xpay');

  static Future<String?> get getAliPayVersion async {
    final String? version = await _channel.invokeMethod('aliVersion');
    return version;
  }
}
