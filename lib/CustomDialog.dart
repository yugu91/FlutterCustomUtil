

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'generated/i18n.dart';

class CustomDialog {
  final String msg;
  final List<String> bts;
  final String title;
  final BuildContext context;
  final bool canCancel;
  CustomDialog(this.context, {
    @required this.msg,
    this.bts,
    this.title,
    this.canCancel = true,
  });

  static CustomDialog of(BuildContext context,{
    @required String msg,
    List<String> bts,
    String title,
    bool canCancel = true,
  }){
    return CustomDialog(context,msg: msg,bts: bts,title: title,canCancel: canCancel);
  }

  Future<int> show(){
    if(Platform.isIOS){
      return showCupertinoDialog<int>(context: context, builder: (context) => _buildCuprDialog(context));
    }else{
      return showDialog<int>(context: context,builder: (context) => _buildMetDialog(context));
    }
  }

  Widget _buildMetDialog(BuildContext context){
    var actionBts = <Widget>[];
    if(bts != null)
      for(var i = 0;i < bts.length;i++){
        actionBts.add(
            FlatButton(
              child: Text(bts[i]),
              onPressed: (){
                Navigator.pop(context,i);
              },
            )
        );
      }
    if(canCancel)
      actionBts.add(FlatButton(
        child: Text(S.of(context).dialogDismiss),
        onPressed: (){
          Navigator.pop(context,-1);
        },
      ));
    // TODO: implement build
    return AlertDialog(
      title: title != null && title != "" ? Text(title) : null,
      content: Text(msg),
      actions: actionBts,
    );
  }

  Widget _buildCuprDialog(BuildContext context){
    var actionBts = <Widget>[];
    if(bts != null)
      for(var i = 0;i < bts.length;i++){
        actionBts.add(
            CupertinoButton(
              child: Text(bts[i]),
              onPressed: (){
                Navigator.pop(context,i);
              },
            )
        );
      }
    actionBts.add(CupertinoButton(
      child: Text(S.of(context).dialogDismiss),
      onPressed: (){
        Navigator.pop(context,-1);
      },
    ));
    // TODO: implement build
    return CupertinoAlertDialog(
      title: title != null && title != "" ? Text(title) : null,
      content: Text(msg),
      actions: actionBts,
    );
  }
}