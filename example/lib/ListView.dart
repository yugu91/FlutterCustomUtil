import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:custom_util_plugin/custom_util_plugin.dart';

import 'package:fluttercustom/CustomListView.dart';

void main() => runApp(ListViewTest());

class ListViewTest extends StatefulWidget {
  @override
  _ListViewTestState createState() => _ListViewTestState();
}

class _ListViewTestState extends State<ListViewTest> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await CustomUtilPlugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  var data = ["测试1","测试1","测试1","测试1","测试1","测试1","测试1","测试1","测试1","测试1","测试1"];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: CustomListView(
          itemBuilder: (_,index){
            return SizedBox(
              height: 100,
              child: Text(data[index]),
            );
          },
          data: data,
          pageMax: 2,
          lisent: (index,flag) {
            print(index);
            return Future.delayed(Duration(
                seconds: 5
            ));
          },
        ),
      ),
    );
  }
}
