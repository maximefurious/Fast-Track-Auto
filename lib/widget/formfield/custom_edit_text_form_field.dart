import 'package:flutter/material.dart';

class CustomEditTextFormField extends StatelessWidget {
  final String initialValue;
  final String labelText;
  final Color color;
  final TextInputType? keyboardType;
  final Function onChangedCallback;

  const CustomEditTextFormField({
    super.key,
      required this.initialValue,
      required this.labelText,
      required this.color,
      this.keyboardType,
      required this.onChangedCallback
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType ?? TextInputType.text,
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: labelText,
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
      onChanged: (value) => onChangedCallback(value),
    );
  }
}
