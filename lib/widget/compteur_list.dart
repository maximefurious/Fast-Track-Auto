import 'package:flutter/material.dart';
import 'package:furious_app/composant/Compteur.dart';
import 'package:furious_app/pages/entretien_item.dart';
import 'package:furious_app/widget/CompteurItem.dart';

import '../composant/Entretien.dart';

class CompteurList extends StatelessWidget {
  final List<Compteur> compteurList;
  final Function deleteCompteur;
  final int isDark;

  CompteurList(this.compteurList, this.deleteCompteur, this.isDark);

  @override
  Widget build(BuildContext context) {
    return compteurList.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Aucun Kilometrage enregistré',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark == 1 ? Colors.white : Colors.black,
                ), 
              ),
            ],
          )
        : ListView(
            children: compteurList
                .map((compteur) => CompteurItem(
                      key: ValueKey(compteur.id),
                      compteur: compteur,
                      deleteCompteur: deleteCompteur,
                      isDark: isDark,
                    ))
                .toList(),
          );
  }
}
