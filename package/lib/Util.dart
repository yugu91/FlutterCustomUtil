
import 'dart:io';

import 'package:flutter/services.dart';
//import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
class Util{
  static final MethodChannel _channel = MethodChannel('custom_util_plugin');
  static openUrlOnBrowser(String url) async {
    await Util._channel.invokeMethod<bool>(
        'openUrl',
        <String, dynamic>{
          "url":url
        }
    );
  }
  static Future<File> chooseImage() async {
    return await ImagePicker.pickImage(source: ImageSource.gallery);
//    final MethodChannel _channel = MethodChannel('custom_util_plugin');
//    var path = await Util._channel.invokeMethod<String>(
//      "pickImage",
//      <String,dynamic>{
//        "source":"img"
//      }
//    );
//    return File(path);
  }
}