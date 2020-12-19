
import 'package:custom_util_plugin/ApplicationStart.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
class ReportError {
  factory ReportError() => _getInstance();
  static ReportError get instance => _getInstance();
  static ReportError _instance;
  
  ReportError._internal();

  SentryClient _sentry;

  static ReportError _getInstance() {
    _instance ??= ReportError._internal();
    return _instance;
  }

  void setUpPlatform(Map<String,dynamic> platform,String userName){
    // if(_instance._sentry != null)
    //   _instance._sentry..userContext = User(
    //     extras: platform,
    //     username: userName == "" ? null : userName,
    //     id: "0",
    //     ipAddress: ""
    //   );
  }

  /// 初始化Sentry
  /// [sentryDSN] 所获得得DSN
  void InitSentry({
    @required String sentryDSN,
    @required AppRunner appRunner
  }) async{
    await SentryFlutter.init(
      (options) => options.dsn = sentryDSN,
      appRunner: () => appRunner(),
    );
    // InitSentry(sentryDSN);
    // // _instance._sentry = new SentryClient(dsn: sentryDSN);
    FlutterError.onError = (details, {bool forceReport = false}) {
      try {
        _instance._sentry.captureException(
          details.exception,
          stackTrace: details.stack,
        );
      } catch (e) {
        print('Sending report to sentry.io failed: $e');
      } finally {
        // Also use Flutter's pretty error logging to the device's console.
        FlutterError.dumpErrorToConsole(details, forceReport: forceReport);
      }
    };
  }

  /// 主动上报错误,DEBUG模式不会上报
  /// [error] 错误信息
  /// [stackTrace] 输出信息
  /// [alwaysReport] DEBUG模式仍然上报
  /// try{ }catch(error,stackTrace){}
  Future<SentryId> report(Error error, {
    dynamic stackTrace,
    bool alwaysReport = false
  }) async{
    if(!alwaysReport && ApplicationStart.instance.isDebug)
      return Future.value(SentryId.empty());
    else
      return await _sentry.captureException(
        error,
        stackTrace:stackTrace
      );
  }
}