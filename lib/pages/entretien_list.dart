import 'package:flutter/material.dart';
import 'package:furious_app/pages/entretien_item.dart';

import '../composant/Entretien.dart';

class EntretienList extends StatelessWidget {
  final Function deleteEnt;
  final int isDark;
  final List<Entretien> entretienList;

  EntretienList(this.entretienList, this.deleteEnt, this.isDark);

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
                  color: isDark == 1 ? Colors.white : Colors.black,
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
                      isDark: isDark,
                    ))
                .toList(),
          );
  }
}
