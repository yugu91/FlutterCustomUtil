
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'generated/i18n.dart';

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
      return showCupertinoModalPopup<int>(context: context, builder: (context)=> _build(context));
    }else{
      return showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context)=> _build(context)
      );
    }
  }

  Widget _build(BuildContext context){
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
        child: Text(S.of(context) == null ? '取消' : S.of(context).cancel),
        onPressed: () => Navigator.pop(context,-1),
      ),
    );
  }
}