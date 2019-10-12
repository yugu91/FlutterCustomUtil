
import 'dart:convert';

import 'package:custom_util_plugin/CustomDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

typedef void CustomJavascriptHandler(BuildContext context,WebViewController controller,JavascriptMessage message);

/// WebView 交互程序接口
/// 回调函数：成功 wkcallBack("tag","value")、失败 wkCallBackFail("tag","message");
/// 需要在js全局接入两个函数
///
/// 新增方法请使用 add 方法
/// JS 调用方法：名字(Add时候的名字).postMessage(message[提交的参数，需要是字符串]);
abstract class CustomJavascriptDelegate{

  /// WebView 控制器
  WebViewController controller;

  List<JavascriptChannel> _channels = [];
  final String _wkCallBack = "wkcallBack(\"{tag}\",{val});";
  final String _wkCallBackFail = "wkCallBackFail(\"{tag}\",\"{msg}\");";

  /// 刷新
  void reload(){
    controller.reload();
  }

  /// 后退
  void returnBack(){
    Navigator.of(context).pop();
  }

  /// 运行JS
  void runScript(String js){
    controller.evaluateJavascript(js);
  }

  /// 回调数据
  /// [tag] 标签，用标签区分回调
  /// [val] 回调的对象值
  void callBack(String tag,dynamic val){
    controller.evaluateJavascript(
        _wkCallBack.replaceAll("{tag}", tag).replaceAll("{msg}", val is String ? "\"${val.toString()}\"" : json.encode(val))
    );
  }

  /// 回调失败
  /// [tag] 标签，用标签区分回调
  /// [err] 错误信息
  void callBackFail(String tag,String err){
    controller.evaluateJavascript(
        _wkCallBackFail.replaceAll("{tag}", tag).replaceAll("{msg}", err)
    );
  }

  /// 弹框
  void alert(String tag,String title, String msg, List<String> bt) {
    // TODO: implement alert
    CustomDialog.of(context, msg: msg,title: title,bts: bt).show().then((val){
      callBack(tag, val.toString());
    });
  }

  /// loadServer 需由客户端自行接入
  /// 此方法不需要通过add处理
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

  /// 添加新的事件
  /// [name] 事件名称
  /// [func] 执行的方法
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
        callBackFail("","msg is null");
        return;
      }
      if(val["msg"] == null) {
        callBackFail(val["tag"].toString(),"msg is null");
        return;
      }
      if(val["path"] == null) {
        callBackFail(val["path"].toString(),"path is null");
        return;
      }
      bool isPost = val["isPost"] == null ? false : val["isPost"];
      this.loadServer(
        parame: val["parame"],
        isPost: isPost,
        path: val["path"]
      );
    });

  }

  Set<JavascriptChannel> toSet(){
    return _channels.toSet();
  }
}