import 'package:flutter/material.dart';
import 'package:furious_app/composant/Entretien.dart';
import 'package:furious_app/pages/entretien/alerts/update_entretien_alertdialog.dart';
import 'package:furious_app/widget/custom_text/custom_carnet_text.dart';

class DetailEntretienAlertDialog extends StatelessWidget {
  final BuildContext context;
  final Map<String, Color> colorMap;

  final int editKilometrage;
  final double editPrix;
  final String editType;
  final DateTime selectedDate;

  final TextEditingController dateController;

  final Entretien entretien;

  final Function updateEntretien;

  const DetailEntretienAlertDialog(
      {Key? key,
      required this.colorMap,
      required this.entretien,
      required this.selectedDate,
      required this.context,
      required this.editKilometrage,
      required this.editPrix,
      required this.editType,
      required this.updateEntretien,
      required this.dateController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int editKilometrage = this.editKilometrage;
    double editPrix = this.editPrix;
    String editType = this.editType;
    DateTime selectedDate = this.selectedDate;

    return AlertDialog(
      backgroundColor: colorMap['cardColor'],
      title: const CustomCarnetText(
        color: Colors.green,
        text: 'Détails de l\'entretien',
        isBold: true,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CustomCarnetText(
                color: colorMap['text']!,
                text: 'Type : ',
                isBold: true,
              ),
              CustomCarnetText(
                color: colorMap['text']!,
                text: entretien.type,
              ),
            ],
          ),
          Row(
            children: [
              CustomCarnetText(
                color: colorMap['text']!,
                text: 'Prix : ',
                isBold: true,
              ),
              CustomCarnetText(
                color: colorMap['text']!,
                text: '${entretien.prix}€',
              ),
            ],
          ),
          Row(
            children: [
              CustomCarnetText(
                color: colorMap['text']!,
                text: 'Kilométrage : ',
                isBold: true,
              ),
              CustomCarnetText(
                color: colorMap['text']!,
                text: '${entretien.kilometrage} km',
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
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const CustomCarnetText(
            color: Colors.red,
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
                colorMap: colorMap,
                updateEntretien: updateEntretien,
                editKilometrage: editKilometrage,
                editPrix: editPrix,
                editType: editType,
                selectedDate: selectedDate,
                entretien: entretien,
                dateController: dateController,
                context: ctx,
              ),
            );
          },
          child: const CustomCarnetText(
            color: Colors.green,
            text: 'Modifier',
            isBold: true,
          ),
        ),
      ],
    );
  }
}
