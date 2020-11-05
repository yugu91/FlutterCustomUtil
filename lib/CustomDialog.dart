

import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'generated/i18n.dart';

class CustomDialog {
  final String msg;
  final List<String> bts;
  final String title;
  final BuildContext context;
  final bool canCancel;
  final bool canSupport;
  CustomDialog(this.context, {
    @required this.msg,
    this.bts,
    this.title,
    this.canCancel = true,
    this.canSupport = false,
  });

  static CustomDialog of(BuildContext context,{
    @required String msg,
    List<String> bts,
    String title,
    bool canCancel = true,
    bool canSupport = false,
  }){
    return CustomDialog(context,msg: msg,bts: bts,title: title,canCancel: canCancel,canSupport: canSupport);
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
        child: Text(S.of(context) == null ? "关闭" : S.of(context).dialogDismiss),
        onPressed: (){
          Navigator.pop(context,-1);
        },
      ));
    if(canSupport){
      actionBts.add(FlatButton(
        child: Text(S.of(context).kefu),
        onPressed: (){
          Navigator.pop(context,-2);
        },
      ));
    }
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
            CupertinoDialogAction(
              child: Text(bts[i]),
              onPressed: (){
                Navigator.pop(context,i);
              },
            )
        );
      }
    if(canSupport){
      actionBts.add(CupertinoDialogAction(
        isDefaultAction: true,
        child: Text(S.of(context).kefu),
        onPressed: (){
          Navigator.pop(context,-2);
        },
      ));
    }

    actionBts.add(CupertinoDialogAction(
      isDefaultAction: true,
      child: Text(S.of(context) == null ? "关闭" : S.of(context).dialogDismiss),
      onPressed: (){
        Navigator.pop(context,-1);
      },
    ));
    return Container(
      color: Color.fromARGB(70, 166, 166, 166),
      child: CupertinoAlertDialog(
        title: title != null && title != "" ? Text(title) : null,
        content: Text(msg),
        actions: actionBts,
      ),
    ) ;
  }
}