import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:furious_app/pages/entretien/entretien_item.dart';

import '../../composant/Entretien.dart';

class EntretienList extends StatelessWidget {
  final Function deleteEnt;
  final Function _updateEntretien;

  final List<Entretien> entretienList;

  final HashMap<String, Color> colorMap;

  const EntretienList(
      this.entretienList, this.deleteEnt, this._updateEntretien, this.colorMap,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return entretienList.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Aucun entretien',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorMap['text'],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 100,
                child: Image.asset(
                  'assets/images/waiting.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ],
          )
        : ListView(
            children: entretienList
                .map((ent) => EntretienItem(
                      key: ValueKey(ent.id),
                      entretien: ent,
                      deleteEnt: deleteEnt,
                      updateEntretien: _updateEntretien,
                      colorMap: colorMap,
                    ))
                .toList(),
          );
  }
}
