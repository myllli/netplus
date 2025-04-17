// lib/services/token_manager.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class TokenManager {
  /// ✅ 카카오 토큰을 서버에 보내고 JWT를 받는 함수
  static Future<String?> sendKakaoTokenToServer(String kakaoAccessToken) async {
    try {
      final response = await http.post(
        Uri.parse('https://your-auth-server.com/api/auth/kakao'), // 인증 서버 주소
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'access_token': kakaoAccessToken}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return responseBody['jwt']; // 서버에서 jwt 필드로 반환된다고 가정
      } else {
        print('❌ 카카오 토큰 전송 실패: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('🚨 카카오 토큰 처리 중 오류: $e');
      return null;
    }
  }

  /// ✅ 네이버 토큰을 서버에 보내고 JWT를 받는 함수
  static Future<String?> sendNaverTokenToServer(String naverAccessToken) async {
    try {
      final response = await http.post(
        Uri.parse('https://your-auth-server.com/api/auth/naver'), // 인증 서버 주소
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'access_token': naverAccessToken}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return responseBody['jwt'];
      } else {
        print('❌ 네이버 토큰 전송 실패: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('🚨 네이버 토큰 처리 중 오류: $e');
      return null;
    }
  }
}

