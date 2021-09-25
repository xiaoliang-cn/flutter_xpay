import Flutter
import UIKit
public class SwiftXpayPlugin: NSObject, FlutterPlugin {
  
    public var aliPayPlugin : AliPay?
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.xl/xpay", binaryMessenger: registrar.messenger())
    let instance = SwiftXpayPlugin()    
    registrar.addMethodCallDelegate(instance, channel: channel)
    instance.aliPayPlugin = AliPay.alipay_plugin_common_init(channel);
  }
    override init() {
        super.init();
        aliPayPlugin=nil;
    }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let alipay : AliPay = aliPayPlugin!
    alipay.handleMethodCall_Common(call, result: result);
  }
}
