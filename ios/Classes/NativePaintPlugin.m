#import "NativePaintPlugin.h"
#import <native_paint/native_paint-Swift.h>

@implementation NativePaintPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNativePaintPlugin registerWithRegistrar:registrar];
}
@end
