import 'package:flutter/material.dart';
import 'package:furious_app/models/compteur.dart';
import 'package:furious_app/pages/compteur/compteur_item.dart';

class CompteurList extends StatelessWidget {
  final Function deleteCompteur;
  final Function _updateCompteur;

  final List<Compteur> compteurList;

  final Map<String, Color> colorMap;

  const CompteurList(this.compteurList, this.deleteCompteur, this._updateCompteur, this.colorMap, {super.key});

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
                  fit: BoxFit.cover,
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
                      updateCompteur: _updateCompteur,
                      colorMap: colorMap,
                    ))
                .toList(),
          );
  }
}
