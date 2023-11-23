import 'package:flutter/material.dart';
import 'package:furious_app/composant/Compteur.dart';
import 'package:furious_app/widget/custom_text/custom_carnet_text.dart';

class DeleteCompteurAlertDialog extends StatelessWidget {
  final BuildContext ctx;
  final Map<String, Color> colorMap;
  final Compteur compteur;
  final Function deleteCompteur;

  const DeleteCompteurAlertDialog(
      {Key? key,
      required this.ctx,
      required this.colorMap,
      required this.compteur,
      required this.deleteCompteur})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: colorMap['cardColor'],
      title: const Text(
        'Supprimer',
        style: TextStyle(color: Colors.red),
      ),
      content: CustomCarnetText(
        color: colorMap['text']!,
        text:
            'Voulez-vous vraiment supprimer cette enregistrement kilométrique ?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text(
            'Non',
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () {
            deleteCompteur(compteur.id);
            Navigator.of(ctx).pop();
          },
          child: const Text(
            'Oui',
            style: TextStyle(color: Colors.green),
          ),
        ),
      ],
    );
  }
}
