// lib/secret.dart
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

const kakaoNativeAppKey = '75080664d9d7058a5657030c4ad5bad6';
const naverClientId = 'yeSzw1A23EmZCwxmY46j';
const naverClientSecret = 'uOz4XCe6NT';

class SecretPage extends StatelessWidget {
  const SecretPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secret Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // 네이버 로그인 구현
              },
              child: const Text('네이버 로그인'),
            ),
          ],
        ),
      ),
    );
  }
}

// 로그아웃
Future<void> logout() async {
  // 네이버 로그아웃 구현
}

