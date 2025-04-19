import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'secret.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(
    nativeAppKey: 'kakaoNativeAppKey',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NetPlus',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

// 로그인 함수
Future<void> _naverLogin() async {
  try {
    NaverLoginResult _result = await FlutterNaverLogin.logIn();
    if (_result.status == NaverLoginStatus.loggedIn) {
      String _id = _result.account.id;
      String _email = _result.account.email;
      // 로그인 성공 시 처리
      print('네이버 로그인 성공: $_id, $_email');
    }
  } catch (e) {
    print('네이버 로그인 실패: $e');
  }
}

// 로그아웃 함수
Future<void> _naverLogout() async {
  await FlutterNaverLogin.logOut();
  print('네이버 로그아웃 성공');
}
