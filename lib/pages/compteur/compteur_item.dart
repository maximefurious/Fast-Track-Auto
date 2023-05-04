// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../composant/Compteur.dart';

class CompteurItem extends StatefulWidget {
  const CompteurItem({
    Key? key,
    required this.compteur,
    required this.deleteCompteur,
    required this.isDark,
  }) : super(key: key);

  final Function deleteCompteur;
  final Compteur compteur;
  final bool isDark;

  @override
  State<CompteurItem> createState() => _CompteurItemState();
}

class _CompteurItemState extends State<CompteurItem> {
  String get _formatedDate {
    final dayLessThan10 = widget.compteur.date.day < 10 ? '0' : '';
    final monthLessThan10 = widget.compteur.date.month < 10 ? '0' : '';
    return '$dayLessThan10${widget.compteur.date.day}/$monthLessThan10${widget.compteur.date.month}/${widget.compteur.date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: widget.isDark ? Colors.grey[900] : Colors.white,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      '${widget.compteur.kilometrage} Km',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 20,
                        ),
                        Text(
                          _formatedDate,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      '${widget.compteur.kilometrageParcouru} Km parcouru',
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${widget.compteur.moyConsommation} L/100Km',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
