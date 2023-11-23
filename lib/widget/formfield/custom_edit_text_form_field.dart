import 'package:flutter/material.dart';

class CustomEditTextFormField extends StatelessWidget {
  final String initialValue;
  final String labelText;
  final Color color;
  final TextInputType? keyboardType;
  final Function onChangedCallback;

  const CustomEditTextFormField(
      {Key? key,
      required this.initialValue,
      required this.labelText,
      required this.color,
      this.keyboardType,
      required this.onChangedCallback})
      : super(key: key);

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
