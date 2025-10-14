import 'package:flutter/material.dart';
import 'package:furious_app/models/entretien.dart';
import 'package:furious_app/widget/custom_text/custom_carnet_text.dart';

class DeleteEntretienAlertDialog extends StatelessWidget {
  const DeleteEntretienAlertDialog({
    super.key,
    required this.entretien,
    required this.deleteEntretien,
  });

  final Entretien entretien;
  final void Function(String id) deleteEntretien;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return AlertDialog(
      backgroundColor: cs.surface,
      title: CustomCarnetText(
        color: cs.error,
        text: 'Supprimer un Entretien',
        isBold: true,
      ),
      content: CustomCarnetText(
        color: cs.onSurface,
        text: 'Voulez-vous vraiment supprimer cet entretien de la liste ?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(
            foregroundColor: cs.error,
          ),
          child: CustomCarnetText(
            color: cs.error,
            text: 'Non',
            isBold: true,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            deleteEntretien(entretien.id);
          },
          style: TextButton.styleFrom(
            foregroundColor: cs.primary,
          ),
          child: CustomCarnetText(
            color: Colors.green, // ou cs.primary si tu veux tout thématiser
            text: 'Oui',
            isBold: true,
          ),
        ),
      ],
    );
  }
}
