import 'package:flutter/material.dart';

class CustomCarnetText extends StatelessWidget {
  final Color color;
  final String text;
  final bool isBold;

  const CustomCarnetText({Key? key, required this.color, required this.text, this.isBold = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        fontSize: 18,
        color: color,
      ),
    );
  }
}
