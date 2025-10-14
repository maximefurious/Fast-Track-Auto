import 'package:flutter/material.dart';
import 'package:furious_app/models/compteur.dart';
import 'package:furious_app/widget/custom_text/custom_carnet_text.dart';
import 'package:furious_app/widget/formfield/custom_edit_date_form_field.dart';
import 'package:furious_app/widget/formfield/custom_edit_text_form_field.dart';
import 'package:intl/intl.dart';

class UpdateCompteurAlertDialog extends StatelessWidget {
  const UpdateCompteurAlertDialog({
    super.key,
    required this.updateCompteur,
    required this.editKilometrage,
    required this.editKilometrageParcouru,
    required this.editMoyConsommation,
    required this.selectedDate,
    required this.compteur,
    required this.dateController,
  });

  final Compteur compteur;
  final int editKilometrage;
  final int editKilometrageParcouru;
  final double editMoyConsommation;
  final DateTime selectedDate;
  final TextEditingController dateController;

  final void Function(Compteur e) updateCompteur;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    int km = editKilometrage;
    int kmParcouru = editKilometrageParcouru;
    double moyConso = editMoyConsommation;
    DateTime date = selectedDate;

    Future<void> presentDatePicker() async {
      final picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2019),
        lastDate: DateTime.now(),
      );
      if (picked != null) {
        date = picked;
        dateController.text = DateFormat('dd/MM/yyyy').format(date);
      }
    }

    return AlertDialog(
      backgroundColor: cs.surface,
      title: CustomCarnetText(color: cs.primary, text: 'Modifier', isBold: true,),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomEditTextFormField(
            initialValue: compteur.kilometrage.toString(),
            labelText: 'Kilométrage',
            color: cs.onSurface,
            keyboardType: TextInputType.number,
            onChangedCallback: (value) => km = int.parse(value),
          ),
          CustomEditTextFormField(
            initialValue: compteur.kilometrageParcouru.toString(),
            labelText: 'kilométrage parcouru',
            color: cs.onSurface,
            keyboardType: TextInputType.number,
            onChangedCallback: (value) => kmParcouru = int.parse(value),
          ),
          CustomEditTextFormField(
            initialValue: compteur.moyConsommation.toString(),
            labelText: 'Consommation',
            color: cs.onSurface,
            keyboardType: TextInputType.number,
            onChangedCallback: (value) => moyConso = double.parse(value),
          ),
          CustomEditDateFormField(
            controller: dateController,
            labelText: 'Date',
            color: cs.onSurface,
            onTapCallback: presentDatePicker,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: CustomCarnetText(color: cs.error, text: 'Annuler', isBold: true,),
        ),
        TextButton(
          onPressed: () {
            final updated = compteur.copyWith(
              kilometrage: km,
              kilometrageParcouru: kmParcouru,
              moyConsommation: moyConso,
              date: selectedDate,
            );


            updateCompteur(updated);
            Navigator.of(context).pop();
          },
          child: CustomCarnetText(color: cs.primary, text: 'Modifier', isBold: true,),
        ),
      ],
    );
  }
}
