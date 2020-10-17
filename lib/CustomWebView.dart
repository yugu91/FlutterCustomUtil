
import 'package:custom_util_plugin/ApplicationStart.dart';
import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'CustomJavascript.dart';

// ignore: must_be_immutable
class CustomWebView extends StatefulWidget{
  final CustomJavascriptDelegate channel;
  final String url;
  final Function(String url) onFinish;
  final String userAgent;
  WebViewController _controller;
  CustomWebView({
    this.channel,
    this.url,
    this.onFinish,
    this.userAgent,
  });

  void runJS(String js){
    _controller.evaluateJavascript(js);
  }
  void reload(){
    _controller.reload();
  }
  void loadUrl(String rul){
    _controller.loadUrl(url);
  }

  @override
  _State createState() => _State();
}

class _State extends State<CustomWebView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WebView(
      initialUrl: widget.url,
      javascriptChannels: widget.channel.toSet(),
      onWebViewCreated: (controller){
        widget._controller = controller;
        widget.channel.controller = controller;
      },
      onPageFinished: widget.onFinish,
      debuggingEnabled: ApplicationStart.instance.isDebug,
      userAgent: widget.userAgent,
    );
  }
}