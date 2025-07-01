import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matchupnews/routes/routes_name.dart';
import 'package:matchupnews/views/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:matchupnews/views/bookmark_provider.dart'; // Tambahkan ini

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp(); // ✅ Pindahkan ke fungsi khusus
  }

  Future<void> _initApp() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // ✅ Update state BookmarkProvider
    Provider.of<BookmarkProvider>(context, listen: false).setToken(token);

    // ✅ Delay seperti sebelumnya
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      context.goNamed(RouteNames.introduction);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBgDc,
      body: Center(
        child: Image.asset('assets/images/logo matchup.png', width: 123),
      ),
    );
  }
}
