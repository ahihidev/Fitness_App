import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:specialized_project_2/common/color_extension.dart';
import 'package:specialized_project_2/screen/home/top_tab_view/top_tab_view_screen.dart';
import 'package:specialized_project_2/screen/login/sign_up_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Hàm để kiểm tra xem người dùng đã đăng nhập chưa
  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitnesApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Poppins",
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
            elevation: 0, backgroundColor: Colors.transparent),
        colorScheme: ColorScheme.fromSeed(seedColor: TColor.primary),
        useMaterial3: false,
      ),
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Nếu người dùng đã đăng nhập, chuyển sang màn hình Home
          return snapshot.data == true ? TopTabViewScreen() : AuthScreen();
        },
      ),
    );
  }
}
/*
email: theanh@gmail.com
password: @Theanh123
* */
