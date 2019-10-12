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
  CustomError(String msg,{
    this.title,
    this.canReload,
    this.result
    }){
     this.msg = msg;
  }

  String toString() {
    return msg;
  }

  @override
  // TODO: implement stackTrace
  StackTrace get stackTrace => null;
}

class HandleError {
  static Future<int> show(BuildContext context,Error error,[bool canReload,String title = null]){
    var bt = <String>[];
    if(canReload == null){
      if((error is CustomError && error.canReload) || error is DioError){
        bt.add(S.of(context).errorTryAgain);
      }
    }else if(canReload == true){
      bt.add(S.of(context).errorTryAgain);
    }
    if(title == null && error is CustomError && error.title != null)
      title = error.title;
    else if (title == null)
      title = S.of(context).errorTitle;
    return CustomDialog.of(context, msg: error.toString(),title: title,bts: bt).show();
  }
}