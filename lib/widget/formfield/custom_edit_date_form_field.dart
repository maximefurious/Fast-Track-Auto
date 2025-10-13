import 'package:flutter/material.dart';

class CustomEditDateFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final Color color;
  final Function onTapCallback;

  const CustomEditDateFormField({
    super.key,
      required this.controller,
      required this.labelText,
      required this.color,
      required this.onTapCallback
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Date',
        labelStyle: TextStyle(
          color: color,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: color,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: color,
          ),
        ),
      ),
      style: TextStyle(
        color: color,
      ),
      onTap: () => onTapCallback(),
    );
  }
}
