# xpay

A Flutter Pay Plugin

## Platfrom

The future wall support

1. Alipay
2. WeChatPay
3. GooglePay
4. ApplePay

ios 9 版本需要在 info.plist 添加白名单

  <!-- 支付宝  URL Scheme 白名单-->

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
<string>alipay</string>
<string>alipayshare</string>
<string>alipays</string>
<array>
```

## Getting Started

```dart
main(){
    Xpay.Alipay(String order)

}
```
