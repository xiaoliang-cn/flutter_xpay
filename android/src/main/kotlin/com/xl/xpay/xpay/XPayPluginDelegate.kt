package com.xl.xpay.xpay

import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import com.alipay.sdk.app.EnvUtils
import com.alipay.sdk.app.PayTask
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import kotlin.coroutines.CoroutineContext

//支付插件
class XPayPluginDelegate : CoroutineScope {
     var activity: Activity? = null
    fun handlerMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "aliIsAliPayInstalled" -> isAliPayInstalled(result)
            "alipay" -> aliPay(call, result)
            "aliVersion" -> getAliPayVersion(result)
            else -> {
                result.notImplemented()
            }
        }

    }

    fun cancel() {
        job.cancel()
    }

    var job = Job()

    override val coroutineContext: CoroutineContext = Dispatchers.Main + job

    private fun aliPay(call: MethodCall, result: MethodChannel.Result) {
        launch {
            if (call.argument<Int>("payEnv") == 1) {
                EnvUtils.setEnv(EnvUtils.EnvEnum.SANDBOX)
            } else {
                EnvUtils.setEnv(EnvUtils.EnvEnum.ONLINE)
            }
            val payResult = doPayTask(call.argument("order") ?: "")
            withContext(Dispatchers.Main) {
                result.success(payResult)
            }
        }

    }

    private fun doPayTask(order: String): String {
        val alipay = PayTask(activity)
        return alipay.pay(order, true)
    }

    private fun isAliPayInstalled(result: MethodChannel.Result) {
        val manager = activity?.packageManager
        if (manager != null) {
            val action = Intent(Intent.ACTION_VIEW)
            action.data = Uri.parse("alipays://")
            val list = manager.queryIntentActivities(action, PackageManager.GET_RESOLVED_FILTER)
            result.success(list.size > 0)
        } else {
            result.error("-1", "can't find packageManager", null)
        }
    }

    private fun getAliPayVersion(result: MethodChannel.Result) {
        result.success(PayTask(activity).version ?: "")
    }

}