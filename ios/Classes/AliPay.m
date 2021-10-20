//
//  AliPay.m
//  xpay
//
//  Created by 张小亮 on 2021/9/25.
//

#import "AliPay.h"
#import <AlipaySDK/alipaySDK.h>
__weak AliPay* __alipay;
@interface AliPay()
@property(readwrite,copy,nonatomic)FlutterResult callback;
@end


@implementation AliPay
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  /*FlutterMethodChannel* */channel = [FlutterMethodChannel
      methodChannelWithName:@"com.xl/xpay"
            binaryMessenger:[registrar messenger]];
    AliPay* instance = [[AliPay alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

-(id)init{
    if(self = [super init]){
        __alipay = self;
    }
    return self;
}
static FlutterMethodChannel* channel;

+ (AliPay *)alipay_plugin_common_init:(FlutterMethodChannel *)channel_arg{
    channel = channel_arg;
   AliPay* instace =  [[AliPay alloc] init];
    return instace;
}
 
- (void)handleMethodCall_Common:(FlutterMethodCall*)call result:(FlutterResult)result{
    self.callback=result;
    if([@"aliPay" isEqualToString:call.method]){
        [self aliPay:call result:result];
    }else if([@"aliVersion" isEqualToString:call.method]){
        [self aliVersion:call result:result];
    }else if([@"aliIsAliPayInstalled" isEqualToString:call.method]){
        [self aliIsAliPayInstalled:call result:result];
    }
    else{
        result(FlutterMethodNotImplemented);
    }
}
- (void)aliIsAliPayInstalled:(FlutterMethodCall*)call result:(FlutterResult)result{
    BOOL isAliPayInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipays://"]]||[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]];
      result(@(isAliPayInstalled));
}


//9.0之后适配
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
   return [self handleOpenURL:url];
}
//9.0之后适配
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    return  [self handleOpenURL:url];
}



-(BOOL)handleOpenURL:(NSURL *)url{
    if([url.host isEqualToString:@"safepay"]){
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            [self onPayResultReceived:resultDic];
        }];
        //授权跳转支付宝钱包
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            [self onPayResultReceived:resultDic];
        }];
        return YES;
    }
    return NO;
    
}

+(BOOL)handleOpenURL:(NSURL *)url{
    if(!__alipay) return NO;
    return [__alipay handleOpenURL:url];
}

-(void) aliVersion:(FlutterMethodCall*)call result:(FlutterResult)result{
  NSString* version =    [[AlipaySDK defaultService] currentVersion];
    if(version == nil){
        version =@"not fount current version";
    }
    result(version);
}
-(void) aliPay:(FlutterMethodCall*)call result:(FlutterResult)result{
    NSString* urlscheme =  [self fethchUrlScheme];
  
    if(!urlscheme){
        result([FlutterError errorWithCode:@"AliPay urlScheme not fount" message:@"config alipay scheme" details:nil]);
        return;
    }
    [self _aliPay:call result:result urlscheme:urlscheme];
}

-(void) _aliPay:(FlutterMethodCall*)call result:(FlutterResult)result
   urlscheme:(NSString*)urlScheme{
    self.callback = result;
    __weak AliPay* __self = self;

    [[AlipaySDK defaultService] payOrder:call.arguments[@"order"] fromScheme:urlScheme callback:^(NSDictionary *resultDic) {
        [__self onPayResultReceived:resultDic];
    }];
}

-(void)onPayResultReceived:(NSDictionary*)resultDic{
    NSLog(@'-------resultDic--------');
    NSLog(resultDic);
    if(self.callback!=nil){
         NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:resultDic];
         [mutableDictionary setValue:@"iOS" forKey:@"platform"];
         self.callback(mutableDictionary);
         self.callback = nil;
     }
    
}

-(NSString*) fethchUrlScheme{
   NSDictionary *infoDic =   [[NSBundle mainBundle] infoDictionary];
   NSArray* types =  infoDic[@"CFBundleURLTypes"];
    for(NSDictionary* dic in types){
        if([@"alipay" isEqualToString:dic[@"CFBundleURLName"]]){
            return dic[@"CFBundleURLSchemes"][0];
        }
    }
    return nil;
}

@end
