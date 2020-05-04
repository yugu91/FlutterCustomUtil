import Flutter
import UIKit
import MBProgressHUD
public class SwiftCustomUtilPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "custom_util_plugin", binaryMessenger: registrar.messenger())
        let window:UIWindow = UIApplication.shared.delegate!.window!!;
        let instance = SwiftCustomUtilPlugin(viewController: window.rootViewController!);
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    var _viewController:UIViewController!;
    var result:FlutterResult!;
    init(viewController:UIViewController) {
        super.init()
        _viewController = viewController;
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.result = result;
        if(call.method == "pickImage"){
            picImage(call, result: result);
        }else if(call.method == "openUrl"){
            openUrl(call, result: result);
        }else if(call.method == "getPackageInfo"){
            getPackageInfo(result);
        }else if(call.method == "showLoading"){
            MBProgressHUD.showAdded(to: _viewController.view, animated: true);
        }else if(call.method == "hideLoading"){
            MBProgressHUD.hide(for: _viewController.view, animated: true);
        }else{
            result(FlutterError(code: "100", message: "没有找到合适的方法\(call.method)", details: nil));
        }
    }
    
    var chooseImg:chooseImage!;
    private func picImage(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        var type:UIImagePickerController.SourceType?;
        if let arg = call.arguments as? [String:Any] {
            if arg["source"] as! String == "img" {
                type = .photoLibrary;
            }else if(arg["source"] as! String == "camera"){
                type = .camera
            }
            if let type = type {
                chooseImg = chooseImage(viewController: _viewController, result: result);
                chooseImg.checkImageAccess(type: type);
            }else{
                result(FlutterError(code: "1000", message: "紧支持img,camera属性", details: nil));
            }
        }else{
            result(FlutterError(code: "1001", message: "请传入参数 source", details: nil));
        }
    }
    
    private func openUrl(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        if let arg = call.arguments! as? [String:Any],
           let urlStr = arg["url"] as? String,
           let url = URL(string: urlStr)
        {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url);
                result(true);
            }else{
                result(FlutterError(code: "2000", message: "不合法的url", details: nil));
            }
        }else{
            result(FlutterError(code: "2001", message: "url 参数错误", details: nil));
        }
    }
    
    private func getPackageInfo(_ result:@escaping FlutterResult){
        if let dict = Bundle.main.infoDictionary,let package = Bundle.main.bundleIdentifier {
            var versionCode = 0;
            if let code = dict["CFBundleVersion"] as? NSString {
                versionCode = code.integerValue;
            }
            let version = dict["CFBundleShortVersionString"] as! String;
            result([
                "versionCode":versionCode,
                "version":version,
                "package":package
                ]);
        }else{
            result(FlutterError(code: "3000", message: "版本获取错误", details: nil));
        }
    }
}
