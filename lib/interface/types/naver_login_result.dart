import 'naver_account_result.dart';

class NaverLoginResult {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresAt;
  final NaverAccountResult account;

  NaverLoginResult({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresAt,
    required this.account,
  });

  factory NaverLoginResult.fromJson(Map<String, dynamic> json) {
    return NaverLoginResult(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      tokenType: json['token_type'] ?? '',
      expiresAt: json['expires_at'] ?? 0,
      account: NaverAccountResult.fromJson(json['account'] ?? {}),
    );
  }
}
