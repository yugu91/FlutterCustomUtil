
import 'dart:convert';

import 'package:dio/dio.dart';

import 'ApplicationStart.dart';
import 'HandleError.dart';

class CustomNetwork {
  factory CustomNetwork() => _getInstance();
  static CustomNetwork get instance => _getInstance();
  static CustomNetwork _instance;
  Dio _dio;
  CustomNetwork._internal();
  static CustomNetwork _getInstance(){
    _instance ??= CustomNetwork._internal();
    _instance._dio = Dio(BaseOptions(
      //请求基地址,可以包含子路径
      baseUrl: ApplicationStart.instance.getRemoteUrl(),
      //连接服务器超时时间，单位是毫秒.
      connectTimeout: 10000,
      //响应流上前后两次接受到数据的间隔，单位为毫秒。
      receiveTimeout: 5000,
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
//    var httpClient = new HttpClient();
//    var request = await httpClient.getUrl(Uri.parse(url));
//    var response = await request.close();
//    final String body = await response.transform(utf8.decoder).join();
//    return body;
  }
}