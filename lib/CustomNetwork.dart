
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'ApplicationStart.dart';
import 'HandleError.dart';

typedef String CustomNetworkCheckResult(String url,dynamic parame,dynamic result);

class CustomNetwork {
  factory CustomNetwork() => _getInstance();
  static CustomNetwork get instance => _getInstance();
  static CustomNetwork _instance;
  Dio _dio;
  CustomNetwork._internal();

  CustomNetworkCheckResult checkResult;

  static CustomNetwork _getInstance(){
    _instance ??= CustomNetwork._internal();
    _instance._dio = Dio(BaseOptions(
      //请求基地址,可以包含子路径
      baseUrl: ApplicationStart.instance.getRemoteUrl(),
      //连接服务器超时时间，单位是毫秒.
      connectTimeout: 60000,
      //响应流上前后两次接受到数据的间隔，单位为毫秒。
      receiveTimeout: 30000,
//      sendTimeout: 10000,
      //Http请求头.
//    headers: {
//      //do something
//      "version": "1.0.0"
//    },
      //请求的Content-Type，默认值是[ContentType.json]. 也可以用ContentType.parse("application/x-www-form-urlencoded")
//    contentType: ContentType.json,
      //表示期望以那种格式(方式)接受响应数据。接受4种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
      responseType: ResponseType.json,
    ));
    _instance._dio.interceptors.add(InterceptorsWrapper(
//      onRequest: (RequestOptions options){
//
//      },
      onResponse: (Response response){

      },
    ));
    return _instance;
  }

  Future<Object> get(String url,Map<String,Object> parame){
//    if(!url.contains("http"))
//      url = ApplicationStart.instance.getRemoteUrl() + url;
    return _getRequest(url,parame).then<Object>((body){
      if(checkResult != null) {
        String check = checkResult(url, parame, body);
        if (check != null) {
          throw CustomError(check, title: "抱歉", canReload: true,result: body);
        }
      }
      return json.decode(body);
    });
  }

  Future<String> _getRequest(String url,Map<String,Object> parame) async {
    Response response;
    try {
      response = await _dio.get<String>(url,queryParameters: parame);
    } on DioError catch (e) {
      throw CustomError(e.message,canReload: true);
//      throw e;
    }
    return response.data;
  }

  /// post 数据 和 上传文件
  /// [url] 接口地址
  /// [parame] 需要传递的参数
  /// [files] 上传的文件 多张图片值可为数组
  Future<Object> post(String url,{
    Map<String,Object> parame,
    Map<String,Object> files
  }){
    if(parame == null)
      parame = Map();

    Future<String> postAct;
    if(files != null && files.length > 0)
      files.map((key,value){
        if(value is List){
          List<UploadFileInfo> arr = [];
          List<String> v = value as List<String>;
          v.forEach((c){
            arr.add(UploadFileInfo(File(c),key));
          });
          parame[key] = arr;
        }else {
          parame[key] = UploadFileInfo(File(value), key);
        }
        return null;
      });

    return _postRequest(url, FormData.from(parame)).then<Object>((body){
      if(checkResult != null) {
        String check = checkResult(url, parame, body);
        if (check != null) {
          throw CustomError(check, title: "抱歉", canReload: true);
        }
      }
      return json.decode(body);
    });
  }

  Future<String> _postRequest(String url,FormData data,{
    bool isFile = false
  }) async{
    Response response;
    try {
      response = await _dio.post(url,data: data);
    } on DioError catch (e) {
      throw CustomError(e.message,canReload: true);
//      throw e;
    }
    return response.data;
  }

  Future<String> download(String url,String savePath) async {
    try {
      await _dio.download(url, savePath);
    } on DioError catch(e){
      throw CustomError(e.message,canReload: true);
    }

    return Future.value(savePath);
  }
}