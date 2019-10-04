
import 'package:flutter/foundation.dart';
import 'package:sentry/sentry.dart';
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

  /// 初始化Sentry
  /// [sentryDSN] 所获得得DSN
  void InitSentry(String sentryDSN){
    _instance._sentry = new SentryClient(dsn: sentryDSN);
    FlutterError.onError = (details, {bool forceReport = false}) {
      try {
        _instance._sentry.captureException(
          exception: details.exception,
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

  /// 主动上报错误
  /// [error] 错误信息
  /// [stackTrace] 输出信息
  /// try{ }catch(error,stackTrace){}
  Future<SentryResponse> report(Error error, {
    dynamic stackTrace
  }) async{
    return await _sentry.captureException(
      exception: error,
      stackTrace:stackTrace
    );
  }
}