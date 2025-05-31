import 'package:flutter/material.dart';
import '../utils/helper.dart';

class RichTextWidget extends StatelessWidget {
  final TextStyle? textStyleOne;
  final TextStyle? textStyleTwo;
  final String textOne;
  final String textTwo;
  final Color? cTextOne;
  final Color? cTextTwo;
  final TextOverflow? overflow;
  final int? maxLines;

  const RichTextWidget({
    super.key,
    required this.textOne,
    required this.textTwo,
    this.cTextOne,
    this.cTextTwo,
    this.overflow,
    this.maxLines,
    this.textStyleOne,
    this.textStyleTwo,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: textOne,
        style: (textStyleOne ?? caption).copyWith(color: cTextOne),
        children: [
          TextSpan(
            text: textTwo,
            style: (textStyleTwo ?? subtitle2).copyWith(color: cTextTwo),
          ),
        ],
      ),
    );
  }
}
