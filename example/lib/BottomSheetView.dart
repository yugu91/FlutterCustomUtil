import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:custom_util_plugin/custom_util_plugin.dart';

import 'package:fluttercustom/CustomListView.dart';
import 'package:fluttercustom/PlatformScaffold.dart';
import 'package:fluttercustom/CustomBottomSheetDialog.dart';

void main() => runApp(app());

class app extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return PlatformApp(
      title: "test",
      theme: CupertinoTheme.of(context),
        router: <String, WidgetBuilder>{"dd": (_) => ListView()},
        home: Builder( builder: (context) =>
          PlatformButton(
                  child: Text("fdgdgdgdg"),
                  onPressed: () {
                    CustomBottomSheetDialog
                        .of(context,
                        content: Text("测试测试测试测试测试"),
                        title: Text("测试"),
                        actions: [
                          Text("按钮1"),
                          Text("按钮2"),
                          Text("按钮3"),
                        ]).show();
                  }),
        )
    );
  }

}