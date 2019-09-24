

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatefulWidget {
  final String msg;
  final List<String> bts;
  final String title;

  CustomDialog({
    Key key,
    @required this.msg,
    this.bts,
    this.title
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    if(Platform.isIOS) {
      return _CustomDialogState();
    }else{
      return _MetCustomDialogState();
    }
  }
}
class _MetCustomDialogState extends State<CustomDialog>{
  @override
  Widget build(BuildContext context) {
    var actionBts = <Widget>[];
    if(widget.bts != null)
      for(var i = 0;i < widget.bts.length;i++){
        actionBts.add(
            FlatButton(
              child: Text(widget.bts[i]),
              onPressed: (){
                Navigator.pop(context,i);
              },
            )
        );
      }
    actionBts.add(FlatButton(
      child: const Text("关闭"),
      onPressed: (){
        Navigator.pop(context,-1);
      },
    ));
    // TODO: implement build
    return AlertDialog(
      title: widget.title != null && widget.title != "" ? Text(widget.title) : null,
      content: Text(widget.msg),
      actions: actionBts,
    );
  }
}

class _CustomDialogState extends State<CustomDialog>{
  @override
  Widget build(BuildContext context) {
    var actionBts = <Widget>[];
    if(widget.bts != null)
      for(var i = 0;i < widget.bts.length;i++){
        actionBts.add(
            CupertinoButton(
              child: Text(widget.bts[i]),
              onPressed: (){
                Navigator.pop(context,i);
              },
            )
        );
      }
    actionBts.add(CupertinoButton(
      child: const Text("关闭"),
      onPressed: (){
        Navigator.pop(context,-1);
      },
    ));
    // TODO: implement build
    return CupertinoAlertDialog(
      title: widget.title != null && widget.title != "" ? Text(widget.title) : null,
      content: Text(widget.msg),
      actions: actionBts,
    );
  }
}