import 'package:flutter/material.dart';
import 'package:furious_app/composant/Compteur.dart';
import 'package:furious_app/pages/compteur/compteur_item.dart';

class CompteurList extends StatelessWidget {
  final List<Compteur> compteurList;
  final Function deleteCompteur;
  final bool isDark;

  const CompteurList(this.compteurList, this.deleteCompteur, this.isDark,
      {Key? key})
      : super(key: key);

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
                  color: isDark ? Colors.white : Colors.black,
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
