package com.example.linkhive_flutter

import android.os.Bundle
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import com.android.installreferrer.api.InstallReferrerClient
import com.android.installreferrer.api.InstallReferrerStateListener

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.linkhive.deferredlink"

    override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getLinkShortCode") {
                getShortCode(result)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getShortCode(result: MethodChannel.Result) {
        val referrerClient = InstallReferrerClient.newBuilder(this).build()

        referrerClient.startConnection(object : InstallReferrerStateListener {
            override fun onInstallReferrerSetupFinished(responseCode: Int) {
                if (responseCode == InstallReferrerClient.InstallReferrerResponse.OK) {
                    val response = referrerClient.installReferrer
                    val referrerUrl = response.installReferrer // e.g. "shortCode=abcd1234"

                    // Parse the referrer URL to extract shortCode
                    val shortCode = parseShortCodeFromUrl(referrerUrl)
                    result.success(shortCode) // Return the shortCode to Flutter
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

    // Parse the referrer URL to extract the shortCode
    private fun parseShortCodeFromUrl(referrerUrl: String): String? {
        try {
            // Parse the referrer URL
            val uri = Uri.parse(referrerUrl)

            // Extract the "shortCode" parameter from the referrer URL
            return uri.getQueryParameter("shortCode") // e.g. shortCode=abcd1234
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return null
    }
}
