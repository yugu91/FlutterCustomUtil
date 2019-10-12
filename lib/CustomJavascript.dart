
import 'dart:convert';

import 'package:custom_util_plugin/CustomDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

typedef void CustomJavascriptHandler(BuildContext context,WebViewController controller,JavascriptMessage message);

abstract class CustomJavascriptDelegate{
  WebViewController controller;
  List<JavascriptChannel> _channels = [];
  final String _wkCallBack = "wkcallBack(\"{tag}\",\"{val}\");";
  final String _wkCallBackFail = "wkCallBackFail(\"{tag}\",\"{msg}\");";
  void reload(){
    controller.reload();
  }
  void returnBack(){
    Navigator.of(context).pop();
  }
  void runScript(String js){
    controller.evaluateJavascript(js);
  }
  void _callBack(String tag,String val){
    controller.evaluateJavascript(
        _wkCallBack.replaceAll("{tag}", tag).replaceAll("{msg}", val)
    );
  }

  void _callBackFail(String tag,String err){
    controller.evaluateJavascript(
        _wkCallBackFail.replaceAll("{tag}", tag).replaceAll("{msg}", err)
    );
  }

  void alert(String tag,String title, String msg, List<String> bt) {
    // TODO: implement alert
    CustomDialog.of(context, msg: msg,title: title,bts: bt).show().then((val){
      _callBack(tag, val.toString());
    });
  }


  Future<String> loadServer({
    bool isPost = false,
    @required String path,
    @required Map<String,Object> parame,
  });

  final BuildContext context;
  CustomJavascriptDelegate(
    this.context
  ){
    _init();
  }

  void add(String name,CustomJavascriptHandler func){
    _channels.add(JavascriptChannel(
      name: name,
      onMessageReceived: (message){
        func(context,controller,message);
      }
    ));
  }

  void _init(){
    add("reload", (_,__,___) => this.reload());
    add("returnBack",(_,__,___) => this.returnBack());
    add("alert",(_,__,message){
      Map<String,Object> val = json.decode(message.message);
      if(val["tag"] == null) {
        this.alert("", "sorry", "tag is null", []);
        return;
      }
      if(val["msg"] == null) {
        this.alert("", "sorry", "msg is null", []);
        return;
      }
      this.alert(val["tag"], val["title"], val["msg"], val["bt"]);
    });
    add("loadServer",(_,__,message){
      Map<String,Object> val = json.decode(message.message);
      if(val["tag"] == null) {
        _callBackFail("","msg is null");
        return;
      }
      if(val["msg"] == null) {
        _callBackFail(val["tag"].toString(),"msg is null");
        return;
      }
      if(val["path"] == null) {
        _callBackFail(val["path"].toString(),"path is null");
        return;
      }
      bool isPost = val["isPost"] == null ? false : val["isPost"];
      this.loadServer(
        parame: val["parame"],
        isPost: isPost,
        path: val["path"]
      ).then((value){
        this._callBack(val["tag"], value);
      });
    });

  }

  Set<JavascriptChannel> toSet(){
    return _channels.toSet();
  }
}