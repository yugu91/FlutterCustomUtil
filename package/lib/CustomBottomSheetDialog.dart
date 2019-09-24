
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttercustom/BasePlatformWidget.dart';

class CustomBottomSheetDialog{
  final BuildContext context;
  final Widget title;
  final Widget content;
  final List<Widget> actions;
  CustomBottomSheetDialog({
    this.context,
    this.title,
    this.content,
    this.actions
  });
  static CustomBottomSheetDialog of(BuildContext context,{
    Widget title,
    Widget content,
    List<Widget> actions,
  }){
    return CustomBottomSheetDialog(context: context,title: title,content: content,actions: actions);
  }

  Future<int> show(){
    if(Platform.isIOS){
      return showCupertinoModalPopup<int>(context: context, builder: (_)=> _build());
    }else{
      return showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (_)=> _build()
      );
    }
  }

  Widget _build(){
    var listActions = <CupertinoActionSheetAction>[];
    for(var i = 0;i < actions.length;i++)
      listActions.add(CupertinoActionSheetAction(
        child: actions[i],
        onPressed: () => Navigator.pop(context,i),
      ));
    return CupertinoActionSheet(
      title: title,
      message: content,
      actions: listActions,
      cancelButton: CupertinoActionSheetAction(
        child: Text("取消"),
        onPressed: () => Navigator.pop(context,-1),
      ),
    );
  }
}