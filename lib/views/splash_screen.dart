import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matchupnews/routes/routes_name.dart';
import 'package:matchupnews/views/utils/helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.goNamed(RouteNames.introduction);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cWhite,
      body: Center(
        child: Image.asset('assets/images/logo Ai no bg-01.png', width: 123),
      ),
    );
  }
}