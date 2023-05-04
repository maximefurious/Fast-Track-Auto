import 'package:flutter/material.dart';
import 'package:furious_app/pages/entretien/entretien_item.dart';

import '../../composant/Entretien.dart';

class EntretienList extends StatelessWidget {
  final Function deleteEnt;
  final bool isDark;
  final List<Entretien> entretienList;

  const EntretienList(this.entretienList, this.deleteEnt, this.isDark, {Key? key}) : super(key: key);

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
                  color: isDark ? Colors.white : Colors.black,
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
