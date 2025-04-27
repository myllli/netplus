import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/vpn_settings_screen.dart';
import 'providers/vpn_provider.dart';
import 'secret.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(nativeAppKey: kakaoNativeAppKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VpnProvider()),
      ],
      child: MaterialApp(
        title: 'NetPlus',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          brightness: Brightness.dark,
          colorScheme: ColorScheme.dark(
            primary: Colors.deepPurple,
            secondary: Colors.deepPurple,
            surface: Colors.black,
            background: Colors.black,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            elevation: 0,
          ),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/vpn-settings': (context) => const VpnSettingsScreen(),
        },
      ),
    );
  }
}

// 네이버 로그인 함수
Future<void> _naverLogin() async {
  const platform = MethodChannel('com.example.capstone/naver_login');
  try {
    final result = await platform.invokeMethod('login');
    print('네이버 로그인 결과: $result');
  } on PlatformException catch (e) {
    print('네이버 로그인 에러: $e');
  }
}

// 네이버 로그아웃 함수
Future<void> _naverLogout() async {
  const platform = MethodChannel('com.example.capstone/naver_login');
  try {
    await platform.invokeMethod('logout');
    print('네이버 로그아웃 성공');
  } on PlatformException catch (e) {
    print('네이버 로그아웃 에러: $e');
  }
}
