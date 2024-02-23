import 'dart:async';
import 'package:restaurant_app_api/ui/home_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const routeName = '/splashscreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBBB00),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/food.png',
              height: 200.0,
              width: 200.0,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  void movingToNextScreen() async {
    Timer(
        const Duration(
          seconds: 4,
        ), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ));
    });
  }

  @override
  void initState() {
    super.initState();
    movingToNextScreen();
  }
}
