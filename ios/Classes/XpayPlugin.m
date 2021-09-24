#import "XpayPlugin.h"
#import <AlipaySDK/alipaySDK.h>

__weak XpayPlugin* __xpayPlugin;

#if __has_include(<xpay/xpay-Swift.h>)
#import <xpay/xpay-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "xpay-Swift.h"
#endif

@implementation XpayPlugin
-(id)init{
    if(self = [super init]){
        
        __xpayPlugin = self;
    }
    return self;
}
-(void)dealloc{
    
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {

  [SwiftXpayPlugin registerWithRegistrar:registrar];
 
}

@end
