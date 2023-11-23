import 'package:flutter/material.dart';
import 'package:furious_app/composant/Entretien.dart';
import 'package:furious_app/widget/formfield/custom_edit_date_form_field.dart';
import 'package:furious_app/widget/formfield/custom_edit_text_form_field.dart';
import 'package:intl/intl.dart';

class UpdateEntretienAlertDialog extends StatelessWidget {
  final BuildContext context;
  final Map<String, Color> colorMap;

  final int editKilometrage;
  final double editPrix;
  final String editType;
  final DateTime selectedDate;

  final TextEditingController dateController;

  final Entretien entretien;

  final Function updateEntretien;

  const UpdateEntretienAlertDialog(
      {Key? key,
      required this.colorMap,
      required this.updateEntretien,
      required this.editKilometrage,
      required this.editPrix,
      required this.editType,
      required this.selectedDate,
      required this.entretien,
      required this.dateController,
      required this.context})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int editKilometrage = this.editKilometrage;
    double editPrix = this.editPrix;
    String editType = this.editType;
    DateTime selectedDate = this.selectedDate;

    void presentDatePicker() {
      showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2019),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              primaryColor: colorMap['primaryColor'],
              dialogBackgroundColor: colorMap['cardColor'],
              textSelectionTheme: TextSelectionThemeData(
                selectionColor: colorMap['primaryColor'],
              ),
              colorScheme: ColorScheme.dark(
                primary: colorMap['primaryColor']!,
                onPrimary: colorMap['textFieldColor']!,
                surface: colorMap['background']!,
                onSurface: colorMap['text']!,
              ),
            ),
            child: child!,
          );
        },
      ).then((pickedDate) {
        if (pickedDate == null) {
          return;
        }
        selectedDate = pickedDate;
        dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
    }

    return AlertDialog(
      backgroundColor: colorMap['cardColor'],
      title: const Text(
        'Modifier un entretien',
        style: TextStyle(
          color: Colors.green,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomEditTextFormField(
            initialValue: entretien.type,
            labelText: 'Type',
            keyboardType: TextInputType.text,
            color: colorMap['text']!,
            onChangedCallback: (value) => editType = value,
          ),
          CustomEditTextFormField(
            initialValue: entretien.prix.toString(),
            labelText: 'Prix',
            keyboardType: TextInputType.number,
            color: colorMap['text']!,
            onChangedCallback: (value) => editPrix = double.parse(value),
          ),
          CustomEditTextFormField(
            initialValue: entretien.kilometrage.toString(),
            labelText: 'Kilométrage',
            keyboardType: TextInputType.number,
            color: colorMap['text']!,
            onChangedCallback: (value) => editKilometrage = int.parse(value),
          ),
          CustomEditDateFormField(
            controller: dateController,
            labelText: 'Date',
            color: colorMap['text']!,
            onTapCallback: presentDatePicker,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Annuler',
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () {
            updateEntretien(
              entretien.id,
              editKilometrage,
              editType,
              editPrix,
              selectedDate,
            );
            Navigator.of(context).pop();
          },
          child: const Text(
            'Modifier',
            style: TextStyle(color: Colors.green),
          ),
        ),
      ],
    );
  }
}
