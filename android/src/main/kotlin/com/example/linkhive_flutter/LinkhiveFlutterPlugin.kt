package com.example.linkhive_flutter

import android.content.Context
import android.net.Uri
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.android.installreferrer.api.InstallReferrerClient
import com.android.installreferrer.api.InstallReferrerStateListener


class LinkhiveFlutterPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "com.linkhive.deferredlink")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "getLinkShortCode") {
            getShortCode(result)
        } else {
            result.notImplemented()
        }
    }

    private fun getShortCode(result: MethodChannel.Result) {
        val referrerClient = InstallReferrerClient.newBuilder(context).build()

        referrerClient.startConnection(object : InstallReferrerStateListener {
            override fun onInstallReferrerSetupFinished(responseCode: Int) {
                if (responseCode == InstallReferrerClient.InstallReferrerResponse.OK) {
                    val response = referrerClient.installReferrer
                    val referrerUrl = response.installReferrer // e.g. "shortCode=abcd1234"
                    val shortCode = parseShortCodeFromUrl(referrerUrl)
                    result.success(shortCode)
                } else {
                    result.success(null)
                }
                referrerClient.endConnection()
            }

            override fun onInstallReferrerServiceDisconnected() {
                result.success(null)
            }
        })
    }

    private fun parseShortCodeFromUrl(referrerUrl: String): String? {
        return try {
            val uri = Uri.parse("https://linkhive.tech/?" + referrerUrl)
            uri.getQueryParameter("shortCode")
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }
}


