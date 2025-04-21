// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/kakao_login_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _handleNaverLogin(BuildContext context) async {
    try {
      const platform = MethodChannel('com.example.capstone/naver_login');
      final Map<dynamic, dynamic> result = await platform.invokeMethod('login');

      if (result['status'] == 'success') {
        final String id = result['id'];
        final String email = result['email'];
        final String name = result['name'];

        print('네이버 로그인 성공');
        print('ID: $id');
        print('Email: $email');
        print('Name: $name');

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        print('네이버 로그인 실패: ${result['error']}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('네이버 로그인 실패')),
        );
      }
    } on PlatformException catch (e) {
      print('네이버 로그인 에러: ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('네이버 로그인 에러: ${e.message}')),
      );
    } catch (e) {
      print('네이버 로그인 에러: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('네이버 로그인 실패')),
      );
    }
  }

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
                _handleNaverLogin(context);
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
