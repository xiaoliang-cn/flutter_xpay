package com.xl.xpay.xpay

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

/** XpayPlugin */
class XpayPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    private val xPayPluginDelegate= XPayPluginDelegate()
    private lateinit var channel: MethodChannel

    companion object {
        @JvmStatic
        fun registerWith(registrar: PluginRegistry.Registrar): Unit {
            val channel = MethodChannel(registrar.messenger(), "com.xl/xpay")
            channel.setMethodCallHandler(XpayPlugin().apply {
                xPayPluginDelegate.activity = registrar.activity()
            })
        }
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.xl/xpay")
        channel.setMethodCallHandler(this)

    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) =
        xPayPluginDelegate.handlerMethodCall(call, result)

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        xPayPluginDelegate.activity = binding.activity;
    }

    override fun onDetachedFromActivityForConfigChanges() {

    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {

    }

    override fun onDetachedFromActivity() {

    }


}
