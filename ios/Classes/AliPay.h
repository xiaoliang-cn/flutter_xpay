//
//  AliPay.m
//  xpay
//
//  Created by 张小亮 on 2021/9/25.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@interface AliPay : NSObject<FlutterPlugin>
+ (AliPay *)alipay_plugin_common_init:(FlutterMethodChannel *)channel_arg;
- (void)handleMethodCall_Common:(FlutterMethodCall*)call result:(FlutterResult)result;
- (BOOL)handleOpenURL:(NSURL*)url;
@end
