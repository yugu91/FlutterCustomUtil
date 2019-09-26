import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:fluttercustom/Util.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
//    String platformVersion;
//    // Platform messages may fail, so we use a try/catch PlatformException.
//    try {
//      platformVersion = await CustomUtilPlugin.platformVersion;
//    } on PlatformException {
//      platformVersion = 'Failed to get platform version.';
//    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
//    if (!mounted) return;
//
//    setState(() {
//      _platformVersion = platformVersion;
//    });
  }
  List<File> files = [];
  void chooseImg() async{
    Util.chooseImage().then((file){
      setState(() {
        files.add(file);
      });
    });
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
        onPressed: () => chooseImg(),
      ),
    ];
    list.addAll(choseImgWidget());
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: list,
        ),
      ),
    );
  }
}
