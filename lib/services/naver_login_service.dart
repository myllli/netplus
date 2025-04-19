import 'package:flutter/material.dart';
// import 'package:flutter_naver_login/flutter_naver_login.dart'; // 제거

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Naver Login Example'),
        ),
        body: Center(
          child: ElevatedButton(
            child: Text('Login with Naver'),
            onPressed: () async {
              // final NaverLoginResult res = await FlutterNaverLogin.logIn(); // 제거
              // print(res); // 제거
              // if (res.status == NaverLoginStatus.loggedIn) { // 제거
              //   print('Naver login success'); // 제거
              //   print(res.account.toString()); // 제거
              // } else { // 제거
              //   print('Naver login failed'); // 제거
              // } // 제거
            },
          ),
        ),
      ),
    );
  }
}
