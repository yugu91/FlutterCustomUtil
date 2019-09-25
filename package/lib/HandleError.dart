import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CustomDialog.dart';
import 'generated/i18n.dart';
class CustomError implements Exception{
  String msg;
  bool canReload;
  String title;
  CustomError(String msg,{bool canReload = false,String title}){
     this.msg = msg;
     this.canReload = canReload;
     this.title = title;
  }

  String toString() {
    return msg;
  }
}

class HandleError {
  static Future<int> show(BuildContext context,Exception error,[bool canReload,String title = null]){
    var bt = <String>[];
    if(canReload == null){
      if((error is CustomError && (error as CustomError).canReload) || error is DioError){
        bt.add(S.of(context).errorTryAgain);
      }
    }else if(canReload == true){
      bt.add(S.of(context).errorTryAgain);
    }
    if(title == null && error is CustomError && (error as CustomError).title != null)
      title = (error as CustomError).title;
    else if (title == null)
      title = S.of(context).errorTitle;
    return CustomDialog.of(context, msg: error.toString(),title: title,bts: bt).show();
  }
}