import 'package:flutter/material.dart';
import 'package:furious_app/pages/entretien_item.dart';

import '../composant/Entretien.dart';

class EntretienList extends StatelessWidget {
  final List<Entretien> entretienList;
  final Function deleteEnt;

  EntretienList(this.entretienList, this.deleteEnt);

  @override
  Widget build(BuildContext context) {
    return entretienList.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Aucun entretien',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          )
        : ListView(
            children: entretienList
                .map((ent) => EntretienItem(
                      key: ValueKey(ent.id),
                      entretien: ent,
                      deleteEnt: deleteEnt,
                    ))
                .toList(),
          );
  }
}
