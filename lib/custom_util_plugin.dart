import 'dart:async';

import 'package:flutter/services.dart';

class CustomUtilPlugin {
  static const MethodChannel _channel =
      const MethodChannel('custom_util_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
