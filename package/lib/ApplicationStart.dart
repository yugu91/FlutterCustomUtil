


import 'package:flutter/foundation.dart';

class ApplicationStart {
  factory ApplicationStart() => _getInstance();
  static ApplicationStart get instance => _getInstance();
  static ApplicationStart _instance;

  ApplicationStart._internal();
  static ApplicationStart _getInstance() {
    _instance ??= ApplicationStart._internal();
    return _instance;
  }

  String _remoteUrl;
  void start({
    @required String remoteUrl,
  }){
    _remoteUrl = remoteUrl;
  }

  String getRemoteUrl() => _remoteUrl;
}