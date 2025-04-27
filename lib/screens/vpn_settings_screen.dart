import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vpn_provider.dart';

class VpnSettingsScreen extends StatefulWidget {
  const VpnSettingsScreen({super.key});

  @override
  State<VpnSettingsScreen> createState() => _VpnSettingsScreenState();
}

class _VpnSettingsScreenState extends State<VpnSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _serverController = TextEditingController(text: '108.61.180.5');
  final _portController = TextEditingController(text: '992');
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _caController =
      TextEditingController(text: '''-----BEGIN CERTIFICATE-----
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
-----END CERTIFICATE-----''');
  final _certController =
      TextEditingController(text: '''-----BEGIN CERTIFICATE-----
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
-----END CERTIFICATE-----''');
  final _keyController =
      TextEditingController(text: '''-----BEGIN PRIVATE KEY-----
MIGHAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBG0wawIBAQQg37kt/MpMONHmxBvK
5fqosk7YoQwDzKbZ9r4iKqz/6kehRANCAAQr5UMcOCCoYguUc1S8xsyvs8GTg5mo
yGpoZoksFr2h4ELBZ9A0xfH24KKmAx40GZxFX6wo8KUoNCvTluM+10Jc
-----END PRIVATE KEY-----''');
  String _selectedProtocol = 'udp';

  @override
  void dispose() {
    _serverController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _caController.dispose();
    _certController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VPN 설정'),
        toolbarHeight: 28,
      ),
      body: Consumer<VpnProvider>(
        builder: (context, vpnProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _serverController,
                    decoration: const InputDecoration(
                      labelText: '서버 주소',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '서버 주소를 입력해주세요';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _portController,
                    decoration: const InputDecoration(
                      labelText: '포트',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '포트를 입력해주세요';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedProtocol,
                    decoration: const InputDecoration(
                      labelText: '프로토콜',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'udp', child: Text('UDP')),
                      DropdownMenuItem(value: 'tcp', child: Text('TCP')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedProtocol = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _caController,
                    decoration: const InputDecoration(
                      labelText: 'CA 인증서',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'CA 인증서를 입력해주세요';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _certController,
                    decoration: const InputDecoration(
                      labelText: '클라이언트 인증서',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '클라이언트 인증서를 입력해주세요';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _keyController,
                    decoration: const InputDecoration(
                      labelText: '클라이언트 키',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '클라이언트 키를 입력해주세요';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Consumer<VpnProvider>(
                    builder: (context, vpnProvider, child) {
                      final isConnected = vpnProvider.isConnected;
                      final server = _serverController.text;
                      final port = _portController.text;
                      return Column(
                        children: [
                          Text(
                            'IP: ${isConnected ? server : "연결되지 않음"}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  color:
                                      isConnected ? Colors.green : Colors.red,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '연결 상태: ${isConnected ? "연결됨" : "연결 해제됨"}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  color:
                                      isConnected ? Colors.green : Colors.red,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
