package com.example.capstone

import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.os.Build
import android.util.Base64
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import java.security.MessageDigest

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)

        // 🔥 여기 키 해시 출력 코드
        try {
            val info = packageManager.getPackageInfo(packageName, PackageManager.GET_SIGNING_CERTIFICATES)

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                // API 28 이상
                val signatures = info.signingInfo?.apkContentsSigners
                signatures?.forEach { signature ->
                    val md = MessageDigest.getInstance("SHA")
                    md.update(signature.toByteArray())
                    val keyHash = Base64.encodeToString(md.digest(), Base64.NO_WRAP)
                    Log.d("🔥 KeyHash", "KeyHash: $keyHash")
                }
            } else {
                // API 28 미만
                @Suppress("DEPRECATION")
                val signatures = info.signatures
                signatures?.forEach { signature ->
                    val md = MessageDigest.getInstance("SHA")
                    md.update(signature.toByteArray())
                    val keyHash = Base64.encodeToString(md.digest(), Base64.NO_WRAP)
                    Log.d("🔥 KeyHash", "KeyHash: $keyHash")
                }
            }
        } catch (e: Exception) {
            Log.e("🔥 KeyHash", "Error getting KeyHash", e)
        }
    }
}
