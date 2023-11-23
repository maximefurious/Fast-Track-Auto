import 'package:flutter/material.dart';
import 'package:furious_app/composant/Compteur.dart';
import 'package:furious_app/widget/custom_text/custom_carnet_text.dart';
import 'package:furious_app/widget/formfield/custom_edit_date_form_field.dart';
import 'package:furious_app/widget/formfield/custom_edit_text_form_field.dart';
import 'package:intl/intl.dart';

class UpdateCompteurAlertDialog extends StatelessWidget {
  final BuildContext context;
  final Map<String, Color> colorMap;

  final int editKilometrage;
  final int editKilometrageParcouru;
  final double editMoyConsommation;
  final DateTime selectedDate;

  final TextEditingController dateController;

  final Compteur compteur;

  final Function updateCompteur;

  const UpdateCompteurAlertDialog(
      {Key? key,
      required this.colorMap,
      required this.updateCompteur,
      required this.editKilometrage,
      required this.editKilometrageParcouru,
      required this.editMoyConsommation,
      required this.selectedDate,
      required this.compteur,
      required this.dateController,
      required this.context})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int editKilometrage = this.editKilometrage;
    int editKilometrageParcouru = this.editKilometrageParcouru;
    double editMoyConsommation = this.editMoyConsommation;
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
      title: CustomCarnetText(
        color: colorMap['text']!,
        text: 'Modifier',
        isBold: true,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomEditTextFormField(
            initialValue: compteur.kilometrage.toString(),
            labelText: 'Kilométrage',
            color: colorMap['text']!,
            keyboardType: TextInputType.number,
            onChangedCallback: (value) => editKilometrage = int.parse(value),
          ),
          CustomEditTextFormField(
            initialValue: compteur.kilometrageParcouru.toString(),
            labelText: 'kilométrage parcouru',
            color: colorMap['text']!,
            keyboardType: TextInputType.number,
            onChangedCallback: (value) =>
                editKilometrageParcouru = int.parse(value),
          ),
          CustomEditTextFormField(
            initialValue: compteur.moyConsommation.toString(),
            labelText: 'Consommation',
            color: colorMap['text']!,
            keyboardType: TextInputType.number,
            onChangedCallback: (value) =>
                editMoyConsommation = double.parse(value),
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
          onPressed: () => Navigator.of(context).pop(),
          child: const CustomCarnetText(
            color: Colors.red,
            text: 'Annuler',
            isBold: true,
          ),
        ),
        TextButton(
          onPressed: () {
            updateCompteur(
              compteur.id,
              editKilometrage,
              selectedDate,
              editKilometrageParcouru,
              editMoyConsommation,
            );
            Navigator.of(context).pop();
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
