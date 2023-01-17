import 'package:flutter/material.dart';

import '../composant/Compteur.dart';

class CompteurItem extends StatefulWidget {
  const CompteurItem({
    Key? key,
    @required this.compteur,
    @required this.deleteCompteur,
  }) : super(key: key);

  final Compteur? compteur;
  final Function? deleteCompteur;

  @override
  State<CompteurItem> createState() => _CompteurItemState();
}

class _CompteurItemState extends State<CompteurItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    widget.compteur!.kilometrage.toString() + ' Km',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                    child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 20,
                    ),
                    Text(
                      widget.compteur!.date.day.toString() +
                          '/' +
                          widget.compteur!.date.month.toString() +
                          '/' +
                          widget.compteur!.date.year.toString(),
                    ),
                  ],
                )),
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
                    widget.compteur!.kilometrageParcouru.toString() +
                        ' Km parcouru',
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.compteur!.moyConsommation.toString() + ' L/100Km',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
