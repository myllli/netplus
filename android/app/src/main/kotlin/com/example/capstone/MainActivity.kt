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
import android.net.VpnService
import java.io.File
import java.io.FileOutputStream

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.capstone/naver_login"
    private val VPN_CHANNEL = "com.example.capstone/openvpn"
    private val TAG = "MainActivity"
    private var channel: MethodChannel? = null
    private var vpnChannel: MethodChannel? = null
    private var currentResult: MethodChannel.Result? = null

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
        vpnChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, VPN_CHANNEL)
        
        // 네이버 로그인 채널 설정
        channel?.setMethodCallHandler { call, result ->
            Log.d(TAG, "Method call received: ${call.method}")
            when (call.method) {
                "login" -> {
                    try {
                        currentResult = result
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
                                        currentResult?.success(resultMap)
                                        currentResult = null
                                    }

                                    override fun onError(errorCode: Int, message: String) {
                                        Log.e(TAG, "Profile API error: $message")
                                        currentResult?.error("PROFILE_ERROR", message, null)
                                        currentResult = null
                                    }

                                    override fun onFailure(httpStatus: Int, message: String) {
                                        Log.e(TAG, "Profile API failure: $message")
                                        currentResult?.error("PROFILE_FAILURE", message, null)
                                        currentResult = null
                                    }
                                })
                            }

                            override fun onError(errorCode: Int, message: String) {
                                Log.e(TAG, "Authentication error: $message")
                                currentResult?.error("LOGIN_ERROR", message, null)
                                currentResult = null
                            }

                            override fun onFailure(httpStatus: Int, message: String) {
                                Log.e(TAG, "Authentication failure: $message")
                                currentResult?.error("LOGIN_FAILURE", message, null)
                                currentResult = null
                            }
                        })
                    } catch (e: Exception) {
                        Log.e(TAG, "Exception during Naver login: ${e.message}")
                        currentResult?.error("INIT_ERROR", e.message, null)
                        currentResult = null
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

        // VPN 채널 설정
        vpnChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "startVpn" -> {
                    try {
                        val config = call.arguments as Map<String, String>
                        startVpn(config)
                        result.success(null)
                    } catch (e: Exception) {
                        Log.e(TAG, "Error starting VPN: ${e.message}")
                        result.error("VPN_ERROR", e.message, null)
                    }
                }
                "stopVpn" -> {
                    try {
                        stopVpn()
                        result.success(null)
                    } catch (e: Exception) {
                        Log.e(TAG, "Error stopping VPN: ${e.message}")
                        result.error("VPN_ERROR", e.message, null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun startVpn(config: Map<String, String>) {
        val intent = VpnService.prepare(this)
        if (intent != null) {
            startActivityForResult(intent, 0)
        } else {
            onActivityResult(0, Activity.RESULT_OK, null)
        }
    }

    private fun stopVpn() {
        // VPN 서비스 중지 로직 구현
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == 0 && resultCode == Activity.RESULT_OK) {
            // VPN 서비스 시작 로직 구현
            val ovpnConfig = """
                client
                proto udp
                explicit-exit-notify
                remote 108.61.180.5 992
                dev tun
                resolv-retry infinite
                nobind
                persist-key
                persist-tun
                remote-cert-tls server
                verify-x509-name server_pQt6qmnJWBJyMnMS name
                auth SHA256
                auth-nocache
                cipher AES-128-GCM
                tls-client
                tls-version-min 1.2
                tls-cipher TLS-ECDHE-ECDSA-WITH-AES-128-GCM-SHA256
                ignore-unknown-option block-outside-dns
                setenv opt block-outside-dns # Prevent Windows 10 DNS leak
                verb 3
                <ca>
                -----BEGIN CERTIFICATE-----
                MIIB1zCCAX2gAwIBAgIUHqbNiDsyqvDPc4v7Zg+AZYt/M7AwCgYIKoZIzj0EAwIw
                HjEcMBoGA1UEAwwTY25_feXpWMVhOZzUzQ0s0OFBodTAeFw0yNTA0MDUwMzUzNDZa
                Fw0zNTA0MDMwMzUzNDZaMB4xHDAaBgNVBAMME2NuX3l6VjFYTmc1M0NLNDhQaHUw
                WTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAAT6g2epoXqRkOtuOuqsSCCqeOZndOqR
                10GOG8kNjBjTlaYuOxIV1AZlqfgYnTwnldPLLdcuKVrOGwaOQ56nOiI7o4GYMIGV
                MAwGA1UdEwQFMAMBAf8wHQYDVR0OBBYEFDV1+e5jk8hwvT6aCQex+CUUY9HYMFkG
                A1UdIwRSMFCAFDV1+e5jk8hwvT6aCQex+CUUY9HYoSKkIDAeMRwwGgYDVQQDDBNj
                bl95elYxWE5nNTNDSzQ4UGh1ghQeps2IOzKq8M9zi/tmD4Bli38zsDALBgNVHQ8E
                BAMCAQYwCgYIKoZIzj0EAwIDSAAwRQIgKuG5ORqvOqncxPgeFNnT327RiPMkfD3y
                HDuVff0UOG0CIQCwkjezOV9fz1ib/TvHXFY3UJj78S9PWctE3SyBxUb4cg==
                -----END CERTIFICATE-----
                </ca>
                <cert>
                -----BEGIN CERTIFICATE-----
                MIIB4TCCAYegAwIBAgIRAOZe0NZ2PQPB7xEiX1zshUIwCgYIKoZIzj0EAwIwHjEc
                MBoGA1UEAwwTY25_feXpWMVhOZzUzQ0s0OFBodTAeFw0yNTA0MDUwNDA0MzRaFw0z
                NTA0MDMwNDA0MzRaMBkxFzAVBgNVBAMMDm5ldHBsdXNfY2xpZW50MFkwEwYHKoZI
                zj0CAQYIKoZIzj0DAQcDQgAEK+VDHDggqGILlHNUvMbMr7PBk4OZqMhqaGaJLBa9
                oeBCwWfQNMXx9uCipgMeNBmcRV+sKPClKDQr05bjPtdCXKOBqjCBpzAJBgNVHRME
                AjAAMB0GA1UdDgQWBBRutv8fjIDhMh3nCEn0Ep/w9pCRcjBZBgNVHSMEUjBQgBQ1
                dfnuY5PIcL0+mgkHsfglFGPR2KEipCAwHjEcMBoGA1UEAwwTY25_feXpWMVhOZzUz
                Q0s0OFBodYIUHqbNiDsyqvDPc4v7Zg+AZYt/M7AwEwYDVR0lBAwwCgYIKwYBBQUH
                AwIwCwYDVR0PBAQDAgeAMAoGCCqGSM49BAMCA0gAMEUCIBv75Fa4HzlyHUMO5bb/
                JeEZHNrUJXFttyv/70ZvflinAiEA3FLJTwJjj4p5qe6Qey7dQAIsjLTtjrG/Rx/T
                x85KZDE=
                -----END CERTIFICATE-----
                </cert>
                <key>
                -----BEGIN PRIVATE KEY-----
                MIGHAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBG0wawIBAQQg37kt/MpMONHmxBvK
                5fqosk7YoQwDzKbZ9r4iKqz/6kehRANCAAQr5UMcOCCoYguUc1S8xsyvs8GTg5mo
                yGpoZoksFr2h4ELBZ9A0xfH24KKmAx40GZxFX6wo8KUoNCvTluM+10Jc
                -----END PRIVATE KEY-----
                </key>
                <tls-crypt>
                #
                # 2048 bit OpenVPN static key
                #
                -----BEGIN OpenVPN Static key V1-----
                83fafcf2f4fdd14e012f31b944ebce21
                b116c633f369e2a1791499b455685db4
                ea8bed9e2b66e29f008d3a570d6f159f
                0501b82896ad58f248e1259d144d9839
                d8a1db0ced082dab403b1c80d2b127e8
                8d53c2d977e7297ffd6b24dd01eb2d2b
                b07ec8ca060de6e0c6547e8392e5153a
                f55d457f58c0d33d27e3dd6c9e9a47a4
                12ad730ed58e0b00d53d8e44bcbe006f
                bf00f8e153a4e90134f133cac50d0c1c
                b8256ef7ba2aadc7ac3fcfdc50270c94
                cbc28637000759093ff2c7177bdccd1c
                c43c76dedb7c1b12c1429e53846af9f4
                66f9a616a42c26143d555df7ecd97524
                a612faec28e92347006eec74818ac464
                03ff1bc9c2f5969f05f6d5c846b58da4
                -----END OpenVPN Static key V1-----
                </tls-crypt>
            """.trimIndent()

            val configFile = File(filesDir, "netplus_client.ovpn")
            FileOutputStream(configFile).use { it.write(ovpnConfig.toByteArray()) }

            val intent = Intent(this, VpnService::class.java)
            intent.putExtra("config", configFile.absolutePath)
            startService(intent)
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        channel?.setMethodCallHandler(null)
        vpnChannel?.setMethodCallHandler(null)
    }
}
