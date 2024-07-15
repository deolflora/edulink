import 'package:flutter/material.dart';
import 'package:flutter_app/pages/Login_or_Register.dart';
import 'package:flutter_app/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'package:http/http.dart' as http;

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _showSplashScreen();
    checkAuth();
  }

  Future<void> _showSplashScreen() async {
    await Future.delayed(const Duration(milliseconds: 960), () {});
  }

  Future<void> checkAuth() async {
    String url = 'https://802b-103-107-92-82.ngrok-free.app/home_page';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    if (token == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginOrRegisterPage()),
      );
      throw Exception('No token found');

    }
    final response = await http.get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});
    if (response.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginOrRegisterPage()),
      );
    }
    else if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(token: token)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage(onTap: () {},)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
       child: Image.asset('lib/images/Learning app_transparent.png',scale: 2),
      ),
    );
  }
}
