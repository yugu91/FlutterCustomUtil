package customutilplugin.custom_util_plugin

import android.app.Activity
import android.app.Application
import android.content.Intent
import android.content.pm.PackageInfo
import android.net.Uri
import android.os.Build
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.util.*

class CustomUtilPlugin: MethodCallHandler {
    var activity:Activity;
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
          val channel = MethodChannel(registrar.messenger(), "custom_util_plugin")
          channel.setMethodCallHandler(CustomUtilPlugin(registrar.activity()));
        }
    }
    constructor(activity: Activity){
        this.activity = activity;
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "getPlatformVersion") {
          result.success("Android ${android.os.Build.VERSION.RELEASE}")
        }else if(call.method == "openUrl") {
            val url = call.argument<String>("url")
            if (url == null || url == "")
                result.error("1000", "URL 错误", null)
            else
                openUrl(url, result)
        }else if(call.method == "getPackageInfo"){
            getPackInfo(result)
        } else {
          result.notImplemented()
        }
    }

    fun getPackInfo(result: Result){
        val packinfo = activity.applicationContext.packageManager.getPackageInfo(activity.packageName,0)
        val versionCode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            packinfo.longVersionCode
        } else {
            packinfo.versionCode
        }
        result.success(mapOf(
                "versionCode" to versionCode,
                "versionName" to packinfo.versionName
        ))
    }

    fun openUrl(url:String,result: Result){
        val intent = Intent(Intent.ACTION_VIEW)
        intent.addCategory(Intent.CATEGORY_BROWSABLE)
        intent.setData(Uri.parse(url))
        activity.startActivity(intent)
        result.success(true)
    }
}
