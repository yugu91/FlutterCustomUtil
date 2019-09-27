
//import 'dart:collection';
//import 'dart:io';

import 'package:flutter/services.dart';
//import 'package:url_launcher/url_launcher.dart';
//import 'package:image_picker/image_picker.dart';
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

  static Future<Map<String,dynamic>> getPackageInfo() async{
    return await Util._channel.invokeMethod<dynamic>(
      "getPackageInfo"
    ).then((val){
      return Future.value(Map<String,dynamic>.from(val));
    });
  }

//  static Future<File> chooseImage(ImageSource type) async {
//    return await ImagePicker.pickImage(source: type);
////    final MethodChannel _channel = MethodChannel('custom_util_plugin');
////    var path = await Util._channel.invokeMethod<String>(
////      "pickImage",
////      <String,dynamic>{
////        "source":"img"
////      }
////    );
////    return File(path);
//  }
}