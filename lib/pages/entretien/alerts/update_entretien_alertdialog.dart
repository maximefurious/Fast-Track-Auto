import 'package:flutter/material.dart';
import 'package:furious_app/models/entretien.dart';
import 'package:furious_app/widget/custom_text/custom_carnet_text.dart';
import 'package:furious_app/widget/formfield/custom_edit_date_form_field.dart';
import 'package:furious_app/widget/formfield/custom_edit_text_form_field.dart';
import 'package:intl/intl.dart';

class UpdateEntretienAlertDialog extends StatelessWidget {
  const UpdateEntretienAlertDialog({
    super.key,
    required this.entretien,
    required this.editKilometrage,
    required this.editPrix,
    required this.editType,
    required this.selectedDate,
    required this.dateController,
    required this.updateEntretien,
  });

  final Entretien entretien;
  final int editKilometrage;
  final double editPrix;
  final String editType;
  final DateTime selectedDate;
  final TextEditingController dateController;

  // CHANGE: expects an Entretien
  final void Function(Entretien e) updateEntretien;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    int km = editKilometrage;
    double prix = editPrix;
    String type = editType;
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
      title: Text('Modifier un entretien',
          style: TextStyle(color: cs.primary, fontWeight: FontWeight.w700)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomEditTextFormField(
            initialValue: entretien.type,
            labelText: 'Type',
            keyboardType: TextInputType.text,
            color: cs.onSurface,
            onChangedCallback: (v) => type = v,
          ),
          CustomEditTextFormField(
            initialValue: entretien.prix.toString(),
            labelText: 'Prix',
            keyboardType: TextInputType.number,
            color: cs.onSurface,
            onChangedCallback: (v) {
              final x = double.tryParse(v.replaceAll(',', '.'));
              if (x != null) prix = x;
            },
          ),
          CustomEditTextFormField(
            initialValue: entretien.kilometrage.toString(),
            labelText: 'Kilométrage',
            keyboardType: TextInputType.number,
            color: cs.onSurface,
            onChangedCallback: (v) {
              final x = int.tryParse(v);
              if (x != null) km = x;
            },
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
          child: CustomCarnetText(color: cs.error, text: 'Annuler', isBold: true),
        ),
        TextButton(
          onPressed: () {
            final updated = entretien.copyWith(
              kilometrage: km,
              type: type,
              prix: prix,
              date: date,
            );

            updateEntretien(updated);
            Navigator.of(context).pop();
          },
          child: CustomCarnetText(color: cs.primary, text: 'Modifier', isBold: true),
        ),
      ],
    );
  }
}
