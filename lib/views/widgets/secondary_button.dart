import 'package:flutter/material.dart';
import '../utils/helper.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.width,
  });

  final String title;
  final VoidCallback? onPressed;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: OutlinedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: cLinear,
          padding: const EdgeInsets.symmetric(vertical: 17),
          side: BorderSide(color: cLinear),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(color: cLinear),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: subtitle1.copyWith(color: cDarkDc, fontWeight: semibold),
        ),
      ),
    );
  }
}
