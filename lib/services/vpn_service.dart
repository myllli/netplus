import 'package:flutter/services.dart';

class VpnService {
  static const platform = MethodChannel('com.example.capstone/openvpn');

  Future<void> startVpn({
    required String server,
    required String port,
    required String protocol,
    required String username,
    required String password,
    required String ca,
    required String cert,
    required String key,
  }) async {
    try {
      final config = {
        'server': server,
        'port': port,
        'protocol': protocol,
        'username': username,
        'password': password,
        'ca': ca,
        'cert': cert,
        'key': key,
      };
      await platform.invokeMethod('startVpn', config);
    } on PlatformException catch (e) {
      print('VPN 시작 에러: ${e.message}');
      rethrow;
    }
  }

  Future<void> stopVpn() async {
    try {
      await platform.invokeMethod('stopVpn');
    } on PlatformException catch (e) {
      print('VPN 중지 에러: ${e.message}');
      rethrow;
    }
  }
}
