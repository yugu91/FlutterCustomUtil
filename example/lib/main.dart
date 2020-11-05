import 'dart:io';

import 'package:custom_util_plugin/ApplicationStart.dart';
import 'package:custom_util_plugin/CustomDialog.dart';
import 'package:custom_util_plugin/PlatformScaffold.dart';
// import 'package:custom_util_plugin/Util.dart';
// import 'package:custom_util_plugin/WebFileHelper.dart';
// import 'package:custom_util_plugin/generated/i18n.dart';
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
      home: _main(),
      router: {},
      title: "测试",
//      nowLocale: Locale("zh",""),
//      defaultLocal: Locale("en",""),
      theme: CupertinoThemeData(),
    );
  }
}

class _main extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();

}

class _State extends State<_main>{
  Widget getMain(){
    return Container(
        child: PlatformButton(
            child: Text("drgdg"),
            onPressed: () {
              CustomDialog.of(context, msg: "Sdfsf").show();
            }
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return PlatformScaffold(
        appBar: PlatformAppBar(
          title: const Text('Plugin example app'),
        ),
        body: getMain());
  }

}