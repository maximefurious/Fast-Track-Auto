import 'package:flutter/material.dart';
import 'package:furious_app/models/compteur.dart';
import 'package:furious_app/pages/compteur/alerts/update_compteur_alertdialog.dart';
import 'package:furious_app/widget/custom_text/custom_carnet_text.dart';
import 'package:intl/intl.dart';

class DetailCompteurAlertDialog extends StatelessWidget {
  const DetailCompteurAlertDialog({
    super.key,
    required this.compteur,
    required this.selectedDate,
    required this.editKilometrage,
    required this.editKilometrageParcouru,
    required this.editMoyConsommation,
    required this.updateCompteur,
    required this.dateController
  });

  final Compteur compteur;

  final int editKilometrage;
  final int editKilometrageParcouru;
  final double editMoyConsommation;
  final DateTime selectedDate;

  final TextEditingController dateController;

  final void Function(Compteur e) updateCompteur;

  String _formatDate(DateTime d) => DateFormat('dd/MM/yyyy').format(d);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AlertDialog(
      backgroundColor: cs.surface,
      title: CustomCarnetText(
        color: cs.primary,
        text: 'Détails du relever',
        isBold: true,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CustomCarnetText(color: cs.onSurface, text: 'Kilométrage : ', isBold: true),
              CustomCarnetText(color: cs.onSurface, text: '${compteur.kilometrage} Km'),
            ],
          ),
          Row(
            children: [
              CustomCarnetText(color: cs.onSurface, text: 'Consommation : ', isBold: true),
              CustomCarnetText(color: cs.onSurface, text: '${compteur.moyConsommation} L/100Km'),
            ],
          ),
          Row(
            children: [
              CustomCarnetText(color: cs.onSurface, text: 'kilométrage parcouru : ', isBold: true),
              CustomCarnetText(color: cs.onSurface, text: '${compteur.kilometrageParcouru} km'),
            ],
          ),
          Row(
            children: [
              CustomCarnetText(color: cs.onSurface, text: 'Date : ', isBold: true),
              CustomCarnetText(color: cs.onSurface, text: _formatDate(selectedDate)),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: CustomCarnetText(
            color: cs.error,
            text: 'Fermer',
            isBold: true,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            showDialog(
              context: context,
              builder: (ctx) => UpdateCompteurAlertDialog(
                updateCompteur: updateCompteur,
                editKilometrage: editKilometrage,
                editKilometrageParcouru: editKilometrageParcouru,
                editMoyConsommation: editMoyConsommation,
                selectedDate: selectedDate,
                compteur: compteur,
                dateController: dateController,
              ),
            );
          },
          child: CustomCarnetText(
            color: cs.primary,
            text: 'Modifier',
            isBold: true,
          ),
        ),
      ],
    );
  }
}
