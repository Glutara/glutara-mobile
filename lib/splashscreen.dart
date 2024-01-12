import 'package:flutter/material.dart';
import 'dart:async';
import '/pages/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 5),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      ),
    );
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
