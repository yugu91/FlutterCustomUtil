#import "CustomUtilPlugin.h"
#import <custom_util_plugin/custom_util_plugin-Swift.h>

@implementation CustomUtilPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCustomUtilPlugin registerWithRegistrar:registrar];
}
@end
