import 'package:flutter/material.dart';

class CustomCarnetText extends StatelessWidget {
  final Color color;
  final String text;
  final bool isBold;

  const CustomCarnetText({
    super.key,
    required this.color,
    required this.text,
    this.isBold = false
  });

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
