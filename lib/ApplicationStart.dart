import 'dart:io';

import 'package:custom_util_plugin/ReportError.dart';
import 'package:flutter/cupertino.dart';

import 'CustomDialog.dart';
import 'CustomNetwork.dart';
import 'Util.dart';
//import 'package:fluttercustom/CustomDialog.dart';
//import 'package:fluttercustom/CustomNetwork.dart';
//import 'package:fluttercustom/Util.dart';

class ApplicationStart {
  factory ApplicationStart() => _getInstance();
  static ApplicationStart get instance => _getInstance();
  static ApplicationStart _instance;

  
  Map<String,dynamic> packageInfo;
  ApplicationStart._internal();
  static ApplicationStart _getInstance() {
    _instance ??= ApplicationStart._internal();
    return _instance;
  }
  final bool isDebug = !(const bool.fromEnvironment("dart.vm.product"));
  String _remoteUrl;
  String webFileDict = "";
  String webFileEncodeKey = "";
  BuildContext _context;
  void start(
    BuildContext context, {
    @required String remoteUrl,
    String checkUpdateUrl,
    String sentryDSN,
    String webFileDict,
    String webFileEncodeKey,
  }) {
    _remoteUrl = remoteUrl;
    this._context = context;
    this.webFileDict = webFileDict;
    this.webFileEncodeKey = webFileEncodeKey;
    if(sentryDSN != null)
      ReportError.instance.InitSentry(sentryDSN);

    Util.getPackageInfo().then((val){
      packageInfo = val;
      if (checkUpdateUrl != null) _checkUpdate(context, checkUpdateUrl);
    });
//    PackageInfo.fromPlatform().then((_packInfo) {
//      packageInfo = _packInfo;
//      if (checkUpdateUrl != null) _checkUpdate(context, checkUpdateUrl);
//    });
  }

  void _checkUpdate(BuildContext context, String url) {
    CustomNetwork.instance.get(url, null).then((res) {
      var platform =
          Platform.isIOS ? "ios" : (Platform.isAndroid ? "android" : "");
      if (platform == "") {
        print("不支持的app检查更新类型");
        return;
      }
      var map = (res as Map<String, Map<String, Object>>)[platform];
      if (map == null) {
        print("没有找到平台的更新项");
        return;
      }

      if (packageInfo["versionCode"] as int < (map["code"] as int)) {
        CustomDialog.of(context,
                msg: map["des"].toString(),
                title: "更新提醒",
                bts: ["前往"],
                canCancel: !(map["must"] as bool))
        .show()
        .then((val) {
          if (val == 0) {
            Util.openUrlOnBrowser(map["url"] as String);
          }
        });
      }
    });
  }

  String getRemoteUrl() => _remoteUrl;

  BuildContext getContext() => _context;
}

//checkUpdateJsonTemplate
//{
//  "android":{
//    version:"1.0",
//    code:1,
//    must:true,
//    url:"xxxxxx",
//    des:"xiufu "
//  },
//  "ios":{
//    version:"1.0",
//    code:1,
//    must:true,
//    url:"xxxxxx",
//    des:"xiufu "
//  }
//}
