import 'dart:io';

import 'package:custom_util_plugin/PlatformScaffold.dart';
import 'package:custom_util_plugin/Util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:custom_util_plugin/ReportError.dart';

// void main() => runApp(MyApp());
runZoned(() {
    runApp(MyApp());
}, onError: (Object obj, StackTrace stack) {
    // ReportError.
});

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PlatformScaffold baseLayout;
  @override
  void initState() {
    super.initState();
  }

  List<File> files = [];
  void chooseImg() async{
//    Util.chooseImage().then((file){
//      setState(() {
//        files.add(file);
//      });
//    });
  }

  List<Widget> choseImgWidget(){
    List<Widget> list = [];
    files.forEach((file){
      list.add(Image.file(file));
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    var list = <Widget>[
      FlatButton(
        child: Text("fhfh"),
        onPressed: () => Util.getPackageInfo().then((val){
          print(val["versionCode"] as int);
        })//Util.openUrlOnBrowser("https://baidu.com")//chooseImg(),
      ),
    ];
    list.addAll(choseImgWidget());

    baseLayout = PlatformScaffold(
      initLoad: true,
      appBar: PlatformAppBar(
        title: const Text('Plugin example app'),
      ),
      body: Column(
        children: list,
      ),
    );
    Future.delayed(Duration(seconds: 5),(){
      baseLayout.hideLoading();
    });
    return PlatformApp(
      home: baseLayout,
      router: {

      },
      title:"测试",
      theme: CupertinoThemeData(),
    );
  }
}
