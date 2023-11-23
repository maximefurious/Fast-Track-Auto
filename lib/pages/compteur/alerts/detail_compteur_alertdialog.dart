import 'package:flutter/material.dart';
import 'package:furious_app/composant/Compteur.dart';
import 'package:furious_app/pages/compteur/alerts/update_compteur_alertdialog.dart';
import 'package:furious_app/widget/custom_text/custom_carnet_text.dart';

class DetailCompteurAlertDialog extends StatelessWidget {
  final BuildContext context;
  final Map<String, Color> colorMap;

  final int editKilometrage;
  final int editKilometrageParcouru;
  final double editMoyConsommation;
  final DateTime selectedDate;

  final TextEditingController dateController;

  final Compteur compteur;

  final Function updateCompteur;

  const DetailCompteurAlertDialog(
      {Key? key,
      required this.colorMap,
      required this.compteur,
      required this.selectedDate,
      required this.context,
      required this.editKilometrage,
      required this.editKilometrageParcouru,
      required this.editMoyConsommation,
      required this.updateCompteur,
      required this.dateController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int editKilometrage = this.editKilometrage;
    int editKilometrageParcouru = this.editKilometrageParcouru;
    double editMoyConsommation = this.editMoyConsommation;
    DateTime selectedDate = this.selectedDate;

    return AlertDialog(
      backgroundColor: colorMap['cardColor'],
      title: CustomCarnetText(
        color: colorMap['text']!,
        text: 'Détails',
        isBold: true,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CustomCarnetText(
                color: colorMap['text']!,
                text: 'Kilométrage : ',
                isBold: true,
              ),
              CustomCarnetText(
                color: colorMap['text']!,
                text: '${compteur.kilometrage} Km',
              ),
            ],
          ),
          Row(
            children: [
              CustomCarnetText(
                color: colorMap['text']!,
                text: 'Consommation : ',
                isBold: true,
              ),
              CustomCarnetText(
                color: colorMap['text']!,
                text: '${compteur.moyConsommation} L/100Km',
              ),
            ],
          ),
          Row(
            children: [
              CustomCarnetText(
                color: colorMap['text']!,
                text: 'kilométrage parcouru : ',
                isBold: true,
              ),
              CustomCarnetText(
                color: colorMap['text']!,
                text: '${compteur.kilometrageParcouru} km',
              ),
            ],
          ),
          Row(
            children: [
              CustomCarnetText(
                color: colorMap['text']!,
                text: 'Date : ',
                isBold: true,
              ),
              CustomCarnetText(
                color: colorMap['text']!,
                text:
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Fermer',
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            showDialog(
              context: context,
              builder: (ctx) => UpdateCompteurAlertDialog(
                colorMap: colorMap,
                updateCompteur: updateCompteur,
                editKilometrage: editKilometrage,
                editKilometrageParcouru: editKilometrageParcouru,
                editMoyConsommation: editMoyConsommation,
                selectedDate: selectedDate,
                compteur: compteur,
                dateController: dateController,
                context: ctx,
              ),
            );
          },
          child: const Text(
            'Modifier',
            style: TextStyle(color: Colors.green),
          ),
        ),
      ],
    );
  }
}
