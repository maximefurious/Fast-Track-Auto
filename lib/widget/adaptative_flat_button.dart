import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final String text;
  final Function handler;
  final Map<String, Color> colorMap;

  const AdaptiveFlatButton(this.text, this.handler, this.colorMap, {super.key});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorMap['primaryColor']!,
              ),
            ),
            onPressed: () => handler(),
          )
        : TextButton(
            style: TextButton.styleFrom(
              foregroundColor: colorMap['primaryColor']!,
            ),
            child: Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorMap['primaryColor']!),
            ),
            onPressed: () => handler(),
          );
  }
}
