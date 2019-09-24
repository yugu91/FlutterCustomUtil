
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CustomDialog.dart';
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
  static Future<int> show(BuildContext context,Exception error,[bool canReload,String title = null]) async{
    var bt = <String>[];
    if(canReload == null){
      if((error is CustomError && (error as CustomError).canReload) || error is DioError){
        bt.add("重试");
      }
    }else if(canReload == true){
      bt.add("重试");
    }
    if(title == null && error is CustomError && (error as CustomError).title != null)
      title = (error as CustomError).title;
    else if (title == null)
      title = "抱歉，遇到错误!";
    return await showDialog(
        context: context,
        builder: (_) => CustomDialog(msg: error.toString(),title: title,bts: bt)
    );
//    return await Navigator.of(context).push<int>(MaterialPageRoute<int>(
//        builder: (_) => _ErrorDialog(error: error,canReload: canReload,title: title)
//    ));
  }
}