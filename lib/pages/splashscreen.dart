import 'package:flutter/material.dart';
import 'dart:async';
import '/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userID = prefs.getInt('userID');
    int? lastLoginTime = prefs.getInt('lastLoginTime');

    if (userID != null && lastLoginTime != null) {
      int currentTime = DateTime.now().millisecondsSinceEpoch;
      // Check if user has login less than 24 hours
      if (currentTime - lastLoginTime <= 86400000) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // Expired session
        _redirectToLoginPage();
      }
    } else {
      // No Login data
      _redirectToLoginPage();
    }
  }

  void _redirectToLoginPage() {
    Timer(
        Duration(seconds: 5),
        () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginPage()),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/splashscreen.png',
            fit: BoxFit.cover,
          ),
          Center(
            child: Image.asset(
              'assets/logo-glutara.png',
              width: 200,
              height: 200,
            ),
          ),
        ],
      ),
    );
  }
}
