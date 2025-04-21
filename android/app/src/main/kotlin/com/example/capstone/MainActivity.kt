package com.example.capstone

import android.content.Context
import android.content.Intent
import androidx.annotation.NonNull
import com.navercorp.nid.NaverIdLoginSDK
import com.navercorp.nid.oauth.NidOAuthLogin
import com.navercorp.nid.oauth.OAuthLoginCallback
import com.navercorp.nid.profile.NidProfileCallback
import com.navercorp.nid.profile.data.NidProfileResponse
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import android.app.Activity
import android.os.Bundle
import android.util.Log
import org.json.JSONObject

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.capstone/naver_login"
    private val TAG = "MainActivity"
    private var channel: MethodChannel? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d(TAG, "onCreate called")
        
        // 네이버 SDK 초기화
        NaverIdLoginSDK.initialize(
            context = this,
            clientId = "yeSzw1A23EmZCwxmY46j",
            clientSecret = "uOz4XCe6NT",
            clientName = "Capstone"
        )
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        Log.d(TAG, "configureFlutterEngine called")
        
        // MethodChannel 초기화
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel?.setMethodCallHandler { call, result ->
            Log.d(TAG, "Method call received: ${call.method}")
            when (call.method) {
                "login" -> {
                    try {
                        Log.d(TAG, "Starting Naver authentication")
                        NaverIdLoginSDK.authenticate(this, object : OAuthLoginCallback {
                            override fun onSuccess() {
                                Log.d(TAG, "Naver authentication successful")
                                NidOAuthLogin().callProfileApi(object : NidProfileCallback<NidProfileResponse> {
                                    override fun onSuccess(response: NidProfileResponse) {
                                        Log.d(TAG, "Profile API call successful")
                                        val profile = response.profile
                                        val resultMap = mapOf(
                                            "status" to "success",
                                            "id" to (profile?.id ?: ""),
                                            "email" to (profile?.email ?: ""),
                                            "name" to (profile?.name ?: "")
                                        )
                                        result.success(resultMap)
                                    }

                                    override fun onError(errorCode: Int, message: String) {
                                        Log.e(TAG, "Profile API error: $message")
                                        result.error("PROFILE_ERROR", message, null)
                                    }

                                    override fun onFailure(httpStatus: Int, message: String) {
                                        Log.e(TAG, "Profile API failure: $message")
                                        result.error("PROFILE_FAILURE", message, null)
                                    }
                                })
                            }

                            override fun onError(errorCode: Int, message: String) {
                                Log.e(TAG, "Authentication error: $message")
                                result.error("LOGIN_ERROR", message, null)
                            }

                            override fun onFailure(httpStatus: Int, message: String) {
                                Log.e(TAG, "Authentication failure: $message")
                                result.error("LOGIN_FAILURE", message, null)
                            }
                        })
                    } catch (e: Exception) {
                        Log.e(TAG, "Exception during Naver login: ${e.message}")
                        result.error("INIT_ERROR", e.message, null)
                    }
                }
                "logout" -> {
                    try {
                        NaverIdLoginSDK.logout()
                        result.success("success")
                    } catch (e: Exception) {
                        Log.e(TAG, "Exception during Naver logout: ${e.message}")
                        result.error("LOGOUT_ERROR", e.message, null)
                    }
                }
                else -> {
                    Log.e(TAG, "Unknown method called: ${call.method}")
                    result.notImplemented()
                }
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        channel?.setMethodCallHandler(null)
    }
}
