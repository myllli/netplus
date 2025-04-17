import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'token_manager.dart' as my_token;

class KakaoLoginService {
  static Future<void> login(BuildContext context) async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      OAuthToken token;

      if (isInstalled) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }

      // ✅ 토큰을 서버로 전송하여 JWT 받기
      final jwt = await my_token.TokenManager.sendKakaoTokenToServer(token.accessToken);
      if (jwt != null) {
        print('✅ JWT 발급 성공: $jwt');
        // JWT 저장하거나 다음 페이지로 넘기기
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        print('❌ JWT 발급 실패');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('서버 인증 실패')),
        );
      }
    } catch (error) {
      print('🚨 로그인 에러 발생: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인 실패')),
      );
    }
  }
}

