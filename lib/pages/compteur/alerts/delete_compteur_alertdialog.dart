import 'package:flutter/material.dart';
import 'package:furious_app/models/compteur.dart';
import 'package:furious_app/widget/custom_text/custom_carnet_text.dart';

class DeleteCompteurAlertDialog extends StatelessWidget {
  const DeleteCompteurAlertDialog({
    super.key,
      required this.compteur,
      required this.deleteCompteur
  });

  final Compteur compteur;
  final void Function(String id) deleteCompteur;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return AlertDialog(
      backgroundColor: cs.surface,
      title: CustomCarnetText(
        color: cs.error,
        text: 'Supprimer un relever',
        isBold: true,
      ),
      content: CustomCarnetText(
        color: cs.onSurface,
        text:
            'Voulez-vous vraiment supprimer cette relever kilométrique de la liste ?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: CustomCarnetText(
            color: cs.error,
            text: 'Non',
            isBold: true,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            deleteCompteur(compteur.id);
          },
          style: TextButton.styleFrom(
            foregroundColor: cs.primary,
          ),
          child: CustomCarnetText(
            color: cs.onSurface,
            text: 'Oui',
            isBold: true,
          ),
        ),
      ],
    );
  }
}
