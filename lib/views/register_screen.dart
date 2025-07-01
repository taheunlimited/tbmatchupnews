import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:matchupnews/routes/routes_name.dart';
import 'package:matchupnews/views/utils/form_validator.dart';
import 'package:matchupnews/views/utils/helper.dart';
import 'package:matchupnews/views/widgets/custom_form_field.dart';
import 'package:matchupnews/views/widgets/primary_button.dart';
import 'package:matchupnews/views/widgets/rich_text_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool isObsecure = true;

  void togglePasswordVisibility() {
    setState(() {
      isObsecure = !isObsecure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBgDc,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
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
                        'Halo!',
                        style: headline1.copyWith(
                          fontWeight: bold,
                          color: cWhite,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Daftar untuk mulai',
                        style: subtitle1.copyWith(
                          fontWeight: extrabold,
                          color: cLinear,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                vsMedium,
                Center(
                  child: Container(
                    width: 280.w,
                    height: 500.h,
                    padding:REdgeInsets.all(37),
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
                        RichTextWidget(
                          textOne: '* ',
                          textStyleOne: subtitle2.copyWith(color: cError),
                          textTwo: 'Username',
                          textStyleTwo: subtitle2.copyWith(color: cWhite),
                        ),
                        vsSuperTiny,
                        CustomFormField(
                          controller: nameController, 
                          hintText: 'Username', 
                          keyboardType: TextInputType.name, 
                          textInputAction: TextInputAction.next, 
                          validator: validateName,
                        ),
                        RichTextWidget(
                          textOne: '* ',
                          textStyleOne: subtitle2.copyWith(color: cError),
                          textTwo: 'No HP',
                          textStyleTwo: subtitle2.copyWith(color: cWhite),
                        ),
                        vsSuperTiny,
                        CustomFormField(
                          controller: phoneNumberController, 
                          hintText: 'No HP', 
                          keyboardType: TextInputType.number, 
                          textInputAction: TextInputAction.done, 
                          validator: validatePhoneNumber,
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
                          keyboardType: TextInputType.url, 
                          textInputAction: TextInputAction.done, 
                          suffixIcon: IconButton(
                            onPressed: togglePasswordVisibility, 
                            icon: 
                                isObsecure
                                    ? const Icon(Icons.visibility_outlined)
                                    : const Icon(Icons.visibility_off_outlined),
                          ),
                          validator: validatePassword,
                          obscureText: isObsecure,
                          

                        ),
                        SizedBox(height: 35),
                        PrimaryButton(
                          onPressed: () {
                            log('Register onTap');
                            context.goNamed(RouteNames.login);
                          },
                          title: 'Register',
                          width: 500,
                        ),
                        SizedBox(height: 33),
                        GestureDetector(
                          onTap: () {
                            context.pop();
                          },
                          child: Align(
                            alignment: Alignment.center,
                            child: RichTextWidget(
                              textOne: 'Sudah Punya Akun? ',
                              textStyleOne: subtitle2.copyWith(color: cWhite),
                              textTwo: 'Masuk',
                              textStyleTwo: subtitle2.copyWith(color: cPrimary),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
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