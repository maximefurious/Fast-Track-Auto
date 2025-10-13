import 'package:flutter/material.dart';
import 'package:furious_app/models/compteur.dart';
import 'package:furious_app/widget/custom_text/custom_carnet_text.dart';

class DeleteCompteurAlertDialog extends StatelessWidget {
  final BuildContext ctx;
  final Map<String, Color> colorMap;
  final Compteur compteur;
  final Function deleteCompteur;

  const DeleteCompteurAlertDialog({
    super.key,
      required this.ctx,
      required this.colorMap,
      required this.compteur,
      required this.deleteCompteur
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: colorMap['cardColor'],
      title: const CustomCarnetText(
        color: Colors.red,
        text: 'Supprimer un relever',
        isBold: true,
      ),
      content: CustomCarnetText(
        color: colorMap['text']!,
        text:
            'Voulez-vous vraiment supprimer cette relever kilométrique de la liste ?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const CustomCarnetText(
            color: Colors.red,
            text: 'Non',
            isBold: true,
          ),
        ),
        TextButton(
          onPressed: () {
            deleteCompteur(compteur.id);
            Navigator.of(ctx).pop();
          },
          child: const CustomCarnetText(
            color: Colors.green,
            text: 'Oui',
            isBold: true,
          ),
        ),
      ],
    );
  }
}
