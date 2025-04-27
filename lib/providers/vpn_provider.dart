import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../services/vpn_service.dart';

class VpnProvider with ChangeNotifier {
  final VpnService _vpnService = VpnService();
  bool _isConnected = false;
  String _status = '연결 해제됨';
  final _platform = const MethodChannel('com.example.capstone/openvpn');

  bool get isConnected => _isConnected;
  String get status => _status;

  VpnProvider() {
    _setupMethodChannel();
  }

  void _setupMethodChannel() {
    const platform = MethodChannel('com.example.capstone/openvpn');
    platform.setMethodCallHandler((call) async {
      if (call.method == 'onVpnStateChanged') {
        _status = call.arguments as String;
        _isConnected = _status == 'CONNECTED';
        notifyListeners();
      }
    });
  }

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

      await _platform.invokeMethod('startVpn', config);
      _isConnected = true;
      _status = '연결됨';
      notifyListeners();
    } catch (e) {
      _status = '연결 실패: ${e.toString()}';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> stopVpn() async {
    try {
      await _platform.invokeMethod('stopVpn');
      _isConnected = false;
      _status = '연결 해제됨';
      notifyListeners();
    } catch (e) {
      _status = '연결 해제 실패: ${e.toString()}';
      notifyListeners();
      rethrow;
    }
  }
}
