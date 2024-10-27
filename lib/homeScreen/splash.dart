import 'package:flutter/material.dart';
import 'package:weather/homeScreen/home.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Hero(
          tag: "tag",
          child: ClipOval(
            child: SizedBox(
              width: 300,
              height: 300,
              child: Image.asset(
                'assets/backgrounds/splash.gif',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
