import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:matchupnews/routes/routes_name.dart';
import 'package:matchupnews/views/bookmark_provider.dart';
import 'package:matchupnews/views/utils/form_validator.dart';
import 'package:matchupnews/views/utils/helper.dart';
import 'package:matchupnews/views/widgets/custom_form_field.dart';
import 'package:matchupnews/views/widgets/primary_button.dart';
import 'package:matchupnews/views/widgets/rich_text_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool isObsecure = true;

  void togglePasswordVisibility() {
    setState(() {
      isObsecure = !isObsecure;
    });
  }

  Future<void> _continueAsGuest() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Provider.of<BookmarkProvider>(context, listen: false).setToken(null);
    if (context.mounted) context.goNamed(RouteNames.main);
  }

  Future<void> _handleLogin() async {
    if (formkey.currentState!.validate()) {
      final email = emailController.text;
      final password = passwordController.text;

      try {
        final data = await loginUser(email, password);

        if (data['success'] == true) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', data['data']['token']);
          Provider.of<BookmarkProvider>(context, listen: false).setToken(data['data']['token']);


          if (context.mounted) context.goNamed(RouteNames.main);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Login gagal')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  // ✅ Fungsi login langsung disatukan
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final url = Uri.parse('https://rest-api-berita.vercel.app/api/v1/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBgDc,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 70),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Selamat Datang di',
                        style: headline2.copyWith(
                          fontWeight: bold,
                          color: cWhite,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 6),
                      Text(
                        'MATCHUP!',
                        style: headline1.copyWith(
                          fontWeight: extrabold,
                          color: cLinear,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                vsXLarge,
                Center(
                  child: Container(
                    width: 280.w,
                    height: 450.h,
                    padding: REdgeInsets.all(50),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: cBoxDc,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichTextWidget(
                          textOne: '* ',
                          textStyleOne: subtitle2.copyWith(color: cError),
                          textTwo: 'Email',
                          textStyleTwo: subtitle2.copyWith(color: cWhite),
                        ),
                        vsSuperTiny,
                        CustomFormField(
                          controller: emailController,
                          hintText: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: validateEmail,
                        ),
                        vsSmall,
                        RichTextWidget(
                          textOne: '* ',
                          textStyleOne: subtitle2.copyWith(color: cError),
                          textTwo: 'Password',
                          textStyleTwo: subtitle2.copyWith(color: cWhite),
                        ),
                        vsSuperTiny,
                        CustomFormField(
                          controller: passwordController,
                          hintText: 'Password',
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          suffixIcon: IconButton(
                            onPressed: togglePasswordVisibility,
                            icon: isObsecure
                                ? const Icon(Icons.visibility_outlined)
                                : const Icon(Icons.visibility_off_outlined),
                          ),
                          validator: validatePassword,
                          obscureText: isObsecure,
                        ),
                        vsMedium,
                        GestureDetector(
                          onTap: () {
                            log('Forgot Password onTap');
                          },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Forgot Password?',
                              style: subtitle2.copyWith(color: cError),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Center(
                          child: PrimaryButton(
                            onPressed: _handleLogin,
                            title: 'Login',
                            width: 500,
                          ),
                        ),
                        vsSmall,
                        SizedBox(height: 30),
                        GestureDetector(
                          onTap: () {
                            context.pushNamed(RouteNames.register);
                          },
                          child: Align(
                            alignment: Alignment.center,
                            child: RichTextWidget(
                              textOne: 'Belum punya akun? ',
                              textStyleOne: subtitle2.copyWith(color: cWhite),
                              textTwo: 'Daftar',
                              textStyleTwo: subtitle2.copyWith(color: cLinear),
                            ),
                          ),
                        ),
                        vsSmall,
                        GestureDetector(
                          onTap: _continueAsGuest,
                          child: Align(
                            alignment: Alignment.center,
                            child: RichTextWidget(
                              textOne: 'Masuk tanpa akun? ',
                              textStyleOne: subtitle2.copyWith(color: cWhite),
                              textTwo: 'Masuk sebagai Guest',
                              textStyleTwo: subtitle2.copyWith(color: cLinear),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
