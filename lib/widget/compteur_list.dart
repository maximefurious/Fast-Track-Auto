import 'package:flutter/material.dart';
import 'package:furious_app/composant/Compteur.dart';
import 'package:furious_app/pages/entretien_item.dart';
import 'package:furious_app/widget/CompteurItem.dart';

import '../composant/Entretien.dart';

class CompteurList extends StatelessWidget {
  final List<Compteur> compteurList;
  final Function deleteCompteur;

  CompteurList(this.compteurList, this.deleteCompteur);

  @override
  Widget build(BuildContext context) {
    return compteurList.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Aucun Kilometrage enregistré',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          )
        : ListView(
            children: compteurList
                .map((compteur) => CompteurItem(
                      key: ValueKey(compteur.id),
                      compteur: compteur,
                      deleteCompteur: deleteCompteur,
                    ))
                .toList(),
          );
  }
}
