// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import '../services/kakao_login_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Image.asset(
              'assets/images/netplus_logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 80),
            GestureDetector(
              onTap: () {
                KakaoLoginService.login(context);
              },
              child: Image.asset(
                'assets/images/kakao_login.png',
                width: 200,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // 네이버 로그인 구현 예정
              },
              child: Image.asset(
                'assets/images/naver_login.png',
                width: 200,
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
