import 'package:flutter/material.dart';

class BoxInfoWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const BoxInfoWidget(
      {Key? key, required this.icon, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5, // étendue de l'ombre
              blurRadius: 7, // flou de l'ombre
              offset: const Offset(0, 3), // position de l'ombre
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 30,
              color: const Color(0xFF808080),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF808080),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF303030),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
