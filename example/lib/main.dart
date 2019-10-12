import 'dart:io';

import 'package:custom_util_plugin/ApplicationStart.dart';
import 'package:custom_util_plugin/PlatformScaffold.dart';
import 'package:custom_util_plugin/Util.dart';
import 'package:custom_util_plugin/WebFileHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:custom_util_plugin/ReportError.dart';

// void main() => runApp(MyApp());
void main() {
  runZoned(() {
    runApp(MyApp());


  }, onError: (Object obj, StackTrace stack) {
    ReportError.instance.report(obj, stackTrace: stack);
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  List<File> files = [];
  void chooseImg() async {
//    Util.chooseImage().then((file){
//      setState(() {
//        files.add(file);
//      });
//    });
  }

  List<Widget> choseImgWidget() {
    List<Widget> list = [];
    files.forEach((file) {
      list.add(Image.file(file));
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    ApplicationStart.instance.start(context, remoteUrl: "https://www.hot008.app/",webFileDict: "appcachefile",webFileEncodeKey: "bXkgcGxhbmkgdGV4dA");

    // Future.delayed(Duration(seconds: 5),(){
    //   baseLayout.hideLoading();
    // });
    return PlatformApp(
      home: PlatformScaffold(
        appBar: PlatformAppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          child: PlatformButton(
            child: Text("drgdg"),
            onPressed: ()=> WebFileHelper.instance.getWebFile().then((val)=> print(val)).catchError((err)=>print(err)),
          )
        ) ,
      ),
      router: {},
      title: "测试",
      theme: CupertinoThemeData(),
    );
  }
}
