import 'package:flutter/material.dart';
import 'package:furious_app/composant/Entretien.dart';
import 'package:furious_app/widget/custom_text/custom_carnet_text.dart';

class DeleteEntretienAlertDialog extends StatelessWidget {
  final BuildContext ctx;
  final Map<String, Color> colorMap;
  final Entretien entretien;
  final Function deleteEntretien;

  const DeleteEntretienAlertDialog(
      {Key? key,
      required this.ctx,
      required this.colorMap,
      required this.entretien,
      required this.deleteEntretien})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: colorMap['cardColor'],
      title: const Text(
        'Supprimer un Entretien',
        style: TextStyle(
          color: Colors.red,
        ),
      ),
      content: CustomCarnetText(
        color: colorMap['text']!,
        text: 'Voulez-vous vraiment supprimer cette entretien de la liste ?',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop(false);
          },
          child: const Text(
            'Non',
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            deleteEntretien(entretien.id);
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
