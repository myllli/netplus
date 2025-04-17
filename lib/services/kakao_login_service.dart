import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'token_manager.dart' as my_token;
import 'package:flutter/services.dart';

class KakaoLoginService {
  static Future<void> login(BuildContext context) async {
    try {
      // ✅ 이미 로그인된 토큰이 존재하는지 확인
      if (await AuthApi.instance.hasToken()) {
        try {
          AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
          print('🔄 기존 토큰 유효함, 유저 ID: ${tokenInfo.id}');

          // 서버에 기존 토큰 전송 → JWT 받기
          final token = await AuthApi.instance.refreshToken(); // access token 재발급
          final jwt = await my_token.TokenManager.sendKakaoTokenToServer(token.accessToken);
          if (jwt != null) {
            print('✅ JWT 발급 성공: $jwt');
            Navigator.pushReplacementNamed(context, '/home');
            return;
          } else {
            print('❌ JWT 발급 실패');
          }
        } catch (error) {
          print('❌ 기존 토큰 만료 또는 유효하지 않음: $error');
        }
      }

      // ✅ 카카오톡 설치 여부 확인
      bool isInstalled = await isKakaoTalkInstalled();
      OAuthToken token;

      if (isInstalled) {
        try {
          token = await UserApi.instance.loginWithKakaoTalk();
          print('✅ 카카오톡 로그인 성공');
        } catch (error) {
          if (error is PlatformException && error.code == 'CANCELED') return;

          print('⚠️ 카카오톡 로그인 실패, 계정 로그인 시도: $error');
          token = await UserApi.instance.loginWithKakaoAccount();
        }
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
        print('✅ 카카오계정 로그인 성공');
      }

      // ✅ 토큰을 서버로 전송하여 JWT 받기
      final jwt = await my_token.TokenManager.sendKakaoTokenToServer(token.accessToken);
      if (jwt != null) {
        print('✅ JWT 발급 성공: $jwt');
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
