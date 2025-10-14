import 'package:flutter/material.dart';
import 'package:furious_app/models/entretien.dart';
import 'package:furious_app/pages/entretien/alerts/update_entretien_alertdialog.dart';
import 'package:furious_app/widget/custom_text/custom_carnet_text.dart';
import 'package:intl/intl.dart';

class DetailEntretienAlertDialog extends StatelessWidget {
  const DetailEntretienAlertDialog({
    super.key,
    required this.entretien,
    required this.selectedDate,
    required this.editKilometrage,
    required this.editPrix,
    required this.editType,
    required this.updateEntretien,
    required this.dateController,
  });

  final Entretien entretien;

  final int editKilometrage;
  final double editPrix;
  final String editType;
  final DateTime selectedDate;

  final TextEditingController dateController;

  final void Function(Entretien e) updateEntretien;

  String _formatDate(DateTime d) => DateFormat('dd/MM/yyyy').format(d);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AlertDialog(
      backgroundColor: cs.surface,
      title: CustomCarnetText(
        color: cs.primary,
        text: 'Détails de l\'entretien',
        isBold: true,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CustomCarnetText(color: cs.onSurface, text: 'Type : ', isBold: true),
              CustomCarnetText(color: cs.onSurface, text: entretien.type),
            ],
          ),
          Row(
            children: [
              CustomCarnetText(color: cs.onSurface, text: 'Prix : ', isBold: true),
              CustomCarnetText(color: cs.onSurface, text: '${entretien.prix}€'),
            ],
          ),
          Row(
            children: [
              CustomCarnetText(color: cs.onSurface, text: 'Kilométrage : ', isBold: true),
              CustomCarnetText(color: cs.onSurface, text: '${entretien.kilometrage} km'),
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
              builder: (ctx) => UpdateEntretienAlertDialog(
                entretien: entretien,
                editKilometrage: editKilometrage,
                editPrix: editPrix,
                editType: editType,
                selectedDate: selectedDate,
                dateController: dateController,
                updateEntretien: updateEntretien,
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
