
import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

import 'ApplicationStart.dart';
import 'HandleError.dart';
import 'generated/i18n.dart';

typedef String CustomNetworkCheckResult(String url,dynamic parame,dynamic result);

class CustomNetwork {
  factory CustomNetwork() => _getInstance();
  static CustomNetwork get instance => _getInstance();
  static CustomNetwork _instance;
  Dio _dio;
  // ignore: unused_field
  bool _cookiesInitFinish = false;
  //api cookies 域，通常是 api接口即可
  String domain = "";
  CustomNetwork._internal();
  CustomNetworkCheckResult checkResult;
  Future<bool> checkInit;
  static CustomNetwork _getInstance(){
    _instance ??= CustomNetwork._internal();
    _instance._dio = Dio(BaseOptions(
      //请求基地址,可以包含子路径
      baseUrl: ApplicationStart.instance.getRemoteUrl(),
      //连接服务器超时时间，单位是毫秒.
      connectTimeout: 20000,
      //响应流上前后两次接受到数据的间隔，单位为毫秒。
      receiveTimeout: 50000,
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
//    _instance._dio.interceptors.add(InterceptorsWrapper(
////      onRequest: (RequestOptions options){
////
////      },
//      onResponse: (Response response){
//
//      },
//    ));
    _instance.checkInit = _instance._checkInit();
    return _instance;
  }

  Future<bool> _checkInit() async{
    return _CookiesApi.cookieJar.then((cookieJar){
      _instance._dio.interceptors.add(CookieManager(cookieJar));
      return Future.value(true);
    }).catchError((err) => print(err)).whenComplete(() => _cookiesInitFinish = true);
  }

  Future<Object> get(String url,Map<String,Object> parame,{
    Map<String,Object> headers,
  }) {
//    if(!url.contains("http"))
//      url = ApplicationStart.instance.getRemoteUrl() + url;
    return checkInit.then((v) {
      return _getRequest(url, parame,headers: headers);
    }).then<Object>((body) {
      if (checkResult != null) {
        String check = checkResult(url, parame, body);
        if (check != null) {
          var l = S.of(ApplicationStart.instance.getContext());
          throw CustomError(check, title: l != null ? l.sorry : "抱歉",
              canReload: true,
              result: body);
        }
      }
      if (body is String) {
        return json.decode(body);
      } else {
        return body;
      }
    });
  }

  Future<Object> _getRequest(String url,Map<String,Object> parame,{
    Map<String,Object> headers,
  }) async {
    Response response;
    var option = Options();
    if(headers != null)
      headers.forEach((k,v){
        option.headers[k] = v;
      });

    try {
      response = await _dio.get<String>(url,queryParameters: parame,options: option);
    } on DioError catch (e,stackTrace) {
      throw CustomError(e.message,canReload: true,stackTrace: stackTrace);
//      throw e;
    }
    return response.data;
  }

  /// post 数据 和 上传文件
  /// [url] 接口地址
  /// [parame] 需要传递的参数
  Future<Object> post(String url,{
    Map<String,Object> parame,
    bool isFormUrlencoded = false,
    Map<String,Object> headers,
  }){
    if(parame == null)
      parame = Map();

    return checkInit.then((v) {
      return _postRequest(url, parame, isFormUrlencoded: isFormUrlencoded, headers: headers);
    }).then<Object>((body){
      if(checkResult != null) {
        String check = checkResult(url, parame, body);
        var localStr = S.of(ApplicationStart.instance.getContext());
        if (check != null) {
          throw CustomError(check, title: localStr == null ? "抱歉" : localStr.sorry, canReload: true);
        }
      }
      if(body is String) {
        return json.decode(body);
      }else{
        return body;
      }
    });
  }

  Future<Object> _postRequest(String url,Object data,{
    // ignore: unused_element
    bool isFile = false,
    bool isFormUrlencoded = false,
    Map<String,Object> headers,
  }) async{
    Response response;
    var option = Options();
    if(isFormUrlencoded)
      option.contentType = ContentType.parse("application/x-www-form-urlencoded").value;
    try {
      response = await _dio.post(url,data: data,options: option);
    } on DioError catch (e,stackTrace) {
      throw CustomError(e.message,canReload: true,stackTrace: stackTrace);
//      throw e;
    }
    return response.data;
  }

  Future<Object> upload(String url,Map<String,Object>parame,File file,String key) async{
    var p = parame == null ? <String,Object>{} : parame;
    p[key] = await MultipartFile.fromFile(
      file.path,
      filename: key,
    );
    return _postRequest(url, FormData.fromMap(p)).then((body){
      if(checkResult != null) {
        String check = checkResult(url, p, body);
        if (check != null) {
          var k = S.of(ApplicationStart.instance.getContext());
          throw CustomError(check, title: k != null ? k.sorry : "抱歉", canReload: true);
        }
      }
      return json.decode(body);
    });
  }

  Future<String> download(String url,String savePath) async {
    try {
      await _dio.download(url, savePath);
    } on DioError catch(e,stackTrace){
      throw CustomError(e.message,canReload: true,stackTrace:stackTrace);
    }

    return Future.value(savePath);
  }
}

class _CookiesApi {
  static PersistCookieJar _cookieJar;
  static String domain;
  static final webViewCookieManager = WebviewCookieManager();
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<Directory> get _localCoookieDirectory async {
    final path = await _localPath;
    final Directory dir = new Directory('$path/cookies');
    await dir.create();
    return dir;
  }

  static Future<PersistCookieJar> get cookieJar async {
    // print(_cookieJar);
    if (_cookieJar == null) {
      final Directory dir = await _localCoookieDirectory;
      final cookiePath = dir.path;
      _cookieJar = new PersistCookieJar(dir: '$cookiePath');
      if(domain != null && domain != ""){
        var apiCookies = _cookieJar.loadForRequest(Uri.parse(domain));
        // var _cookies = <Cookie>[];
        // apiCookies.forEach((cookie) {
        //   _cookies.add(cookie);
        // });
        webViewCookieManager.setCookies(apiCookies);
      }
      // var tmp = _cookieJar.loadForRequest(Uri.parse("https://www.hot008.app"));
      // for(var k in tmp){
      //   print("sdfsdfsdfsf|" + k.name + "|" + k.value);
      // }
    }
    return _cookieJar;
  }
}