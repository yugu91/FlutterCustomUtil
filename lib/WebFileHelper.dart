
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:custom_util_plugin/ApplicationStart.dart';
import 'package:custom_util_plugin/CustomNetwork.dart';
import 'package:path_provider/path_provider.dart';

class WebFileHelper {
  factory WebFileHelper() => _getInstance();
  static WebFileHelper get instance => _getInstance();
  static WebFileHelper _instance;
  WebFileHelper._internal();
  static WebFileHelper _getInstance() {
    _instance ??= WebFileHelper._internal();
    return _instance;
  }

  Map<String,WebFileModel> _webFileModel = {};

  Future<bool> getWebFile(){
    return CustomNetwork.instance.get("/html5/${ApplicationStart.instance.webFileDict}/webfile.json", null).then((val){
      var map = val as Map<String,dynamic>;
      var initLoad = <Future<WebFileModel>>[];
      map.forEach((name,val){
        var model = WebFileModel.fromMap(val);
        _webFileModel[name] = model;
        if(model.isInit)
          initLoad.add(getFile(model.name));
      });
      if(initLoad.length > 0)
        return Future.wait(initLoad);
      else
        return Future.value(_webFileModel);
    }).then((_){
      return Future.value(true);
    });
  }

  Future<WebFileModel> getFile(String name) async {
    var model = _webFileModel[name];
    var list = <Future<WebFileModel>>[
      _checkUpdate(model)
    ];
    if(model.files != null && model.files.length > 0){
      model.files.forEach((m) => list.add(_checkUpdate(m)));
    }
    return Future.wait(list).then((_){
      return Future.value(model);
    });
  }

  Future<WebFileModel> _checkUpdate(WebFileModel model) async{
    var appDocDir = await getTemporaryDirectory();
    var tmpFile = File("${appDocDir.path}/${model.name}");
    if(!tmpFile.existsSync()){
      return _updateFile(model,tmpFile);
    }else{
      String cont = tmpFile.readAsStringSync();
      var bytes = Utf8Encoder().convert(cont);
      var digest = md5.convert(bytes);
      model.path = tmpFile;
      if(digest.toString() != model.md5){
        return _updateFile(model, tmpFile);
      }else{
        return Future.value(model);
      }
    }
  }

  Future<WebFileModel> _updateFile(WebFileModel model,File file) async{
    var url = "/html5/${ApplicationStart.instance.webFileDict}/${model.name}";
    var savePath = file.path;
    return CustomNetwork.instance.download(url, savePath).then((path){
      var newFile = File(path);
      var contBase64 = newFile.readAsStringSync();
      var cont = contBase64;
      if(model.isb3) {
        try {
          List<int> bytes = base64Decode(contBase64.replaceAll(
              ApplicationStart.instance.webFileEncodeKey, ""));
          cont = Utf8Decoder().convert(bytes);
        } catch (err) {

        }
      }
      newFile.writeAsStringSync(cont);
//      var digest = md5.convert(bytes);
//      model.md5 = digest.toString();
      return Future.value(model);
    });
  }
}

class WebFileModel {
  final String name;
  String md5;
  final List<WebFileModel> files;
//  final String filePath;
  final bool isb3;
  final bool isInit;
  File path;
  WebFileModel({
    this.name,
    this.md5,
    this.files,
//    this.filePath,
    this.isb3,
    this.isInit,
  });

  static WebFileModel fromMap(Map<String,dynamic> map){
    List<WebFileModel> files = [];
    if(map["files"] != null)
      (map["files"] as List<dynamic>).forEach((val) => files.add(WebFileModel.fromMap(val as Map<String,dynamic>)));
    var isInit = false;
    if(map["name"] == "runm.html") isInit = true;
    return WebFileModel(
      name: map["name"],
      md5: map["md5"],
      files: files,
//      filePath: map["filePath"],
      isb3: map["isb3"] == null ? false : map["isb3"] as bool,
      isInit:isInit
    );
  }
}