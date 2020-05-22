import 'package:custom_util_plugin/ApplicationStart.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CustomDialog.dart';
import 'generated/i18n.dart';
class CustomError implements Error{
  String msg;
  final bool canReload;
  final String title;
  final dynamic result;
  final StackTrace stackTrace;
  CustomError(String msg,{
    this.title,
    this.canReload,
    this.result,
    this.stackTrace,
    }){
     this.msg = msg;
  }

  String toString() {
    return msg;
  }
}

class HandleError {
  static Future<int> show(
      BuildContext context,
      Error error,
      {
        bool canReload,
        String title = null,
        bool canSupport = false
      }
  ){
    var bt = <String>[];
    var lng = S.of(context);
    if(canReload == null){
      if((error is CustomError && error.canReload) || error is DioError){
        bt.add(lng.errorTryAgain);
      }
    }else if(canReload == true){
      bt.add(lng.errorTryAgain);
    }
    if(title == null && error is CustomError && error.title != null)
      title = error.title;
    else if (title == null)
      title = S.of(context).errorTitle;
    return CustomDialog.of(context, msg: error.toString(),title: title,bts: bt,canSupport: canSupport).show();
  }
}