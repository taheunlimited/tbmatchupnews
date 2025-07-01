import 'package:flutter/material.dart';
import 'package:matchupnews/views/utils/helper.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String hintText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final int? maxLines;
  final bool readOnly;
  final void Function(String)? onChanged;
  final VoidCallback? onTap;

  const CustomFormField({
    super.key,
    required this.controller,
    this.obscureText = false,
    required this.hintText,
    this.suffixIcon,
    required this.keyboardType,
    required this.textInputAction,
    required this.validator,
    this.maxLines = 1,
    this.readOnly = false,
    this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      cursorColor: cPrimary,
      cursorErrorColor: cError,
      decoration: InputDecoration(
        filled: true,
        fillColor: cWhite,
        enabledBorder: enableBorder,
        focusedBorder: focusedBorder,
        errorBorder: errorBorder,
        errorStyle: caption.copyWith(color: cError),
        errorMaxLines: 2,
        focusedErrorBorder: focusedErrorBorder,
        hintText: hintText,
        hintStyle: subtitle2.copyWith(color: cBlack),
        suffixIcon: suffixIcon,
        suffixIconColor: cPrimary,
      ),
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: subtitle2,
      maxLines: maxLines,
      readOnly: readOnly,
      onChanged: onChanged,
      onTap: onTap,
    );
  }
}
