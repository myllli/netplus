import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoLoginService {
  static Future<void> login(BuildContext context) async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();

      if (isInstalled) {
        await UserApi.instance.loginWithKakaoTalk();
      } else {
        await UserApi.instance.loginWithKakaoAccount();
      }

      Navigator.pushReplacementNamed(context, '/home');
    } catch (error) {
      print('🚨 로그인 에러 발생: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인 실패')),
      );
    }
  }
}
