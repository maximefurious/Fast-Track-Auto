import 'package:flutter/material.dart';

class CustomListItemText extends StatelessWidget {
  final Color color;
  final String text;
  final bool isBig;
  final bool isBold;

  const CustomListItemText({Key? key, required this.color, required this.text, this.isBig = false, this.isBold = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: isBig ? 18 : 14,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        color: color,
      ),
    );
  }
}
